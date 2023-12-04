extends Node2D

@onready var timer=$TimerFala
const lines:Array[String] = ["Aqui foi onde eu e Mary viemos no Natal em que nos casamos! Estou quase conseguindo!"]

func _ready():
	GameManager.start_dialog(Vector2(100,400),lines)
	timer.set_wait_time(10)
	timer.start()


func _on_timer_fala_timeout():
	GameManager.nextLine()
	timer.queue_free()
	
