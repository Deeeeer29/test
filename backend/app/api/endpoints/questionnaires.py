from fastapi import APIRouter

router = APIRouter()


@router.get("")
async def list_questionnaires():
    return {"success": True, "data": []}
