"""Application settings, loaded from environment variables prefixed with SAGE_."""

from functools import lru_cache

from pydantic import model_validator
from pydantic_settings import BaseSettings, SettingsConfigDict


class AppConfig(BaseSettings):
    model_config = SettingsConfigDict(env_prefix="SAGE_", case_sensitive=False, extra="ignore")

    # GCP
    project_id: str
    region: str = "europe-west6"

    # Shared-project mode: when set, resource names derive from this prefix instead of the
    # dedicated-project defaults (same rules as devops/cloud/locals.tf). Empty = dedicated.
    resource_prefix: str = ""

    # Cloud Storage (instructions bucket)
    instructions_bucket: str = ""
    instructions_blob: str = "istruzioni.md"

    # Firestore (the database name is derived from resource_prefix in shared-project mode)
    firestore_database: str = "(default)"
    firestore_collection: str = "chunks"
    top_k: int = 5

    # Vertex AI models
    chat_model: str = "gemini-2.5-flash"
    embedding_model: str = "text-embedding-004"
    embedding_dimension: int = 768

    # BigQuery
    bq_dataset: str = "sage_analytics"
    bq_table: str = "question_log"

    # Ingestion
    chunk_max_chars: int = 1500

    @model_validator(mode="after")
    def _apply_resource_prefix(self) -> "AppConfig":
        """Shared-project mode: every person gets their own Firestore database, BQ dataset,
        and instructions bucket.
        """
        if not self.instructions_bucket:
            base = self.resource_prefix if self.resource_prefix else self.project_id
            self.instructions_bucket = f"{base}-instructions"

        if not self.resource_prefix:
            return self
        self.firestore_database = self.resource_prefix
        self.bq_dataset = f"{self.resource_prefix.replace('-', '_')}_{self.bq_dataset}"
        return self


@lru_cache
def get_app_config() -> AppConfig:
    return AppConfig()