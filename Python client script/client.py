import socket

HEADER = 64 # How many bytes the length of the message is

PORT = 5050
SERVER = "192.168.0.248"
ADDRESS = (SERVER, PORT)
DISCONNECT_MESSAGE = "DISCONNECT"


UP_KEY = "UP"
DOWN_KEY = "DOWN"
LEFT_KEY = "LEFT"
RIGHT_KEY = "RIGHT"
NO_KEY = "NONE"

client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client.connect(ADDRESS)

# First, send the amount of bytes the message will be, and
# pad the length with the amount of bytes in the header
# Example '5    ', then 'hello' etc
def send(msg):
    message = msg.encode()
    msg_length = len(message)
    send_length = str(msg_length).encode()
    send_length += b' ' * (HEADER - len(send_length))
    client.send(send_length)
    client.send(message)

send("Hello, server")
send(UP_KEY)
send(DOWN_KEY)
send(LEFT_KEY)
send(RIGHT_KEY)
send(DISCONNECT_MESSAGE)