from fastapi import APIRouter

router = APIRouter()


@router.get("")
async def list_cooling_items():
    return {"success": True, "data": []}
