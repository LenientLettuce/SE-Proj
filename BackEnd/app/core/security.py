from datetime import datetime, timedelta, timezone
from typing import Any

from jose import JWTError, jwt
import hashlib

from app.core.config import settings


# -------------------------
# PASSWORD HASHING (NO BCRYPT)
# -------------------------

def get_password_hash(password: str) -> str:
    """
    Fully stable hashing (NO bcrypt = NO 72-byte issues)
    """
    return hashlib.sha256(password.encode("utf-8")).hexdigest()


def verify_password(plain_password: str, hashed_password: str) -> bool:
    return get_password_hash(plain_password) == hashed_password


# -------------------------
# JWT
# -------------------------

def create_access_token(subject: str, extra_claims: dict[str, Any] | None = None) -> str:
    expire = datetime.now(timezone.utc) + timedelta(
        minutes=settings.access_token_expire_minutes
    )

    to_encode: dict[str, Any] = {
        "sub": subject,
        "exp": expire
    }

    if extra_claims:
        to_encode.update(extra_claims)

    return jwt.encode(
        to_encode,
        settings.jwt_secret,
        algorithm=settings.jwt_algorithm
    )


def decode_token(token: str) -> dict[str, Any]:
    try:
        return jwt.decode(
            token,
            settings.jwt_secret,
            algorithms=[settings.jwt_algorithm]
        )
    except JWTError:
        raise ValueError("Invalid token")