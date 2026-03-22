from crewai import Agent, Task, Crew, Process, LLM
from crewai.flow.flow import Flow, listen, start, router
from crewai_tools import FileReadTool
from langchain_ollama import OllamaLLM
import os
import json
from pydantic import BaseModel, ValidationError
from typing import List
import tools


class SolSopa(BaseModel):
    tema: str
    palabras: List[str]


os.environ["OPENAI_API_KEY"] = "NA"

gemma3 = LLM(model="ollama/gemma3:4b", base_url="http://localhost:11434", api_key="NA")
# llama3_1 = LLM(model="ollama/llama3.1", base_url="http://localhost:11434", api_key="NA")
# llama3_2 = LLM(model="ollama/llama3.2", base_url="http://localhost:11434", api_key="NA")


#-----AGENTES-----



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
    role="Experto en estructuras tipo JSON",
    goal="Tomar las palabras generadas y usar la herramienta para guardarlas en JSON",
    backstory="Eres un experto en serialización de datos a formato JSON.",
    llm=gemma3,
    tools=[tools.serializador_sopa],
    verbose=True
)


#-----TAREAS-----


tarea_gen = Task(
    name='Tarea de generación de palabras',
    description='Has de generar 6 palabras relacionadas con la temática "{tema}" que esten completas, que sean palabras ' \
    'con caracteres normales y que tengan menos de 7 letras',
    expected_output="Palabra1, Palabra2, Palabra3, Palabra4, Palabra5, Palabra6",
    output_file="/output/words.json",
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

tarea_serializar = Task(
    name='Serialización de datos',
    description=(
        "Toma las palabras de la tarea_gen y el tema '{tema}'. "
        "Usa la herramienta 'serializador_sopa' pasando ambos parámetros. "
        "No intentes responder con texto, solo usa la herramienta."
    ),
    expected_output="Confirmación de que el JSON ha sido guardado.",
    agent=formateador_json,
    context=[tarea_gen]
)

sopa_letras = Crew(
    agents=[generador_palabras, formateador_json, creador_filas],
    tasks=[tarea_gen, tarea_serializar ,tarea_cuadricula],
    process=Process.sequential,
    verbose=True,   
)

print("### Iniciando proceso ###")
resultado = sopa_letras.kickoff(inputs={'tema': 'seres de la naturaleza'})

datos_netos = resultado.json_dict
print("Datos convertidos a JSON")
print(datos_netos)

try:

    with open("output/words.json", "r") as f:
        datos_finales = SolSopa(**json.load(f))
        print(f"Objeto Pydantic listo: {datos_finales}")

except FileNotFoundError:
    print("Error: El archivo 'words.json' no existe.")

except json.JSONDecodeError:
    print("Error: El archivo no es un JSON válido.")

except ValidationError as e:
    print(f"Error: El JSON es válido pero no se ajusta a la estructura de SolSopa.")
    print(f"Detalles del fallo: {e.json()}")

except Exception as e:
    print(f"⚠️ Error inesperado: {e}")