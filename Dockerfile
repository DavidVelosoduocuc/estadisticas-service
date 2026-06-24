FROM python:3.12-slim

# Prevent Python from writing pyc files to disc
ENV PYTHONDONTWRITEBYTECODE=1
# Prevent Python from buffering stdout and stderr
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Create a non-privileged user and group
RUN groupadd -g 10001 appuser && \
    useradd -u 10001 -g appuser -m -d /home/appuser -s /bin/bash appuser && \
    chown -R appuser:appuser /app

USER appuser

EXPOSE 8006

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8006"]
