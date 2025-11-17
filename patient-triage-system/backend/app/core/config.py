from pydantic_settings import BaseSettings
from dotenv import load_dotenv

load_dotenv()

class Settings(BaseSettings):
    anthropic_api_key: str
    database_url: str = "postgresql://user:pass@localhost:5432/dbname"

settings = Settings()
