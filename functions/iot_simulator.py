import time
import json
import random
import os
from azure.iot.device import IoTHubDeviceClient, Message
from dotenv import load_dotenv

# Load .env from the same folder as this script
load_dotenv(dotenv_path=os.path.join(os.path.dirname(__file__), ".env"))

CONNECTION_STRING = os.getenv("IOT_HUB_CONNECTION_STRING")
if not CONNECTION_STRING:
    raise ValueError("IoT Hub connection string not found! Check your .env file.")

# Create IoT Hub client
client = IoTHubDeviceClient.create_from_connection_string(CONNECTION_STRING)

def generate_telemetry():
    telemetry = {
        "deviceId": "Device001",
        "temperature": round(random.uniform(20.0, 100.0), 2),
        "vibration": round(random.uniform(0.0, 10.0), 2),
        "pressure": round(random.uniform(1.0, 5.0), 2),
        "status": "OK"
    }
    return telemetry

try:
    for _ in range(20):  # send 20 messages only
        data = generate_telemetry()
        msg = Message(json.dumps(data))
        print(f"Sending: {data}")
        client.send_message(msg)
        time.sleep(5)

except KeyboardInterrupt:
    print("Simulation stopped")
finally:
    client.shutdown()
