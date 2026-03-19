from crewai import Agent, Task, Crew, Process, LLM
from crewai.flow.flow import Flow, listen, start, router
from langchain_ollama import OllamaLLM
import os
from pydantic import BaseModel
from typing import List
import tools


class SolSopa(BaseModel):
    tema: str
    palabras: List[str]


os.environ["OPENAI_API_KEY"] = "NA"

gemma3 = LLM(model="ollama/gemma3:4b", base_url="http://localhost:11434", api_key="NA")
# llama3_1 = LLM(model="ollama/llama3.1", base_url="http://localhost:11434", api_key="NA")
# llama3_2 = LLM(model="ollama/llama3.2", base_url="http://localhost:11434", api_key="NA")


generador_palabras = Agent(
    role='Generador Experto de palabras',
    goal='Generar 6 palabras que no sean compuestas y que tengan que ver con la temática "{tema}"',
    backstory='Eres un experto en generar palabras que tengan una gran relación con el tema descrito.',
    llm=gemma3,
    verbose=True   
)

creador_filas = Agent(
    role="Experto en generar cuadriculas",
    goal="Generar una cuadricula que tenga las palabras perfectamente escondidas",
    backstory="Experiencia técnica en ejercicios de cuadriculas," \
    "gran habilidad utilizando herramientas para generar los ejercicios",
    llm = gemma3,
    tools= [tools.crear_cuadricula],
    verbose=True
)

formateador_json = Agent(
    role='Especialista en Datos JSON',
    goal='Convertir la lista de palabras en un formato JSON estructurado',
    backstory='Eres un experto en serialización de datos. Tu salida debe ser JSON puro.',
    llm=gemma3,
    verbose=True    
)


tarea_gen = Task(
    name='Tarea de generación de palabras',
    description='Has de generar 6 palabras relacionadas con la temática "{tema}" que esten completas, que sean palabras ' \
    'con caracteres normales y que tengan menos de 7 letras',
    expected_output="Palabra1, Palabra2, Palabra3, Palabra4, Palabra5, Palabra6" ,
    agent=generador_palabras,
)


tarea_cuadricula = Task(
    name="Creación de la cuadrícula",
    description="Has utilizar la herramienta 'crear_cuadricula' para generar la cuadrícula " \
    "con las palabras generadas por el agente generador de palabras." \
    "NO intentes corregir nada, NO añadas texto, SOLO usa la herramienta.",
    expected_output="La cuadrícula de letras tal cual la entrega la herramienta, sin explicaciones adicionales.",
    output_file="/output/result.txt",
    context=[tarea_gen],
    async_execution=True,
    agent=creador_filas,
    max_retries=4,
)

tarea_json = Task(
    description="Toma las palabras de la tarea anterior y crea un JSON",
    expected_output="Un objeto JSON válido.",
    agent=formateador_json,
    output_json=SolSopa,
    output_file="/output/words.json",
    context=[tarea_gen],       
)



sopa_letras = Crew(
    agents=[generador_palabras, creador_filas, formateador_json],
    tasks=[tarea_gen, tarea_cuadricula, tarea_json],
    process=Process.sequential,
    verbose=True,   
)

print("### Iniciando proceso ###")
resultado = sopa_letras.kickoff(inputs={'tema': 'informática'})