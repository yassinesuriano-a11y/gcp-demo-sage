"""Writes one row per question to BigQuery for analytics (see devops/cloud/bigquery.tf)."""

import logging
from datetime import UTC, datetime

from sage.config import get_app_config
from sage.domain.qa.models import Chunk
from sage.integrations.bigquery.client import get_bigquery_client

log = logging.getLogger(__name__)


def log_question(question: str, chunks: list[Chunk], latency_ms: int) -> None:
    config = get_app_config()
    client = get_bigquery_client()
    table_id = f"{config.project_id}.{config.bq_dataset}.{config.bq_table}"

    row = {
        "asked_at": datetime.now(UTC).isoformat(),
        "question": question,
        "sources": [chunk.source for chunk in chunks],
        "latency_ms": latency_ms,
    }

    try:
        errors = client.insert_rows_json(table_id, [row])
        if errors:
            log.warning("Errori inserimento BigQuery: %s", errors)
    except Exception:
        log.warning("BigQuery non raggiungibile: salto il log della domanda", exc_info=True)