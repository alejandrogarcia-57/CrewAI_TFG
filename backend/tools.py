
import random
import string
import os 
import json
from crewai.tools import tool


@tool("crear_cuadricula")
def crear_cuadricula(palabras: str) -> str:
    """ 
    Has de separar las palabras que hay dentro de la string y 
    generar una cuadricula donde esten estas palabras dentro 
    
    """
    
    def clean(s):
        replacements = {"Á": "A", "É": "E", "Í": "I", "Ó": "O", "Ú": "U"}
        res = s.strip().upper()
        for k, v in replacements.items(): res = res.replace(k, v)
        return res

    words = [clean(w) for w in palabras.split(",") if 0 < len(clean(w)) <= 8]

    if not words:
        return "Error: No se proporcionaron palabras válidas de menos de 8 letras."

    size = 10
    grid = [['' for _ in range(size)] for _ in range(size)]

    
    for word in words:
        placed = False
        intentos = 0
        while not placed and intentos < 20:
            row = random.randint(0, size - 1)
            col_start = random.randint(0, size - len(word))
            
            
            if all(grid[row][col_start + i] == '' for i in range(len(word))):
                for i in range(len(word)):
                    grid[row][col_start + i] = word[i]
                placed = True
            intentos += 1

    
    for r in range(size):
        for c in range(size):
            if grid[r][c] == '':
                grid[r][c] = random.choice(string.ascii_uppercase)

    return "\n".join([" ".join(row) for row in grid])


@tool("serializador_sopa")
def serializador_sopa(tema: str, palabras_comas: str) -> str:
    """
    Recibe el tema y una lista de palabras separadas por comas.
    Genera un archivo JSON perfectamente estructurado en la carpeta output.
    """
    
    lista_palabras = [p.strip().upper() for p in palabras_comas.split(",") if len(p.strip()) > 0]
    
    
    datos = {
        "tema": tema.strip(),
        "palabras": lista_palabras
    }
    
    
    ruta = os.path.join("output", "words.json")
    with open(ruta, "w", encoding="utf-8") as f:
        json.dump(datos, f, indent=4, ensure_ascii=False)
        
    return f"ÉXITO: Archivo guardado correctamente en {ruta} con {len(lista_palabras)} palabras."




    