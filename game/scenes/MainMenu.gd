extends Control



func _on_button_play_pressed():
	get_tree().change_scene_to_file("res://scenes/lobby.tscn")
	
	


func _on_button_exit_pressed():
	get_tree().quit()


func _on_button_credits_pressed():
	get_tree().change_scene_to_file("res://scenes/Credits.tscn") 
