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

#{ id: true}
var status = {1: false}

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
	
	ok.pressed.connect(_on_ok_pressed)
	
func _on_host_pressed() -> void:
	Debug.print("host")
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT, MAX_PLAYERS)
	multiplayer.multiplayer_peer = peer
	start.hide()
	_add_player(user.text, multiplayer.get_unique_id())
	pending.show()

func _on_join_pressed() -> void:
	Debug.print("join")
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip.text, PORT)
	multiplayer.multiplayer_peer = peer
	start.hide()
	_add_player(user.text, multiplayer.get_unique_id())
	pending.show()

func _on_connected_to_server() -> void:
	Debug.print("connected to server")
	
func _on_connection_failed() -> void:
	Debug.print("failed to connect")

func _on_peer_connected(id: int) -> void:
	Debug.print("peer connected %d" % id)
	rpc_id(id, "send_info", {"name": user.text})
	if multiplayer.is_server():
		status[id] = false

func _on_peer_disconnected(id: int) -> void:
	Debug.print("peer disconnected %d" % id)

func _on_server_disconnected() -> void:
	Debug.print("server disconnected")
	
func _add_player(name: String, id: int):
	var label = Label.new()
	label.name = str(id)
	label.text = name
	players.add_child(label)
	Game.players.append(id)

@rpc("any_peer","reliable")
func send_info(info: Dictionary):
	var name = info.name
	var id = multiplayer.get_remote_sender_id()
	_add_player(name, id)
	
func _paint_ready(id :int) ->void:
	for child in players.get_children():
		if child.name == str(id):
			child.modulate = Color.SPRING_GREEN 
	
func _on_ok_pressed() -> void:
	rpc("player_ready")
	_paint_ready(multiplayer.get_unique_id())
	
@rpc("reliable", "any_peer", "call_local")
func player_ready():
	var id = multiplayer.get_remote_sender_id()
	_paint_ready(id)
	if multiplayer.is_server():
		status[id] = true
		var all_set = true
		for set in status.values():
			all_set = all_set and set
		if all_set:
			rpc("start_game")
		
@rpc("any_peer", "call_local", "reliable")
func start_game() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
