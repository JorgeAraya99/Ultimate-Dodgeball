extends MarginContainer

const MAX_PLAYERS = 4
const PORT = 5300

@onready var user = %User
@onready var ip = %IP
@onready var host = %Host
@onready var join = %Join

@onready var start = %Start
@onready var pending = %Pending
@onready var players: VBoxContainer = %Players


@onready var cancel: Button = $PanelContainer/MarginContainer/Pending/HBoxContainer/Cancel
@onready var ok: Button = $PanelContainer/MarginContainer/Pending/HBoxContainer/Ok


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
	#user.text = OS.get_environment("USERNAME")
	
func _on_host_pressed() -> void:
	Debug.print("host")
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT, MAX_PLAYERS)
	multiplayer.multiplayer_peer = peer
	start.hide()
	_add_player(user.text)
	pending.show()

func _on_join_pressed() -> void:
	Debug.print("join")
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip.text, PORT)
	multiplayer.multiplayer_peer = peer
	start.hide()
	_add_player(user.text)
	pending.show()

func _on_connected_to_server() -> void:
	Debug.print("connected to server")
	
func _on_connection_failed() -> void:
	Debug.print("failed to connect")

func _on_peer_connected(id: int) -> void:
	Debug.print("peer connected %d" % id)

func _on_peer_disconnected(id: int) -> void:
	Debug.print("peer disconnected %d" % id)

func _on_server_disconnected() -> void:
	Debug.print("server disconnected")
	
func _add_player(name: String):
	var label = Label.new()
	label.text = name
	players.add_child(label)
	
