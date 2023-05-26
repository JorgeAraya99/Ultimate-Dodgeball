extends Camera2D

var  target_player = null
var  target_vida
var target
# Called when the node enters the scene tree for the first time.

#func _on_vida_cambiada(nueva_vida):
#	$HUD/Label.text = str(nueva_vida)

func _ready():
	target_player = Global.player_master
	#print("Esto es en camara" + str(target_vida))
	#print("Esto es un print desde camara" + str(target_player.get_node()))
	#target_player.connect("vida_cambiada", self, "_on_vida_cambiada()")
	

func _process(_delta):
	if Global.player_master != null:
		global_position = Global.player_master.global_position
		target_vida = Global.player_master_vida
		$HUD/Label.text = "VIDA=" + str(target_vida)
# Called every frame. 'delta' is the elapsed time since the previous frame.

