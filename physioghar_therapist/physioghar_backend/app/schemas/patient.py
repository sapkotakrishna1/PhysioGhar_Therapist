from pydantic import BaseModel


class PatientCreate(BaseModel):
    name: str
    age: int
    gender: str
    phone: str
    condition: str


class PatientUpdate(BaseModel):
    name: str
    age: int
    gender: str
    phone: str
    condition: str
    history: list[str] = []
    notes: list[str] = []


class PatientResponse(BaseModel):
    id: int
    name: str
    age: int
    gender: str
    phone: str
    condition: str
    history: list[str]
    notes: list[str]

    class Config:
        from_attributes = True