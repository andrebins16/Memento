extends Node2D

var cherry = preload("res://Collectables/Cherry.tscn")


func _on_timer_timeout():
	var cherryTemp = cherry.instantiate()
	var rng = RandomNumberGenerator.new()
	cherryTemp.position = Vector2(rng.randi_range(50,500),rng.randi_range(505,510))
	get_node(".").add_child(cherryTemp)
	
