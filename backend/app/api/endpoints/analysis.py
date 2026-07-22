from fastapi import APIRouter

router = APIRouter()


@router.get("")
async def list_analysis_results():
    return {"success": True, "data": []}
