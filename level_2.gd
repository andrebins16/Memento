extends Node2D

const lines:Array[String] = ["Now you have to race against time... Run!"]
func _ready():
	GameManager.start_dialog(Vector2(200,400),lines)
