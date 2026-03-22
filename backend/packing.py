import json
import os
import http 


def empaquetar_sopa():
    
    try:
        BASE_DIR = os.path.dirname(os.path.abspath(__file__))

        ruta_pal = os.path.join(BASE_DIR, "output", "words.json")
        if not os.path.exists(ruta_pal):
            return "Error: El archivo words.json no existe. Por favor, genera las palabras primero."

        with open(ruta_pal, "r", encoding="utf-8") as f:
            datos = json.load(f)

        tema = datos.get("tema", "Tema desconocido")
        palabras = ", ".join(datos.get("palabras", []))


        ruta_cuad = os.path.join(BASE_DIR, "output", "result.txt")
        if not os.path.exists(ruta_cuad):
            return "Error: El archivo no existe"
        
        with open(ruta_cuad, 'r', encoding='utf-8') as f:
            cuadricula = f.read()
        
        print(tema)
        print(palabras)
        print(cuadricula)
        return {
            "tema": tema,
            "palabras": palabras,
            "cuadricula": cuadricula
        }
    
    except Exception as e:
        return {"status": "error", "mensaje": str(e)}
