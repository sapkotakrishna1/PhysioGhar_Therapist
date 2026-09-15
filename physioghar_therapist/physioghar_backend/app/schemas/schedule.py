from pydantic import BaseModel


class ScheduleCreate(BaseModel):
    date: str
    time: str
    status: str
    patient_id: int | None = None
    patient_name: str | None = None
    notes: str | None = None


class ScheduleUpdate(BaseModel):
    date: str
    time: str
    status: str
    patient_id: int | None = None
    patient_name: str | None = None
    notes: str | None = None


class ScheduleResponse(BaseModel):
    id: int
    date: str
    time: str
    status: str
    patient_id: int | None = None
    patient_name: str | None = None
    notes: str | None = None

    class Config:
        from_attributes = True