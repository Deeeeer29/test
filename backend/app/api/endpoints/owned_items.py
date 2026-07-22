from fastapi import APIRouter

router = APIRouter()


@router.get("")
async def list_owned_items():
    return {"success": True, "data": []}
