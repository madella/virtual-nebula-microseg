import socket              
import random
import time
import os

hostname = os.environ.get("HOSTNAME")
print(hostname)

s = socket.socket()        
host = '192.168.100.50' 
port = 1883 

def generate_data():
    temperature = random.randint(10, 30)
    humidity = random.randint(0, 100)
    return temperature, humidity

def main():
    s.connect((host, port))
    while True:
        temp, hum = generate_data()
        message=f"{hostname}] {temp}°C {hum}% \n"
        try:
            print(message,temp,hum)
            s.sendall(message.encode())
        except:
            break
        time.sleep(random.randint(1, 5))
    s.close()

if __name__ == "__main__":
    main()
