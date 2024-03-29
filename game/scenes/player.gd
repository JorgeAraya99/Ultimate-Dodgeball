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
@onready var COLISSION = $CollisionShape2D
@onready var player_animation: AnimationPlayer = $PlayerAnimation
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var inviTimer = $InvinsibilityTimer
@onready var escudoTimer = $EscudoTimer
@onready var escudobool= false
@onready var playername: Label = $Playername

@onready var playerdash: Sprite2D = $Playerdash
@onready var dashcd_animation: AnimationPlayer = $DashCDAnimation
@onready var shield_sprite: Sprite2D = $ShieldSprite
@onready var shield_animation: AnimationPlayer = $ShieldAnimation

var NORMALSPEED : float = 150
var DASHSPEED : float = 500
var DASHDURATION : float = .1
var dashdirection = Vector2()
var DASHCOOLDOWNDUR : float = 4
var lookdirection = "front"
var damageInvi: float = 2.0

signal dead(playerid)

const Win_panel =preload("res://scenes/Win_panel.tscn") 


var VIDA = 5

func _ready():
	
	await get_tree().process_frame
	shield_sprite.visible = false
	playerdash.visible = false
	animation_tree.active = true
	if is_multiplayer_authority():
		Global.player_master=self
		
	
	
func _process(_delta):
	pass

func init(id):
	set_multiplayer_authority(id)
	name = str(id)
	Game.players_id.append(id)
	Game.players_life[id]=(VIDA)
	playername.text = Game.players_name[id]
	var skin = Game.players_skin[id] + 1
	var skin_route = "res://assets/characters/spritesheets/character"+str(skin)+".png"
	var new_texture = load(skin_route)
	sprite_2d.texture = new_texture


#func _on_Area2D_area_exited(area): 
#	if area.get_name() == "Ball": 
#		VIDA -= 1
#		print("Vida total es " + str(VIDA))



func _on_area_2d_area_entered(area):
	print("hit")
	
	if escudobool == true and area.get_name() == "Balon" :
		return
#		escudoTimer.stop()
#		escudobool=false
#		print("coliison layer deactivate")
#		set_collision_layer_value(2, false)
#		return
	
	if !inviTimer.is_stopped():
		return
	
	if area.get_name() == "Balon" and is_multiplayer_authority() and VIDA > 0:
		VIDA -= 1
		Game.players_life[multiplayer.get_unique_id()]-=1 
		
		inviTimer.start(damageInvi)
		
	if area.get_name() == "Balon" and is_multiplayer_authority() and VIDA==0:
		VIDA -= 1
		Game.players_life[multiplayer.get_unique_id()]-=1
		
		emit_signal("dead",multiplayer.get_unique_id())
		print("Vida total es " + str(VIDA))

func handle_player_dead1():
	var win =Win_panel.instantiate()
	add_child(win)
	

func _physics_process(_delta)  -> void:
	
	if is_multiplayer_authority():
		Global.player_master_vida = VIDA
		
		#print("La vida global del player es " + str(Global.player_master_vida))
		set_motion_mode(1)
		var input_direction = Vector2(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
		if input_direction.length() > 1 : input_direction = input_direction.normalized()
		#if VIDA == 0:
		#	COLISSION.disabled == true
		
		if Input.is_action_just_pressed("dash") and is_dashcooldown_down():
			dashdirection = input_direction
			start_dash(DASHDURATION)
			start_dashcooldown(DASHCOOLDOWNDUR)
			
		var SPEED = DASHSPEED if is_dashing() else NORMALSPEED
		velocity = dashdirection * SPEED if is_dashing() else input_direction * SPEED
				
		if VIDA >0:
			move_and_slide()
		
		rpc("send_position", global_position)
		rpc("send_velocity", velocity)
		
	if velocity.length() == 0:
		playback.travel("idle_front")
	else:
		if velocity.y > 0:
			playback.travel("move_front")
		elif velocity.y < 0:
			playback.travel("move_back")
		else:
			if velocity.x < 0:
				playback.travel("move_left")
			else:
				playback.travel("move_right")
		
@rpc("unreliable_ordered")
func send_position(pos: Vector2) -> void:
	global_position = pos
	
@rpc("unreliable_ordered")
func send_velocity(vel: Vector2) -> void:
	velocity = vel
	
func start_dash(dur) -> void:
	dash_timer.wait_time = dur
	dash_timer.start()
	
func is_dashing() -> bool:
	return !dash_timer.is_stopped()

func start_dashcooldown(dur) -> void:
	dash_cooldown.wait_time = dur
	if is_multiplayer_authority():
		playerdash.visible = true
		dashcd_animation.play("dash_cooldown")
	dash_cooldown.start()
	
func is_dashcooldown_down() -> bool:
	return dash_cooldown.is_stopped()
	
func escudo(time):
	escudobool = true
	if is_multiplayer_authority():
		shield_sprite.visible = true
		shield_animation.play("shield_active")
	escudoTimer.start(time)
	print("colision layer activate")
	set_collision_layer_value(2, true)


func _on_invinsibility_timer_timeout():
	print("invi timeout")
	
func _on_escudo_timer_timeout():
	escudobool = false
	shield_sprite.visible = false
	shield_animation.stop()
	set_collision_layer_value(2, false)
	print("escudo timeout")
	print("layer deactivate")


func _on_dash_cooldown_timeout() -> void:
	if is_multiplayer_authority():
		playerdash.visible = false
