extends MarginContainer

const MAX_PLAYERS = 4
const PORT = 5300

@onready var user = %User
@onready var ip = %IP
@onready var host = %Host
@onready var join = %Join

@onready var start = %Start
@onready var pending = %Pending
@onready var cancel = %Cancel
@onready var ok = %Ok

# Called when the node enters the scene tree for the first time.
func _ready():
	host.pressed.connect(_on_host_pressed)
	join.pressed.connect(_on_join_pressed)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	start.show()
	pending.hide()
	
func _on_host_pressed():
	print("host")
	var peer = ENetMultiplayerPeer.new()
	start.hide()
	pending.show()

func _on_join_pressed():
	print("join")
	start.hide()
	pending.show()

func _on_connected_to_server():
	print("connected to server")
	
func _on_connection_failed():
	print("failed to connect")

func _on_peer_connected():
	print("peer connected")

func _on_peer_disconnected():
	print("peer disconnected")

func _on_server_disconnected():
	print("server disconnected")
