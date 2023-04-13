extends CharacterBody2D

var inicio = 1

func _physics_process(delta):
	
	if inicio == 1:
		velocity = Vector2(200,200)
		inicio = 0
	
	else:
		var collision_info = move_and_collide(velocity*delta)
		if collision_info:
			print("I collided with ", collision_info.get_collider().name)
			velocity = velocity.bounce(collision_info.get_normal())
