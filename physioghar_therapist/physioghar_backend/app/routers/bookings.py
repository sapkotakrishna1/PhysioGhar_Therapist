from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.database import get_db
from app.models_booking import Booking
from app.schemas.booking import (
    BookingCreate,
    BookingUpdate,
    BookingResponse,
)


router = APIRouter(
    prefix="/bookings",
    tags=["Bookings"],
)


@router.get("/", response_model=list[BookingResponse])
def get_bookings(db: Session = Depends(get_db)):
    return db.query(Booking).all()


@router.post("/", response_model=BookingResponse)
def create_booking(
    booking: BookingCreate,
    db: Session = Depends(get_db),
):
    new_booking = Booking(
        patient_id=booking.patient_id,
        patient_name=booking.patient_name,
        therapist_name=booking.therapist_name,
        date=booking.date,
        time=booking.time,
        status=booking.status,
        notes=booking.notes,
    )

    db.add(new_booking)
    db.commit()
    db.refresh(new_booking)

    return new_booking


@router.get(
    "/{booking_id}",
    response_model=BookingResponse,
    responses={404: {"description": "Booking not found"}},
)
def get_booking(
    booking_id: int,
    db: Session = Depends(get_db),
):
    booking = db.query(Booking).filter(Booking.id == booking_id).first()

    if booking is None:
        raise HTTPException(
            status_code=404,
            detail="Booking not found",
        )

    return booking


@router.put(
    "/{booking_id}",
    response_model=BookingResponse,
    responses={404: {"description": "Booking not found"}},
)
def update_booking(
    booking_id: int,
    booking_data: BookingUpdate,
    db: Session = Depends(get_db),
):
    booking = db.query(Booking).filter(Booking.id == booking_id).first()

    if booking is None:
        raise HTTPException(
            status_code=404,
            detail="Booking not found",
        )

    booking.patient_id = booking_data.patient_id
    booking.patient_name = booking_data.patient_name
    booking.therapist_name = booking_data.therapist_name
    booking.date = booking_data.date
    booking.time = booking_data.time
    booking.status = booking_data.status
    booking.notes = booking_data.notes

    db.commit()
    db.refresh(booking)

    return booking


@router.delete(
    "/{booking_id}",
    responses={404: {"description": "Booking not found"}},
)
def delete_booking(
    booking_id: int,
    db: Session = Depends(get_db),
):
    booking = db.query(Booking).filter(Booking.id == booking_id).first()

    if booking is None:
        raise HTTPException(
            status_code=404,
            detail="Booking not found",
        )

    db.delete(booking)
    db.commit()

    return {
        "message": "Booking deleted successfully"
    }