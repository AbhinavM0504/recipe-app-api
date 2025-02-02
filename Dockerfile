FROM python:3.9-alpine3.13
LABEL maintainer="londonappdeveloper.com"

# Prevents Python from buffering stdout and stderr
ENV PYTHONUNBUFFERED=1

# Set up working directory and copy application code
WORKDIR /app
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app

# Install dependencies
ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --no-cache-dir --upgrade pip && \
    /py/bin/pip install --no-cache-dir -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
    then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser --disabled-password --no-create-home django-user

# Set environment variable to include virtualenv binaries in PATH
ENV PATH="/py/bin:$PATH"

# Expose port 8000 for the application
EXPOSE 8000

# Use a non-root user for security
USER django-user
