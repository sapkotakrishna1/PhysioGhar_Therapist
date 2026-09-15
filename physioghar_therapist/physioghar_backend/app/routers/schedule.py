from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.database import get_db
from app.schedule_model import Schedule
from app.schemas.schedule import (
    ScheduleCreate,
    ScheduleUpdate,
    ScheduleResponse,
)


router = APIRouter(
    prefix="/schedules",
    tags=["Schedules"],
)


@router.get("/", response_model=list[ScheduleResponse])
def get_schedules(db: Session = Depends(get_db)):
    return db.query(Schedule).all()


@router.post("/", response_model=ScheduleResponse)
def create_schedule(
    schedule: ScheduleCreate,
    db: Session = Depends(get_db),
):
    new_schedule = Schedule(
        date=schedule.date,
        time=schedule.time,
        status=schedule.status,
        patient_id=schedule.patient_id,
        patient_name=schedule.patient_name,
        notes=schedule.notes,
    )

    db.add(new_schedule)
    db.commit()
    db.refresh(new_schedule)

    return new_schedule


@router.get(
    "/{schedule_id}",
    response_model=ScheduleResponse,
)
def get_schedule(
    schedule_id: int,
    db: Session = Depends(get_db),
):
    schedule = (
        db.query(Schedule)
        .filter(Schedule.id == schedule_id)
        .first()
    )

    if schedule is None:
        raise HTTPException(
            status_code=404,
            detail="Schedule not found",
        )

    return schedule


@router.put(
    "/{schedule_id}",
    response_model=ScheduleResponse,
)
def update_schedule(
    schedule_id: int,
    schedule_data: ScheduleUpdate,
    db: Session = Depends(get_db),
):
    schedule = (
        db.query(Schedule)
        .filter(Schedule.id == schedule_id)
        .first()
    )

    if schedule is None:
        raise HTTPException(
            status_code=404,
            detail="Schedule not found",
        )

    schedule.date = schedule_data.date
    schedule.time = schedule_data.time
    schedule.status = schedule_data.status
    schedule.patient_id = schedule_data.patient_id
    schedule.patient_name = schedule_data.patient_name
    schedule.notes = schedule_data.notes

    db.commit()
    db.refresh(schedule)

    return schedule


@router.delete(
    "/{schedule_id}",
)
def delete_schedule(
    schedule_id: int,
    db: Session = Depends(get_db),
):
    schedule = (
        db.query(Schedule)
        .filter(Schedule.id == schedule_id)
        .first()
    )

    if schedule is None:
        raise HTTPException(
            status_code=404,
            detail="Schedule not found",
        )

    db.delete(schedule)
    db.commit()

    return {
        "message": "Schedule deleted successfully"
    }