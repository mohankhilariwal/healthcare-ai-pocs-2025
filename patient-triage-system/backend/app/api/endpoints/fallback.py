from fastapi import APIRouter, Request

router = APIRouter()

@router.post("/{path:path}")
async def catch_all(request: Request, path: str):
    body = await request.json()
    prompt = f"Healthcare task: {path}\nInput: {body}\nRespond professionally as a clinician."
    from app.services.claude_service import generate_with_claude
    try:
        result = generate_with_claude(prompt)
        return {"response": result}
    except Exception as e:
        return {"error": str(e)}
