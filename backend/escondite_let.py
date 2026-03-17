from crewai import Agent, Task, Crew, Process, LLM
from langchain_ollama import OllamaLLM
import os
from pydantic import BaseModel
from typing import List
import tools

os.environ["OPENAI_API_KEY"] = "NA"

llm_used = LLM(model="ollama/llama3.1", base_url="http://localhost:11434", api_key="NA")


class Escondite(BaseModel):
    cuadricula : str

generador_letra = Agent(
    role='Experto en generar letras',
    goal='Generar la letra que se escondera en la cuadricula',
    backstory='Eres un experto con años de experiencia generando letras al azar',
    llm=llm_used,
    verbose=True,    
)

generador_ejercicio = Agent(
    role='Experto en generar ejercicios de escondite',
    goal='Generar la cuadricula de 10x10 con la letra escondida',
    backstory='Eres un experto con años de experiencia generando ejercicios de escondite',
    llm=llm_used,
    tools=[tools.generador_escondite],
    max_iter=2,
    verbose=True,
)

tarea_gen_letra = Task(
    name='Tarea de generación de letra',
    description='Has de generar una letra mayúscula al azar.',
    expected_output="La salida sera unicamente un JSON que tenga como atributos 'letra' con la letra generada.",
    output_file='output/letra_escondida.json',
    agent=generador_letra,
)

tarea_gen_ejercicio = Task(
    name='Tarea de generación de ejercicio',
    description='Has de generar una cuadricula de 10x10 con la letra generada por el anterior agente, escondida en horizontal entre 10 y 12 veces en total.' \
    'El resto de espacios deben ser rellenados con letras al azar.',
    expected_output="La salida sera un string con la cuadricula generada, cada fila debe estar separada por un salto de linea y cada letra por un espacio.",
    output_json=Escondite,
    output_file='output/res.json',
    context=[tarea_gen_letra],
    agent=generador_ejercicio,
)

escondite = Crew(
    agents=[generador_letra, generador_ejercicio],
    tasks=[tarea_gen_letra, tarea_gen_ejercicio],
    process=Process.sequential,
    verbose=True
)

print('### Empezando proceso ###')
resultado = escondite.kickoff()

