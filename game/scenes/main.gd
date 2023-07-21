extends Node2D

@export var player_scene: PackedScene
@onready var players: Node2D = $Players
@onready var markers = $Markers
@onready var a = 1
@onready var GO=0
@onready var dead_players = 0
@onready var pnumber
@onready var animation_player: AnimationPlayer = $Camera2D/HUD/AnimationPlayer
@onready var animation_tree: AnimationTree = $Camera2D/HUD/AnimationTree

@onready var dead=false 

const Win_panel =preload("res://scenes/Win_panel.tscn") 

func _ready() -> void:
	Game.players.sort()
	pnumber=Game.players.size()
	for i in Game.players.size():
		var id = Game.players[i]
		#var rand_skin = randi() % 5
		var player: Player = player_scene.instantiate()
		player.dead.connect(handledead)
		players.add_child(player)
		var marker = markers.get_child(i)
		player.global_position = marker.global_position
		player.init(id)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if 0 in Game.players_life.values() and a!=0:
		print(str(Game.players_life))
		a -=1

func _on_ball_timer_timeout():
	var ball_scene = preload("res://scenes/ball.tscn")
	var ball = ball_scene.instantiate()
	add_child(ball)
	ball.position = Vector2(640, 385)
	

	
@rpc("any_peer", "call_local")
func add1():
	dead_players +=1

@rpc("any_peer", "call_local")
func handle_player_dead():
	var win =Win_panel.instantiate()
	add_child(win)
	win.set_title(!dead)
	get_tree().paused=true
	
func handledead(id): #esta funcion checkea que haya solo un jugador con vida
	if GO==1:
		pass
	rpc("add1")
	print("jugadores muertos:",dead_players)
	print("numero de jug:",pnumber)
	dead = true
	if pnumber - dead_players == 1:
		print(pnumber - dead_players)
		var win =Win_panel.instantiate()
		add_child(win)
		print("GO handledead")
		print(self.dead_players)
		print(id)
		rpc("handle_player_dead")

		GO+=1
		get_tree().paused=true
	


func _on_power_uptimer_timeout():
	pass
#	var Powerup_scene = preload("res://scenes/PowerUps/Escudo_PowerUp.tscn")
#	var Powerup = Powerup_scene .instantiate()
#	add_child(Powerup)
#	Powerup.position = Vector2(640, 385)
	
	
