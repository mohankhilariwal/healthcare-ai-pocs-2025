from fastapi import APIRouter
from pydantic import BaseModel
from app.services.claude_service import generate_with_claude
router = APIRouter()
class Req(BaseModel): symptoms: str = ""
@router.post("/diagnose")
def f(r: Req): return {"diagnosis": generate_with_claude(f"Symptoms: {r.symptoms}\nTop 5 differentials with reasoning")}
