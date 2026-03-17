from flask import Flask
from crewai import Agent, Task, Crew, Process, LLM
from langchain_ollama import OllamaLLM
import os
from pydantic import BaseModel
from typing import List
import tools

app = Flask(__name__)

os.environ["OPENAI_API_KEY"] = "NA"

llm_used = LLM(model="ollama/llama3.1", base_url="http://localhost:11434", api_key="NA")


class Numeros(BaseModel):
    numeros: List[int]

generador_rng = Agent(
    role='Generador Experto de rangos numéricos',
    goal='Generar 2 números enteros y que esten entre 0 y 250.',
    backstory='Eres un experto en estableciendo rangos numéricos.',
    llm=llm_used,
    verbose=True   
)

generador_nums = Agent(
    role='Generador Experto de números a ordenar',
    goal='Generar 24 números para ordenarlos dentro de los tres rangos numéricos.',
    backstory='Eres un experto en generar números enteros que cumplan con ciertas condiciones.',
    llm=llm_used,
    verbose=True   
)

tarea_rng = Task(
    name='Tarea de generación de rangos',
    description='Has de generar 2 números enteros que esten entre 0 y 250. Además es necesario que esos dos números que vayas a generar ' \
    'se encuentren a una distancia superior a 70 unidades.',
    expected_output="La salida sera unicamente un JSON que tenga como atributos 'numeros' que tenga un array con los dos números elegidos.",
    output_json=Numeros,
    output_file='output/numeros_f.json',
    agent=generador_rng,
)

tarea_nums = Task(
    name='Tarea de generación de números',
    description='Has de generar 24 números enteros entre el 0 y el 250.',
    expected_output="La salida sera un JSON que tenga como atributo 'numeros' con los números obtenidos.",
    context=[tarea_rng],
    output_json=Numeros,
    output_file='output/numeros_a_ordenar.json',
    agent=generador_nums,
)

ordenar_num = Crew(
    agents=[generador_rng, generador_nums],
    tasks=[tarea_rng,tarea_nums],
    process=Process.sequential,
    verbose=2
)

print("### Iniciando proceso ###")

@app.route('/')
def ejecutar_crew():
    # Ejecutamos el proceso de los agentes
    resultado = ordenar_num.kickoff()
    
    # Retornamos el resultado envuelto en HTML básico
    return f"<h1>Resultado del Agente:</h1><p>{resultado}</p>"

if __name__ == '__main__':
    app.run(debug=True, port=5000)
