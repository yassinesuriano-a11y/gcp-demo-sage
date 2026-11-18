"""Thin async wrapper around the Gemini text-generation call."""

from sage.config import get_app_config
from sage.domain.qa.exceptions import SageError
from sage.integrations.llm.client import get_genai_client


async def generate_text(prompt: str) -> str:
    config = get_app_config()
    client = get_genai_client()
    try:
        response = await client.aio.models.generate_content(
            model=config.chat_model,
            contents=prompt,
        )
    except Exception as exc:
        raise SageError(f"Errore durante la generazione con Gemini: {exc}") from exc

    return response.text or ""