from crewai import Agent, Task, Crew, Process, LLM
from langchain_ollama import OllamaLLM
import os
from pydantic import BaseModel
from typing import List
import tools


class DatosSopa(BaseModel):
    titulo: str
    mensaje: str
    palabras: List[str]


os.environ["OPENAI_API_KEY"] = "NA"

llm_used = LLM(model="ollama/llama3.1", base_url="http://localhost:11434", api_key="NA")

generador_palabras = Agent(
    role='Generador Experto de palabras',
    goal='Generar 6 palabras que no sean compuestas y que tengan que ver con el tema: {tema}',
    backstory='Eres un experto en generar palabras que tengan una gran relación con el tema descrito.',
    llm=llm_used,
    verbose=True   
)

escritor_mensaje = Agent(
    role='Escritor de mensajes fantasiosos',
    goal='Escribir un mensaje que incite al niño a resolver la sopa de letras cuya temática es {tema}',
    backstory='Tienes una gran habilidad para escribir y emocionar a las personas con tus mensajes',
    llm=llm_used,
    verbose=True
)

generador_sopa = Agent(
    role='Experto y Ingeniero de Contenido Educativo',
    goal='Tu objetivo es crear las letras que conformaran la estructura de la sopa de letras a partir de la herramienta disponible',
    backstory='Eres un maestro que lleva años creando sopa de letras y eres el mejor creando estructuras de estos ejercicios',
    llm=llm_used,
    tools=[tools.generador_sopa_letras],
    max_iter=2,
    verbose=True   
)

tarea_gen = Task(
    name='Tarea de generación de palabras',
    description='Has de generar 6 palabras relacionadas con el tema: {tema} que esten correctamente estructuradas y que sean palabras sin tilde o dieresi.' \
    'Estas palabras no pueden tener más de 7 letras.',
    expected_output="La salida sera unicamente un JSON que tenga como atributos 'palabras' que tenga un array con todas las palabras elegidas. " ,
    agent=generador_palabras,
    
)

tarea_escritor = Task(
    name='Tarea de escritura del mensaje',
    description='Tu objetivo es generar un mensaje que tenga imaginación y que este relacionado con {tema}, ' \
    'para que el niño que lo lea tenga ganas de resolver el acertijo. Puedes inventarte una historia corta que despierte el interés del usuario',
    expected_output='Un archivo JSON que tenga las palabras generadas por el agente generador de palabras más el mensaje',
    output_json=DatosSopa,
    output_file='output/estructura.json',
    context=[tarea_gen],
    agent=escritor_mensaje,
    )

tarea_gen_sopa = Task(
    name='Tarea de generación de estructura sopa de letras',
    description='A partir de la herramienta que tienes para generar la sopa de letras, extrae las palabras del archivo "estructura.json" ' \
    'y genera la sopa de letras correctamente',
    expected_output="Un archivo Markdown con la sopa de letras real generada por la herramienta.",
    agent=generador_sopa,
    context=[tarea_escritor],
    output_file='output/sopa_letras.json'

)

sopa_letras = Crew(
    agents=[generador_palabras, escritor_mensaje, generador_sopa],
    tasks=[tarea_gen, tarea_escritor, tarea_gen_sopa],
    process=Process.sequential, 
    verbose=True,
    
)


print("### Iniciando proceso ###")
resultado = sopa_letras.kickoff(inputs={'tema': 'jugadores de futbol'})

