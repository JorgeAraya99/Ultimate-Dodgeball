extends Node2D

@export var Player: PackedScene
@onready var players: Node2D = $Players


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for id in Game.players:
		var player = Player.instantiate()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
