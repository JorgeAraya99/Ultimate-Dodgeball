extends Node2D

@export var player_scene: PackedScene
@onready var players: Node2D = $Players
@onready var markers = $Markers
@onready var a = 1
@onready var GO=0
@onready var dead_players = 0
@onready var pnumber

const Win_panel =preload("res://scenes/Win_panel.tscn") 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	Game.players.sort()
	pnumber=Game.players.size()
	for i in Game.players.size():
		var id = Game.players[i]
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
		
#	for i in Game.players_life.values():
#		if GO==1:
#			break
#		if i == 0:
#			dead_players +=1
#		if pnumber-dead_players == 1:
#			print("GO")
#			GO=1
			
func handledead(id): #esta funcion checkea que haya solo un jugador con vida
	if GO==1:
		pass
	dead_players +=1
	if  pnumber - dead_players == 1:
		var win =Win_panel.instantiate()
		add_child(win)
		print("GO handledead")
		print(self.dead_players)
		print(id)
		GO+=1
		get_tree().paused=true
		

func _on_ball_timer_timeout():
	var ball_scene = preload("res://scenes/ball.tscn")
	var ball = ball_scene.instantiate()
	add_child(ball)
	ball.position = Vector2(200, 200)
