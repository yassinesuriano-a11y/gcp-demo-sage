"""Reads additional instructions (istruzioni.md) from Cloud Storage on each request."""

from functools import lru_cache
import logging

from google.api_core.exceptions import GoogleAPICallError, NotFound
from google.cloud import storage

from sage.config import get_app_config

log = logging.getLogger(__name__)


@lru_cache
def get_storage_client() -> storage.Client:
    config = get_app_config()
    return storage.Client(project=config.project_id)


def load_additional_instructions() -> str:
    """Download istruzioni.md from `<prefix>-instructions`. Returns empty string if missing."""
    config = get_app_config()
    client = get_storage_client()
    try:
        bucket = client.bucket(config.instructions_bucket)
        blob = bucket.blob(config.instructions_blob)
        return blob.download_as_text(encoding="utf-8").strip()
    except NotFound:
        log.warning(
            "File %s non trovato nel bucket %s",
            config.instructions_blob,
            config.instructions_bucket,
        )
        return ""
    except GoogleAPICallError:
        log.warning(
            "Errore lettura bucket %s",
            config.instructions_bucket,
            exc_info=True,
        )
        return ""
