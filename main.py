# On importe FastAPI (la librairie qui sert à créer l'API)
from fastapi import FastAPI

# On crée l'application
app = FastAPI()

# Quand quelqu'un ouvre l'adresse "/", cette fonction répond
@app.get("/")
def accueil():
    # Elle renvoie un petit message
    return {"message": "Bonjour depuis Docker !"}