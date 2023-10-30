extends Node2D





func _on_retry_pressed():
	print(GameManager.currentLevel)
	get_tree().change_scene_to_file(GameManager.currentLevel)

	


func _on_menu_pressed():
	get_tree().change_scene_to_file("res://main.tscn")
