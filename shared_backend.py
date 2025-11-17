from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from anthropic import Anthropic
import os
from dotenv import load_dotenv
load_dotenv()

app = FastAPI()
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_methods=["*"], allow_headers=["*"])

client = Anthropic(api_key=os.getenv("ANTHROPIC_API_KEY"))

def claude(prompt: str) -> str:
    msg = client.messages.create(
        model="claude-sonnet-4-5-20250929",   # ← THIS IS THE ONLY CHANGE
        max_tokens=1024,
        temperature=0.3,
        messages=[{"role": "user", "content": prompt}]
    )
    return msg.content[0].text

@app.post("/{path:path}")
async def everything(request: Request, path: str):
    body = await request.json()
    text = str(body)
    if any(x in path.lower() for x in ["soap","note","documentation"]):
        result = claude(f"Create a perfect SOAP note:\n{text}")
    elif any(x in path.lower() for x in ["triage","esi"]):
        result = claude(f"Return ONLY: ESI Level X – one-sentence reason\n{text}")
    elif any(x in path.lower() for x in ["plan","treatment"]):
        result = claude(f"Create full evidence-based treatment plan:\n{text}")
    else:
        result = claude(f"Medical reasoning for: {text}")
    return {"response": result}
