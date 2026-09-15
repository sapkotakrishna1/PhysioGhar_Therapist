from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.database import get_db
from app.models import Patient
from app.models_booking import Booking
from app.schedule_model import Schedule


router = APIRouter(
    prefix="/dashboard",
    tags=["Dashboard"],
)


@router.get("/")
def get_dashboard(db: Session = Depends(get_db)):
    total_patients = db.query(Patient).count()

    total_bookings = db.query(Booking).count()

    open_slots = (
        db.query(Schedule)
        .filter(Schedule.status == "OPEN")
        .count()
    )

    completed_bookings = (
        db.query(Booking)
        .filter(Booking.status == "COMPLETED")
        .count()
    )

    requested_bookings = (
        db.query(Booking)
        .filter(Booking.status == "REQUESTED")
        .count()
    )

    return {
        "total_patients": total_patients,
        "total_bookings": total_bookings,
        "open_slots": open_slots,
        "completed_bookings": completed_bookings,
        "requested_bookings": requested_bookings,
    }