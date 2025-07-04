# Estágio 1: Builder - Instala as dependências
FROM python:3.13.4-alpine3.22 as builder

WORKDIR /app

# Instala as dependências de build necessárias para compilar alguns pacotes Python no Alpine
RUN apk add --no-cache build-base
RUN pip install --upgrade pip

COPY requirements.txt .
RUN pip wheel --no-cache-dir --wheel-dir /app/wheels -r requirements.txt

# Estágio 2: Final - Constrói a imagem final da aplicação
FROM python:3.13.4-alpine3.22

WORKDIR /app

COPY --from=builder /app/wheels /wheels
COPY . .
RUN pip install --no-cache /wheels/*

CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]