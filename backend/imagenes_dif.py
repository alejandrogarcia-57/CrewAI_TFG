from crewai import Agent, Task, Crew, Process, LLM
from langchain_ollama import OllamaLLM
import os
from pydantic import BaseModel
from typing import List
import tools

os.environ["OPENAI_API_KEY"] = "NA"

llm_used = LLM(model="ollama/llama3.1", base_url="http://localhost:11434", api_key="NA")


