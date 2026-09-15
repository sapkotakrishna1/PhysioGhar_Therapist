
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.database import Base, engine

from app import models
from app import models_booking
from app import schedule_model

from app.routers import patients
from app.routers import bookings
from app.routers import therapist
from app.routers import schedule
from app.routers import dashboard


Base.metadata.create_all(bind=engine)

app = FastAPI(title="PhysioGhar Therapist API")


app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


app.include_router(patients.router)
app.include_router(bookings.router)
app.include_router(therapist.router)
app.include_router(schedule.router)
app.include_router(dashboard.router)


@app.get("/")
def home():
    return {
        "message": "PhysioGhar Backend is working!"
    }
