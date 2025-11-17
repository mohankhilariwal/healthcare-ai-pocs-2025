from fastapi import APIRouter
from pydantic import BaseModel
from app.services.claude_service import generate_with_claude
router = APIRouter()
class Req(BaseModel): diagnosis: str; patient_profile: str
@router.post("/generate_plan")
def f(r: Req): return {"plan": generate_with_claude(f"Diagnosis: {r.diagnosis}\nPatient: {r.patient_profile}\nCreate full evidence-based treatment plan")}
