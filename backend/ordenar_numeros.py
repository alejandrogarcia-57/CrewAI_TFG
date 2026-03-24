from crewai import Agent, Task, Crew, Process, LLM
from langchain_ollama import OllamaLLM
import os
from pydantic import BaseModel
from typing import List
import tools


class RangoNumeros(BaseModel):
    configuracion: dict[str, int]
    ejercicio: dict[str, List[int]]

os.environ["OPENAI_API_KEY"] = "NA"

llm_used = LLM(model="ollama/gemma3:4b", base_url="http://localhost:11434", api_key="NA")


generador_rng = Agent(
    role='Generador de Límites',
    goal='Generar 2 números enteros y que esten entre 0 y 250.',
    backstory='Eres un calculador preciso. Tu única misión es dar dos números separados por coma.',
    llm=llm_used,
    allow_delegation=False,
    verbose=True   
)

generador_nums = Agent(
    role='Generador Experto de números a ordenar',
    goal='Pasar los límites a la herramienta generador_numeros.',
    backstory='No generas números tú mismo. Solo copias los límites y usas la herramienta.',
    llm=llm_used,
    tools=[tools.generador_numeros],
    allow_delegation=False,
    max_iter=3,
    verbose=True   
)

formateador_json = Agent(
    role="Experto en estructuras tipo JSON",
    goal="Tomar las palabras generadas y usar la herramienta para guardarlas en JSON",
    backstory="Eres un experto en serialización de datos a formato JSON.",
    llm=llm_used,
    tools=[tools.serializador_rngnum],
    allow_delegation=False,
    max_iter=3,
    verbose=True
)

tarea_rng = Task(
    name='Tarea de generación de rangos',
    description='Has de generar 2 números entre 0 y 250 con una distancia mayor a 70 unidades. Por ejemplo: "70, 160"',
    expected_output="Dos numeros separados por una coma.",
    agent=generador_rng,
)

tarea_nums = Task(
    name='Tarea de generación de números',
    description='Toma los números de la tarea anterior y úsalos como input en "generador_numeros".',
    expected_output="El JSON que devuelve la herramienta 'generador_numeros'",
    context=[tarea_rng],
    output_file='output/numeros_a_ordenar.json',
    agent=generador_nums,
)


tarea_serializar = Task(
    name='Serialización de datos',
    description=
        "Toma la salida de la 'tarea_nums' y serializa el contenido del JSON" \
        "utilizando la herramienta 'serializador_rngnum'",
    expected_output="Confirmación de que el JSON ha sido guardado.",
    context=[tarea_nums],
    agent=formateador_json,   
)



ordenar_num = Crew(
    agents=[generador_rng, generador_nums, formateador_json],
    tasks=[tarea_rng, tarea_nums, tarea_serializar],
    process=Process.sequential,
    verbose=True
)

print("### Iniciando proceso ###")
resultado = ordenar_num.kickoff()
    
   
