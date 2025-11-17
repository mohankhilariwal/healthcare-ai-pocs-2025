from fastapi import APIRouter
from pydantic import BaseModel
from app.services.claude_service import generate_with_claude
router = APIRouter()
class Req(BaseModel): chief_complaint: str; vitals: str = ""
@router.post("/triage")
def f(r: Req): return {"triage": generate_with_claude(f"Chief complaint: {r.chief_complaint}\nVitals: {r.vitals}\nReturn only: ESI Level X – short reason")}
