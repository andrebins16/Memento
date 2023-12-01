extends Node2D


func _ready():
	Utils.loadGame()
	#GameManager.player_hp=10
	
func _on_quit_pressed():
	get_tree().quit()


func _on_play_pressed():
	get_tree().change_scene_to_file("res://historia.tscn")
