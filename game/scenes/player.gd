class_name Player
extends CharacterBody2D


#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0
#const GRAVITY = 500
#const ACCELERATION = 4000
#
## Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#
#
#func _ready():
#	pass
#
#func _process(delta):
#	pass
#
#func _physics_process(delta):
#	# Add the gravity.
#	if not is_on_floor():
#		velocity.y += GRAVITY * delta
#
#	# Handle Jump.
#	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
#		velocity.y = JUMP_VELOCITY
#
#	# Get the input direction and handle the movement/deceleration.
#	# As good practice, you should replace UI actions with custom gameplay actions.
#	var direction = Input.get_axis("ui_left", "ui_right")
#	if direction:
#		velocity.x = direction * SPEED
#
#	var move_input = Input.get_axis("move_left", "move_right")
#
#	velocity.x = move_toward(velocity.x, move_input*SPEED,ACCELERATION*delta)
#
#	move_and_slide()

@onready var dash_timer: Timer = $dashTimer
@onready var dash_cooldown: Timer = $dashCooldown

var NORMALSPEED : float = 150
var DASHSPEED : float = 500
var DASHDURATION : float = .1
var dashdirection = Vector2()
var DASHCOOLDOWNDUR : float = 4

func _ready():
	pass
	
func _process(delta):
	pass

func init(id):
	set_multiplayer_authority(id)
	name = str(id)

func _physics_process(_delta)  -> void:
	
	if is_multiplayer_authority():
		
		set_motion_mode(1)
		
		var input_direction = Vector2(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
		if input_direction.length() > 1 : input_direction = input_direction.normalized()
		
		if Input.is_action_just_pressed("dash") and is_dashcooldown_down():
			dashdirection = input_direction
			start_dash(DASHDURATION)
			start_dashcooldown(DASHCOOLDOWNDUR)
			
		var SPEED = DASHSPEED if is_dashing() else NORMALSPEED
		velocity = dashdirection * SPEED if is_dashing() else input_direction * SPEED
		
		move_and_slide()
		
		rpc("send_position", global_position)
		
@rpc("unreliable_ordered")
func send_position(pos: Vector2) -> void:
	global_position = pos
	
func start_dash(dur) -> void:
	dash_timer.wait_time = dur
	dash_timer.start()
	
func is_dashing() -> bool:
	return !dash_timer.is_stopped()

func start_dashcooldown(dur) -> void:
	dash_cooldown.wait_time = dur
	dash_cooldown.start()
	
func is_dashcooldown_down() -> bool:
	return dash_cooldown.is_stopped()
