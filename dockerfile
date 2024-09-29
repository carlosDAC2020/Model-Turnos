# Usa la imagen base de Python
FROM python:3.11

# Establece el directorio de trabajo en /app
WORKDIR /app

# Instala locales y genera es_ES.UTF-8
RUN apt-get update && \
    apt-get install -y locales && \
    locale-gen es_ES.UTF-8 && \
    update-locale LANG=es_ES.UTF-8

# Establece las variables de entorno para la localización
ENV LANG es_ES.UTF-8
ENV LANGUAGE es_ES:es
ENV LC_ALL es_ES.UTF-8

# Copia el archivo requirements.txt al directorio de trabajo
COPY requirements.txt .

# Instala las dependencias especificadas en requirements.txt
RUN pip3 install -r requirements.txt

# Copia el resto de los archivos al directorio de trabajo
COPY . .

# Expone el puerto 8001 para que la aplicación sea accesible desde fuera del contenedor
EXPOSE 8001

# Comando para ejecutar la aplicación cuando se inicie el contenedor
CMD ["python3", "main.py"]
