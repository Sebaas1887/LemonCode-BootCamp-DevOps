from fastapi import FastAPI, Response
from fastapi.staticfiles import StaticFiles
from prometheus_client import CONTENT_TYPE_LATEST, generate_latest, make_asgi_app
from api.endpoints import router as item_router

app = FastAPI()

app.include_router(item_router)


@app.get("/metrics", include_in_schema=False)
def metrics():
    return Response(generate_latest(), media_type=CONTENT_TYPE_LATEST)


metrics_app = make_asgi_app()
app.mount("/metrics", metrics_app)

app.mount('/', StaticFiles(directory="statics", html=True), name="static")
