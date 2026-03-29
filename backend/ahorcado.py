from crewai import Agent, Task, Crew, Process, LLM
from langchain_ollama import OllamaLLM
import os
from pydantic import BaseModel
from typing import List
import tools

os.environ["OPENAI_API_KEY"] = "NA"

llm_used = LLM(model="ollama/gemma3:4b", base_url="http://localhost:11434", api_key="NA")


#------AGENTES-------

profesor = Agent(
    role="Profesor experto en vocabulario",
    goal="Generar una palabra para utilizarla en el juego del ahorcado y " \
    "tres pistas que ayuden al niño a adivinarla",
    backstory="Tienes un gran conocimiento de la lengua y tu vocabulario ha sido entrenado durante años, " \
    "de manera que conoces un sin fin de palabras",
    llm=llm_used,
    verbose=True
)

serializador = Agent(
    role="Experto en estructuras tipo JSON",
    goal="Tomar la palabra y las pistas generadas por el profesor y usar la herramienta 'serializador_ahorcado'",
    backstory="Eres un experto en serialización de datos a formato JSON.",
    tools=[tools.serializador_ahorcado],
    llm=llm_used,
    verbose=True
)

#------TAREAS------

tarea_palabra = Task(
    name="Generar la palabra",
    description="Has de generar una palabra de una complejidad baja-media y " \
    "tres pistas que ayuden a adivinar la palabra sin mencionarla. ",
    expected_output="La salida será un JSON serializado con la palabra elegida en mayuscula " \
    "y con sus respectivas pistas.",
    output_file='output/ahorcado.json',
    agent=profesor
)

tarea_serializar = Task(
    name="Serializar la palabra y las pistas",
    description="Toma la palabra y las pistas generadas por el profesor y utiliza la herramienta 'serializador_ahorcado'.",
    expected_output="SOLO lo que devuelva la herramienta, sin comentarios",
    output_file='output/ahorcado.json',
    agent=serializador,
)


ahorcado = Crew(
    agents=[profesor, serializador],
    tasks=[tarea_palabra, tarea_serializar],
    process=Process.sequential,
    verbose=True
)

print("### Empezando proceso ###")
resultado = ahorcado.kickoff()