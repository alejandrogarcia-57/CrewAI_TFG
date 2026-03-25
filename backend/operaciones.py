from crewai import Agent, Task, Crew, Process, LLM
from crewai.flow.flow import Flow, listen, start, router
from crewai_tools import FileReadTool
from langchain_ollama import OllamaLLM
import os
import json
from pydantic import BaseModel, ValidationError
from typing import List
import tools


class Operaciones(BaseModel):
    operaciones: List[str]

os.environ["OPENAI_API_KEY"] = "NA"

gemma3 = LLM(model="ollama/llama3.1", base_url="http://localhost:11434", api_key="NA")


#-----AGENTES-----

profesor_matematicas = Agent(
    role="Profesor de Matemáticas experimentado",
    goal="Generar JSON con 5 operaciones",
    backstory="Eres un autómata que solo genera datos JSON. No saludas, no explicas.",
    llm=gemma3,
    verbose=True,
)

#-----TAREAS-----

tarea_gen_operaciones = Task(
    name="Generar operaciones matemáticas",
    description="Tienes que crear 5 operaciones matemáticas de tercero de primaria." \
    "Debes responder únicamente con un objeto JSON válido",
    expected_output="Un JSON con este formato: {'operaciones': [{'operacion': '15+21', 'resultado':36}]}",
    output_file="output/operaciones.json", 
    agent=profesor_matematicas   
)


operaciones = Crew(
    agents=[profesor_matematicas],
    tasks=[tarea_gen_operaciones],
    process=Process.sequential,
    verbose=True
)

print("### Empezando proceso ###")
resultado = operaciones.kickoff()