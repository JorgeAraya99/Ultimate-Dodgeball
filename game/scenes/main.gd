extends Node2D

@export var player_scene: PackedScene
@onready var players: Node2D = $Players
@onready var markers = $Markers

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Game.players.sort()
	for i in Game.players.size():
		var id = Game.players[i]
		var player: Player = player_scene.instantiate()
		players.add_child(player)
		var marker = markers.get_child(i)
		player.global_position = marker.global_position
		player.init(id)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
