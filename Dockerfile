# 1. On part d'une image qui a déjà Python 3.11
FROM python:3.11-slim

# 2. On travaille dans le dossier /app (créé automatiquement)
WORKDIR /app

# 3. On copie d'abord la liste des librairies
COPY requirements.txt .

# 4. On installe les librairies (une seule fois, à la construction)
RUN pip install --no-cache-dir -r requirements.txt

# 5. On copie le reste du code
COPY . .

# 6. On indique que l'API utilise le port 8000
EXPOSE 8000

# 7. Au démarrage du conteneur, on lance l'API
#    --host 0.0.0.0 permet d'y accéder depuis ton navigateur
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]