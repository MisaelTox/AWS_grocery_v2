##############################################
# Stage 1: Build React frontend
##############################################
FROM node:18 AS frontend-builder

WORKDIR /app/frontend

# Copiar solo lo necesario para instalar dependencias
COPY frontend/package*.json ./
RUN npm install

# Copiar el resto y construir
COPY frontend/ .
RUN npm run build

##############################################
# Stage 2: Backend + Final Image
##############################################
FROM python:3.11-slim

# Evita prompts interactivos
ENV DEBIAN_FRONTEND=noninteractive

# Crear directorio de trabajo
WORKDIR /app

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    libpq-dev gcc curl && \
    rm -rf /var/lib/apt/lists/*

# Copiar backend
COPY backend/ ./backend/

# Copiar requirements.txt y frontend compilado
COPY backend/requirements.txt ./backend/
COPY --from=frontend-builder /app/frontend/build ./backend/static

# Instalar dependencias de Python
RUN pip install --no-cache-dir -r backend/requirements.txt

# Establecer variables de entorno por defecto
ENV FLASK_APP=backend/run.py
ENV PYTHONUNBUFFERED=1
ENV PORT=5000

# Exponer puerto
EXPOSE 5000

# Comando de arranque
WORKDIR /app/backend
CMD ["python3", "run.py"]
