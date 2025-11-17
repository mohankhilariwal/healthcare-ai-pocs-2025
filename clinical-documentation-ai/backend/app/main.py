from fastapi import FastAPI
from app.api.endpoints.documentation import router as main_router
from app.api.endpoints.health import router as health_router

app = FastAPI()
from app.api.endpoints.fallback import router as fallback_router
from app.api.endpoints.fallback import router as fallback_router
app.include_router(fallback_router)

from cors_fix import add_cors
add_cors(app)
