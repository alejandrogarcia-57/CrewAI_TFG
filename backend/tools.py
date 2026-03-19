
import random
import string
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




    