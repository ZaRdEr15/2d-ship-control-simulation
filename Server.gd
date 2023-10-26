extends Node

const PORT = 5050
const ADDRESS = "192.168.0.248"
const HEADER = 64
const DISCONNECT_MESSAGE = "DISCONNECT"

var server : TCPServer
var client : StreamPeerTCP
var client_address
var client_port
var connected = false

func _ready():
	print("Starting server...")
	server = TCPServer.new()
	if server.listen(PORT, ADDRESS) != OK:
		print("Error listening on ", ADDRESS, ":", PORT)
	else:
		print("Listening on ", ADDRESS, ":", PORT)

func _process(_delta):
	if server.is_connection_available():
		client = server.take_connection() # accept connection
		connected = true
		client_address = client.get_connected_host()
		client_port = client.get_connected_port()
		print("Client ", client_address, ":", client_port, " has connected!")
	if connected:
		if client.get_status() == StreamPeerTCP.STATUS_NONE:
			client_disconnected(client_address, client_port)
			connected = false
			return
		var msg_len = client.get_utf8_string(HEADER)
		if msg_len:
			msg_len = int(msg_len)
			var msg = client.get_utf8_string(msg_len)
			if msg == DISCONNECT_MESSAGE:
				client_disconnected(client_address, client_port)
				client.disconnect_from_host()
				connected = false
				return
			print("[", client_address, ":", client_port, "]: ", msg)
			
func client_disconnected(address, port):
	print("Client ", client.get_connected_host(), ":", client.get_connected_port(), " has disconnected!")
