from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.database import get_db
from app.models import Patient
from app.schemas.patient import PatientCreate, PatientUpdate, PatientResponse


router = APIRouter(
    prefix="/patients",
    tags=["Patients"],
)


@router.get("/", response_model=list[PatientResponse])
def get_patients(db: Session = Depends(get_db)):
    return db.query(Patient).all()


@router.post("/", response_model=PatientResponse)
def create_patient(
    patient: PatientCreate,
    db: Session = Depends(get_db),
):
    new_patient = Patient(
        name=patient.name,
        age=patient.age,
        gender=patient.gender,
        phone=patient.phone,
        condition=patient.condition,
        history=[],
        notes=[],
    )

    db.add(new_patient)
    db.commit()
    db.refresh(new_patient)

    return new_patient


@router.get(
    "/{patient_id}",
    response_model=PatientResponse,
    responses={404: {"description": "Patient not found"}},
)
def get_patient(
    patient_id: int,
    db: Session = Depends(get_db),
):
    patient = db.query(Patient).filter(Patient.id == patient_id).first()

    if patient is None:
        raise HTTPException(
            status_code=404,
            detail="Patient not found",
        )

    return patient


@router.put(
    "/{patient_id}",
    response_model=PatientResponse,
    responses={404: {"description": "Patient not found"}},
)
def update_patient(
    patient_id: int,
    patient_data: PatientUpdate,
    db: Session = Depends(get_db),
):
    patient = db.query(Patient).filter(Patient.id == patient_id).first()

    if patient is None:
        raise HTTPException(
            status_code=404,
            detail="Patient not found",
        )

    patient.name = patient_data.name
    patient.age = patient_data.age
    patient.gender = patient_data.gender
    patient.phone = patient_data.phone
    patient.condition = patient_data.condition
    patient.history = patient_data.history
    patient.notes = patient_data.notes

    db.commit()
    db.refresh(patient)

    return patient


@router.delete(
    "/{patient_id}",
    responses={404: {"description": "Patient not found"}},
)
def delete_patient(
    patient_id: int,
    db: Session = Depends(get_db),
):
    patient = db.query(Patient).filter(Patient.id == patient_id).first()

    if patient is None:
        raise HTTPException(
            status_code=404,
            detail="Patient not found",
        )

    db.delete(patient)
    db.commit()

    return {
        "message": "Patient deleted successfully"
    }