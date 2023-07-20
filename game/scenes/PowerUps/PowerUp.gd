extends Area2D

class_name PowerUp

var powerupMoveSpeed = 50  

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	position

func applyPowerup(player: Player):
	pass

func _on_area_entered(area):
	if area == Player:
		applyPowerup(area)
		queue_free()
		
