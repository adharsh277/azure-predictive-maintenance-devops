# Use a lightweight Python image
FROM python:3.12-slim

# Set working directory inside container
WORKDIR /app

# Copy all files from current directory to container
COPY . /app

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Run the IoT simulator
CMD ["python", "functions/iot_simulator.py"]
