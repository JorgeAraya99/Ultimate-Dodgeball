extends CanvasLayer

@onready var title = $PanelContainer/MarginContainer/VBoxContainer/Label 

# Called when the node enters the scene tree for the first time.
func _ready():
	$PanelContainer/MarginContainer/VBoxContainer/Label.text= "Holafrom the code"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_back_to_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
	
	
func set_title(win: bool):
	if win:
		title.text = "YOU WIN!"
	
	else:
		print($PanelContainer/MarginContainer/VBoxContainer/Label.text)
		title.text = "YOU LOSE!"
		title.modulate=Color.RED
