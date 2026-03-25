
import random
import string
import os 
import json
import re
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


@tool("generador_numeros")
def generador_numeros(limites_input) -> str:
    """
    Genera 24 números entre 0 y 250 que esten dentro de los 3 rangos. 
    Acepta solo un string como "150,230".

    """
    try:

        if isinstance(limites_input, dict):
            
            limites_input = list(limites_input.values())[0]

        limpios = str(limites_input).replace("[", "").replace("]", "").replace("{", "").replace("}", "")
        partes = [n.strip() for n in limpios.split(',') if n.strip().isdigit()]
        
        if len(partes) < 2:
            return "Error: Formato incorrecto. Envía solo 'numero,numero'"
        
        lim_inf, lim_sup = sorted(partes)
        
        universo = [n for n in range(0, 251) if n not in [lim_inf, lim_sup]]
        nums_rand = random.sample(universo, 24)
        

        rango1 = [n for n in nums_rand if n < lim_inf]
        rango2 = [n for n in nums_rand if lim_inf <= n <= lim_sup]
        rango3 = [n for n in nums_rand if n > lim_sup]
        

        resultado = {
            "configuracion": {
                "limite_inferior": lim_inf,
                "limite_superior": lim_sup,
                "total_numeros": len(nums_rand)
            },
            "ejercicio": {
                "rango1": sorted(rango1),
                "rango2": sorted(rango2),
                "rango3": sorted(rango3)
            }
        }
        
        return json.dumps(resultado, indent=4)

    except Exception as e:
        return f"Error técnico en la tool: {str(e)}"
    


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



@tool("serializador_rngnum")
def serializador_rngnum(contenido_sucio) -> str:
    """
    Elimina en el contenido JSON de el fichero 'numeros_a_ordenar.json' 
    las etiquetas de Markdown y strings innecesarias del fichero.

    """
    try:

        match = re.search(r'\{.*\}', contenido_sucio, re.DOTALL)
        if not match:
            return "Error: No se encontró un JSON válido en el mensaje."
        
        limpio = match.group(0)
        datos = json.loads(limpio)
        
        ruta = os.path.join("output", "numeros_a_ordenar.json")
        with open(ruta, "w", encoding="utf-8") as f:
            json.dump(datos, f, indent=4)
            
        return f"ÉXITO: Guardado en {ruta}"
    
    except Exception as e:
        return f"Error serializando: {str(e)}"

    