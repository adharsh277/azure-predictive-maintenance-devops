import time
import json
import random
import os
from azure.iot.device import IoTHubDeviceClient
from dotenv import load_dotenv
from prometheus_client import start_http_server, Gauge

# Load .env
dotenv_path = os.path.join(os.path.dirname(__file__), ".env")
load_dotenv(dotenv_path)

# IoT Hub connection
CONNECTION_STRING = os.getenv("IOT_HUB_CONNECTION_STRING")
if not CONNECTION_STRING:
    CONNECTION_STRING = "HostName=predictive-iothub.azure-devices.net;DeviceId=Device001;SharedAccessKey=KQ1mHeBDPprTZTpJHqI3jJ6h3y+UMMpfWzdYchuMvSY="

client = IoTHubDeviceClient.create_from_connection_string(CONNECTION_STRING)

# Prometheus metrics
temperature_g = Gauge('device_temperature', 'Temperature of Device001')
vibration_g = Gauge('device_vibration', 'Vibration of Device001')
pressure_g = Gauge('device_pressure', 'Pressure of Device001')

# Start Prometheus server on port 8000
start_http_server(8000)
print("Prometheus metrics server started on port 8000...")

def generate_telemetry():
    telemetry = {
        "deviceId": "Device001",
        "temperature": round(random.uniform(20.0, 100.0), 2),
        "vibration": round(random.uniform(0.0, 10.0), 2),
        "pressure": round(random.uniform(1.0, 5.0), 2),
        "status": "OK"
    }
    # Update Prometheus metrics
    temperature_g.set(telemetry["temperature"])
    vibration_g.set(telemetry["vibration"])
    pressure_g.set(telemetry["pressure"])
    return telemetry

try:
    while True:
        data = generate_telemetry()
        msg = json.dumps(data)
        print(f"Sending: {data}")
        client.send_message(msg)
        time.sleep(5)

except KeyboardInterrupt:
    print("Simulation stopped")
finally:
    client.shutdown()
