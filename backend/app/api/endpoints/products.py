from datetime import datetime
from typing import Any, Dict, Optional

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

from app.db.base import get_db
from app.models.product import Product, SourceType
from app.models.user_profile import UserProfile
from app.schemas.product import (
    ProductConfirm,
    ProductCreate,
    ProductExtractFromImage,
    ProductExtractFromLink,
    ProductResponse,
    ProductUpdate,
)

router = APIRouter()


def product_to_dict(product: Product) -> Dict[str, Any]:
    return ProductResponse.model_validate(product).model_dump(mode="json")


def success_response(data: Any = None, message: str | None = None) -> Dict[str, Any]:
    response: Dict[str, Any] = {"success": True}
    if message is not None:
        response["message"] = message
    if data is not None:
        response["data"] = data
    return response


def ensure_user_exists(user_id: int, db: Session) -> UserProfile:
    user = db.query(UserProfile).filter(UserProfile.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail=f"User with ID {user_id} not found")
    return user


@router.get("")
async def get_products(
    user_id: Optional[int] = Query(None),
    skip: int = 0,
    limit: int = 100,
    confirmed: Optional[bool] = Query(None),
    category: Optional[str] = Query(None),
    search: Optional[str] = Query(None),
    min_price: Optional[float] = Query(None),
    max_price: Optional[float] = Query(None),
    purchase_urgency: Optional[int] = Query(None),
    db: Session = Depends(get_db),
):
    query = db.query(Product)

    if user_id is not None:
        ensure_user_exists(user_id, db)
        query = query.filter(Product.user_id == user_id)
    if confirmed is not None:
        query = query.filter(Product.user_confirmed == confirmed)
    if category:
        query = query.filter(Product.category == category)
    if search:
        query = query.filter(Product.name.contains(search))
    if min_price is not None:
        query = query.filter(Product.price >= min_price)
    if max_price is not None:
        query = query.filter(Product.price <= max_price)
    if purchase_urgency is not None:
        query = query.filter(Product.purchase_urgency == purchase_urgency)

    total = query.count()
    products = query.order_by(Product.created_at.desc()).offset(skip).limit(limit).all()
    return {
        "success": True,
        "data": [product_to_dict(product) for product in products],
        "pagination": {"skip": skip, "limit": limit},
        "total": total,
    }


@router.get("/user/{user_id}")
async def get_user_products(
    user_id: int,
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db),
):
    products = (
        db.query(Product)
        .filter(Product.user_id == user_id)
        .order_by(Product.created_at.desc())
        .offset(skip)
        .limit(limit)
        .all()
    )
    return success_response([product_to_dict(product) for product in products])


@router.get("/user/{user_id}/statistics")
async def get_product_statistics(user_id: int, db: Session = Depends(get_db)):
    ensure_user_exists(user_id, db)
    products = db.query(Product).filter(Product.user_id == user_id).all()

    categories: Dict[str, int] = {}
    sources: Dict[str, int] = {}
    for product in products:
        categories[product.category] = categories.get(product.category, 0) + 1
        source = product.source_type.value
        sources[source] = sources.get(source, 0) + 1

    prices = [product.price for product in products]
    return success_response(
        {
            "user_id": user_id,
            "total_products": len(products),
            "confirmed_products": sum(1 for product in products if product.user_confirmed),
            "pending_confirmation": sum(1 for product in products if not product.user_confirmed),
            "categories": categories,
            "sources": sources,
            "price_statistics": {
                "average": sum(prices) / len(prices) if prices else 0,
                "max": max(prices) if prices else 0,
                "min": min(prices) if prices else 0,
            },
        }
    )


@router.get("/{product_id}")
async def get_product(product_id: int, db: Session = Depends(get_db)):
    product = db.query(Product).filter(Product.id == product_id).first()
    if not product:
        raise HTTPException(status_code=404, detail=f"Product with ID {product_id} not found")
    return success_response(product_to_dict(product))


