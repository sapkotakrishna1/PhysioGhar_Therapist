from sqlalchemy import Column, Integer, String

from app.database import Base


class Schedule(Base):
    __tablename__ = "schedules"

    id = Column(Integer, primary_key=True, index=True)
    date = Column(String, nullable=False)
    time = Column(String, nullable=False)
    status = Column(String, nullable=False)
    patient_id = Column(Integer, nullable=True)
    patient_name = Column(String, nullable=True)
    notes = Column(String, nullable=True)