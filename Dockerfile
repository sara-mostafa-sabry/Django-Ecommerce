FROM python:3.7-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir "setuptools==45"

COPY . .

RUN pip install --no-cache-dir -r requirements.txt

# Expose the application port
EXPOSE 8000

# Run migrations
RUN python manage.py migrate --noinput

# Run unit tests
#RUN pytest test ..>> There're no test cases to test
RUN python manage.py test

# Scan the application for vulnerabilities and save output to a file
RUN safety check > safety_check_output.txt || echo "Safety check failed. Check safety_check_output.txt for details."

# Command to run the Django development server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
