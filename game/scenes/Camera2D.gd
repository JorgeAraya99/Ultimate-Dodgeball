extends Camera2D

var  target_player = null

var target
# Called when the node enters the scene tree for the first time.
func _ready():
	target_player = Global.player_master
	
		
func _process(_delta):
	if Global.player_master != null:
		global_position = Global.player_master.global_position
# Called every frame. 'delta' is the elapsed time since the previous frame.

