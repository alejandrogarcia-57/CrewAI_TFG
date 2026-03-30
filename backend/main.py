from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from packing import *

app = FastAPI()

# Permite que Flutter se conecte sin bloqueos de seguridad
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/obtener-sopa")
async def get_sopa():
    
    resultado = empaquetar_sopa()
    
    return resultado


@app.get("/obtener-operaciones")
async def get_operaciones():
    
    resultado = empaquetar_operacion()

    return resultado


@app.get("/obtener-parejas")
async def get_parejas():

    resultado = empaquetar_parejas()
    
    return resultado


@app.get("/obtener-ahorcado")
async def get_ahorcados():

    resultado = empaquetar_ahorcado()

    return resultado


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=8000)