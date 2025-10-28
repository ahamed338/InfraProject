# Stage 1: Build stage
FROM python:3.9-slim as builder

WORKDIR /app

# Install build dependencies (minimal for Codespaces)
RUN apt-get update && apt-get install -y \
    gcc \
    python3-dev \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

# Stage 2: Production stage
FROM python:3.9-slim

WORKDIR /app

# Create non-root user for security
RUN groupadd -r appuser && useradd -r -g appuser appuser

# Copy installed packages from builder stage
COPY --from=builder /root/.local /root/.local

# Copy application code
COPY --chown=appuser:appuser app.py .
COPY --chown=appuser:appuser templates/ templates/
COPY --chown=appuser:appuser static/ static/

# Make sure scripts in .local are usable
ENV PATH=/root/.local/bin:$PATH

# Switch to non-root user
USER appuser

# Health check (using curl instead of requests for reliability)
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:5000/health || exit 1

EXPOSE 5000

CMD ["python", "app.py"]
