from fastapi import APIRouter

router = APIRouter()


@router.get("")
async def list_purchase_reviews():
    return {"success": True, "data": []}
