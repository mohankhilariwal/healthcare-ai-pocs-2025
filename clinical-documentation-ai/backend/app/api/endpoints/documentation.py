from fastapi import APIRouter, Depends
from pydantic import BaseModel
from app.services.claude_service import generate_with_claude

router = APIRouter()

class DocumentationRequest(BaseModel):
    patient_notes: str

@router.post("/generate_documentation")
def generate_documentation(request: DocumentationRequest):
    prompt = f"Generate clinical documentation from: {request.patient_notes}"
    return {"documentation": generate_with_claude(prompt)}
