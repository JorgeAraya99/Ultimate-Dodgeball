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
	pass

func applyPowerup(player: Player):
	print("applypowerup padre")
	pass

func _on_area_entered(area : Area2D):
	print("area entered")
#	queue_free()
#	if area.get_parent().get_class() == "CharacterBody2D":
#		pass
#		print("player = area")
#		#applyPowerup(area.get_parent())
#
#	print(area.name)
#	print(str(area.get_parent().get_groups()))
#	print("player != area")
		


func _on_body_entered(body):
	#print("area entered")
	queue_free()
	if body.get_class() == "CharacterBody2D":
		
		#print("player = area")
		applyPowerup(body)
		queue_free()
		
	print(str(body))
	#print("player != area")
