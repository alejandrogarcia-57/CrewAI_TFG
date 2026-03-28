from crewai import Agent, Task, Crew, Process, LLM
from langchain_ollama import OllamaLLM
import os
from pydantic import BaseModel
from typing import List
import tools

os.environ["OPENAI_API_KEY"] = "NA"

llm_used = LLM(model="ollama/gemma3:4b", base_url="http://localhost:11434", api_key="NA")


#------AGENTES------

generador_pares = Agent(
    role='Generador experto de Parejas',
    goal='Tienes que generar 8 parejas de emojis para el juego de encontrar ' \
    'las parejas con el mismo símbolo sobre la temática {tema}',
    backstory='Tienes años de experiencia generando pares de emojis distintos y ' \
    'listos para ser utilizados en juegos de parejas',
    llm=llm_used,
    verbose=True   
)

agente_formateador = Agent(
    role='Formateador experto de JSON',
    goal='Formatear el JSON generado por el agente generador_pares para que ' \
    'sea un JSON limpio con el formato indicado en la tarea.',
    backstory='Eres un experto formateando JSON. Tu única misión es limpiar ' \
    'el JSON generado por el agente generador_pares y asegurarte de que tenga el formato correcto.',
    llm=llm_used,
    tools=[tools.preparador_juego_memoria],
    allow_delegation=False,
    allow_code_execution=False,
    max_iter=3,
    verbose=True
)


#------TAREAS------

tarea_gen_pares = Task(
    name='Tarea de generación de parejas',
    description='Has de generar solo 8 parejas de emojis (16 emojis) distintos para el juego de encontrar las parejas con el mismo símbolo.' \
    'La salida debe ser un JSON con el siguiente formato: {"pares": ["😀", "😀", "🐶", "🐶", ...]} sobre la temática {tema}.',
    expected_output="Un JSON con el formato indicado en la descripción.",
    output_file='output/parejas.json',
    agent=generador_pares,   
)

tarea_seriailizar = Task(
    description="Toma el JSON de emojis de la tarea anterior y pásalo íntegro a la herramienta 'preparador_juego_memoria'.",
    expected_output="SOLO lo que devuelva la herramienta, sin comentarios",
    output_file='output/parejas.json',
    agent=agente_formateador,

)


parejas = Crew(
    agents=[generador_pares, agente_formateador],
    tasks=[tarea_gen_pares, tarea_seriailizar],
    process=Process.sequential,
    verbose=True
)

print("### Iniciando proceso ###")
resultado = parejas.kickoff(inputs= {'tema':'emociones'})