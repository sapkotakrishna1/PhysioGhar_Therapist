
from pydantic import BaseModel


class TherapistCreate(BaseModel):
    name: str
    phone: str
    email: str
    specialization: str
    experience: int
    bio: str | None = None
    is_available: bool = True


class TherapistUpdate(BaseModel):
    name: str
    phone: str
    email: str
    specialization: str
    experience: int
    bio: str | None = None
    is_available: bool = True


class TherapistResponse(BaseModel):
    id: int
    name: str
    phone: str
    email: str
    specialization: str
    experience: int
    bio: str | None = None
    is_available: bool

    class Config:
        from_attributes = True
