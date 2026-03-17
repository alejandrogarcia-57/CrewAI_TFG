from crewai.tools import tool
import random
import string

@tool("generador_sopa_letras")
def generador_sopa_letras(palabras: list) -> str:
    """
    Genera una cuadrícula de 10x10 solo con letras. Recibe una lista de palabras
    y introduce las 6 palabras que has recibido como argumento en horizontal. 
    Es importante que todas las palabras sean introducidas sin excepción.

    """
    import random
    import string
    import ast

 
    if isinstance(palabras, str):
        try:
            palabras = ast.literal_eval(palabras)
        except:
            palabras = palabras.replace('[','').replace(']','').replace('"','').split(',')

    tamano = 10
  
    letras_limpias = string.ascii_uppercase 
    matriz = [[random.choice(letras_limpias) for _ in range(tamano)] for _ in range(tamano)]
    
    for palabra in palabras:
        p = str(palabra).strip().upper().replace(" ", "")[:10]
        if not p: continue
        
        fila = random.randint(0, tamano - 1)
        col_inicio = random.randint(0, tamano - len(p))
        matriz[fila][col_inicio:col_inicio + len(p)] = list(p)
    
    resultado = "\n".join([" ".join(fila) for fila in matriz])
    return resultado


@tool("generador_escondite")
def generador_escondite(letra) -> str:
    """
    Quiero que introduzcas entre 10 y 12 veces la letra escogida por el 
    agente generador de letras

    """

    import random
    import string

    tamano = 10
    letras_limpias = string.ascii_uppercase
    matriz = [[random.choice(letras_limpias) for _ in range(tamano)] for _ in range(tamano)]
    letra = letra.strip().upper()[0]

    fila = random.randint(0,tamano - 1)
    col = random.randint(0,tamano - 1)
    matriz[fila][col] = letra

    return matriz

    




    