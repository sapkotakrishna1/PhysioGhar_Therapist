
from sqlalchemy import Column, Integer, String, JSON, Boolean

from app.database import Base


class Patient(Base):
    __tablename__ = "patients"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    age = Column(Integer, nullable=False)
    gender = Column(String, nullable=False)
    phone = Column(String, nullable=False)
    condition = Column(String, nullable=False)
    history = Column(JSON, default=list)
    notes = Column(JSON, default=list)


class Therapist(Base):
    __tablename__ = "therapists"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    phone = Column(String, nullable=False)
    email = Column(String, nullable=False)
    specialization = Column(String, nullable=False)
    experience = Column(Integer, nullable=False)
    bio = Column(String, nullable=True)
    is_available = Column(Boolean, nullable=False, default=True)
