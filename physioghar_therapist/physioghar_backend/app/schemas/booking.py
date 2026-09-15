from pydantic import BaseModel


class BookingCreate(BaseModel):
    patient_id: int
    patient_name: str
    therapist_name: str
    date: str
    time: str
    status: str
    notes: str | None = None


class BookingUpdate(BaseModel):
    patient_id: int
    patient_name: str
    therapist_name: str
    date: str
    time: str
    status: str
    notes: str | None = None


class BookingResponse(BaseModel):
    id: int
    patient_id: int
    patient_name: str
    therapist_name: str
    date: str
    time: str
    status: str
    notes: str | None = None

    class Config:
        from_attributes = True