#!/bin/bash
set -e
PROJECT="ai-diagnostic-assistant"
PORT_BACKEND=8002
PORT_FRONTEND=3002

mkdir -p $PROJECT/{backend/app/api/endpoints,backend/app/{models,services,core,utils},backend/tests,frontend/src/{components,pages,services,hooks,types},frontend/public,.github/workflows,scripts}

# (All common files same as before – .gitignore, .env.example, requirements.txt, Dockerfiles, etc.)
# I’m only showing the parts that are different:

cat <<'EOF' > $PROJECT/README.md
# AI Diagnostic Assistant
Conversational AI that gives differential diagnosis suggestions from symptoms, labs, imaging notes.
EOF

cat <<'EOF' > $PROJECT/docker-compose.yml
version: '3.8'
services:
  backend:
    build: ./backend
    ports: ["8002:8000"]
    env_file: .env
  frontend:
    build: ./frontend
    ports: ["3002:3000"]
    depends_on: [backend]
EOF

cat <<'EOF' > $PROJECT/backend/app/api/endpoints/diagnosis.py
from fastapi import APIRouter
from pydantic import BaseModel
from app.services.claude_service import generate_with_claude

router = APIRouter()

class DiagnosisRequest(BaseModel):
    symptoms: str
    history: str = ""
    labs: str = ""

@router.post("/diagnose")
def diagnose(req: DiagnosisRequest):
    prompt = f"""Patient symptoms: {req.symptoms}\nHistory: {req.history}\nLabs: {req.labs}\n\nProvide top 5 differential diagnoses with brief reasoning."""
    return {"diagnosis": generate_with_claude(prompt)}
EOF

cat <<'EOF' > $PROJECT/backend/app/main.py
from fastapi import FastAPI
from app.api.endpoints.health import router as health_router
from app.api.endpoints.diagnosis import router as diag_router

app = FastAPI(title="AI Diagnostic Assistant")
app.include_router(health_router)
app.include_router(diag_router)
EOF

cat <<'EOF' > $PROJECT/frontend/src/pages/index.tsx
import React, { useState } from 'react';

export default function Home() {
  const [symptoms, setSymptoms] = useState('');
  const [result, setResult] = useState('');

  const diagnose = async () => {
    const res = await fetch('http://localhost:8002/diagnose', {
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: JSON.stringify({ symptoms })
    });
    const data = await res.json();
    setResult(data.diagnosis);
  };

  return (
    <div className="p-8 max-w-4xl mx-auto">
      <h1 className="text-3xl font-bold mb-6">AI Diagnostic Assistant</h1>
      <textarea
        className="w-full p-4 border rounded" rows={6}
        placeholder="Enter symptoms, history, labs..."
        value={symptoms} onChange={e => setSymptoms(e.target.value)} />
      <button onClick={diagnose} className="mt-4 bg-blue-600 text-white px-6 py-3 rounded">Diagnose</button>
      <pre className="mt-8 p-4 bg-gray-100 rounded whitespace-pre-wrap">{result}</pre>
    </div>
  );
}
EOF

# Copy the rest of the files (requirements.txt, claude_service.py, etc.) from your working clinical-documentation-ai folder
cp -r clinical-documentation-ai/backend/{requirements.txt,Dockerfile,app/{core,services}} $PROJECT/backend/
cp -r clinical-documentation-ai/{.gitignore,.env.example} $PROJECT/
cp -r clinical-documentation-ai/frontend/{package*.json,tsconfig.json,next.config.js,tailwind.config.js,Dockerfile} $PROJECT/frontend/
cp -r clinical-documentation-ai/scripts $PROJECT/

echo "ai-diagnostic-assistant created → http://localhost:3002"