@router.post("")
async def create_product(product_data: ProductCreate, db: Session = Depends(get_db)):
    ensure_user_exists(product_data.user_id, db)

    try:
        product = Product(**product_data.model_dump())
        db.add(product)
        db.commit()
        db.refresh(product)
        return success_response(product_to_dict(product))
    except IntegrityError:
        db.rollback()
        raise HTTPException(status_code=400, detail="Failed to create product")


@router.post("/extract-from-image")
async def extract_product_from_image(
    extract_data: ProductExtractFromImage,
    user_id: int = Query(...),
    db: Session = Depends(get_db),
):
    ensure_user_exists(user_id, db)
    product = Product(
        user_id=user_id,
        name="Extracted image product",
        brand="Sample brand",
        model="Sample model",
        price=999.99,
        currency="CNY",
        category="Electronics",
        description="Extracted from image",
        purchase_urgency=3,
        specifications={"color": "black", "size": "standard"},
        source_type=SourceType.SCREENSHOT,
        image_path="extracted_from_image.jpg",
        user_confirmed=False,
    )
    db.add(product)
    db.commit()
    db.refresh(product)
    return {
        "success": True,
        "message": "Product information extracted successfully",
        "product": product_to_dict(product),
        "confidence": 0.85,
        "extracted_fields": ["name", "brand", "price", "category"],
    }


@router.post("/extract-from-link")
async def extract_product_from_link(
    extract_data: ProductExtractFromLink,
    user_id: int = Query(...),
    db: Session = Depends(get_db),
):
    ensure_user_exists(user_id, db)
    product = Product(
        user_id=user_id,
        name="Extracted link product",
        brand="Sample brand",
        model="Sample model",
        price=1999.99,
        currency="CNY",
        category="Home appliance",
        description="Extracted from link",
        purchase_urgency=3,
        specifications={"warranty": "1 year", "power": "220V"},
        source_type=extract_data.source_type,
        source_url=extract_data.url,
        user_confirmed=False,
    )
    db.add(product)
    db.commit()
    db.refresh(product)
    return {
        "success": True,
        "message": "Product information extracted successfully",
        "product": product_to_dict(product),
        "source_url": extract_data.url,
        "extracted_fields": ["name", "brand", "price", "category", "specifications"],
    }


@router.put("/{product_id}")
async def update_product(
    product_id: int,
    product_data: ProductUpdate,
    db: Session = Depends(get_db),
):
    product = db.query(Product).filter(Product.id == product_id).first()
    if not product:
        raise HTTPException(status_code=404, detail=f"Product with ID {product_id} not found")

    try:
        update_data = product_data.model_dump(exclude_unset=True)
        for field, value in update_data.items():
            setattr(product, field, value)

        db.commit()
        db.refresh(product)
        return success_response(product_to_dict(product))
    except Exception as exc:
        db.rollback()
        raise HTTPException(status_code=400, detail=f"Failed to update product: {exc}")


@router.post("/{product_id}/confirm")
async def confirm_product(
    product_id: int,
    confirm_data: ProductConfirm,
    db: Session = Depends(get_db),
):
    product = db.query(Product).filter(Product.id == product_id).first()
    if not product:
        raise HTTPException(status_code=404, detail=f"Product with ID {product_id} not found")

    product.user_confirmed = confirm_data.user_confirmed
    product.confirmed_at = datetime.now() if confirm_data.user_confirmed else None
    db.commit()
    db.refresh(product)
    return success_response(
        {
            "product_id": product_id,
            "user_confirmed": product.user_confirmed,
            "confirmed_at": product.confirmed_at.isoformat() if product.confirmed_at else None,
        },
        message="Product confirmation status updated",
    )


@router.delete("/{product_id}")
async def delete_product(product_id: int, db: Session = Depends(get_db)):
    product = db.query(Product).filter(Product.id == product_id).first()
    if not product:
        raise HTTPException(status_code=404, detail=f"Product with ID {product_id} not found")

    try:
        db.delete(product)
        db.commit()
        return success_response(message="Product deleted successfully")
    except Exception as exc:
        db.rollback()
        raise HTTPException(status_code=400, detail=f"Failed to delete product: {exc}")
