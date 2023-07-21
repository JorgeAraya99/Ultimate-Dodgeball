extends CharacterBody2D

var inicio = 1

func _physics_process(delta):
	
	set_motion_mode(1)
	
	if inicio == 1:
		velocity = Vector2(200,200)
		var rand_vel = randi_range(0,3)
		inicio = 0
		match rand_vel:
			0: velocity = Vector2(200,200)
			1: velocity = Vector2(200,-200)
			2: velocity = Vector2(-200,200)
			3: velocity = Vector2(-200,-200)
		
	else:
		var collision_info = move_and_collide(velocity*delta)
		if collision_info:
			#print("I collided with ", collision_info.get_collider().name)
			velocity = velocity.bounce(collision_info.get_normal())
