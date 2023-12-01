extends Node2D

@onready var timer=$TimerFala
const lines:Array[String] = ["Now you have to race against time... Run!"]

func _ready():
	GameManager.start_dialog(Vector2(200,400),lines)
	timer.set_wait_time(5)
	timer.start()


func _on_timer_fala_timeout():
	GameManager.killBox()
	timer.queue_free()
	
