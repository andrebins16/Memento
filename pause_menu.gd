extends Control

signal finished_pausing()

func _on_resume_pressed():
	finished_pausing.emit()
	self.queue_free()


func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://main.tscn")
	Engine.time_scale=1
	

