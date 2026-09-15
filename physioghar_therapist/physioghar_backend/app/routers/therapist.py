
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.database import get_db
from app.models import Therapist
from app.schemas.therapist import (
    TherapistCreate,
    TherapistUpdate,
    TherapistResponse,
)


router = APIRouter(
    prefix="/therapist",
    tags=["Therapist"],
)


@router.get("/", response_model=TherapistResponse)
def get_therapist(db: Session = Depends(get_db)):
    therapist = db.query(Therapist).first()

    if therapist is None:
        raise HTTPException(
            status_code=404,
            detail="Therapist not found",
        )

    return therapist


@router.post("/", response_model=TherapistResponse)
def create_therapist(
    therapist: TherapistCreate,
    db: Session = Depends(get_db),
):
    existing_therapist = db.query(Therapist).first()

    if existing_therapist is not None:
        raise HTTPException(
            status_code=400,
            detail="Therapist profile already exists",
        )

    new_therapist = Therapist(
        name=therapist.name,
        phone=therapist.phone,
        email=therapist.email,
        specialization=therapist.specialization,
        experience=therapist.experience,
        bio=therapist.bio,
        is_available=therapist.is_available,
    )

    db.add(new_therapist)
    db.commit()
    db.refresh(new_therapist)

    return new_therapist


@router.put("/", response_model=TherapistResponse)
def update_therapist(
    therapist_data: TherapistUpdate,
    db: Session = Depends(get_db),
):
    therapist = db.query(Therapist).first()

    if therapist is None:
        raise HTTPException(
            status_code=404,
            detail="Therapist not found",
        )

    therapist.name = therapist_data.name
    therapist.phone = therapist_data.phone
    therapist.email = therapist_data.email
    therapist.specialization = therapist_data.specialization
    therapist.experience = therapist_data.experience
    therapist.bio = therapist_data.bio
    therapist.is_available = therapist_data.is_available

    db.commit()
    db.refresh(therapist)

    return therapist
