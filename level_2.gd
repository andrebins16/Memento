extends Node2D

@onready var timer=$TimerFala
const lines:Array[String] = ["Agora você tem que lutar contra o tempo... Corra!"]

func _ready():
	GameManager.start_dialog(Vector2(150,450),lines)
	timer.set_wait_time(5)
	timer.start()


func _on_timer_fala_timeout():
	GameManager.nextLine()
	timer.queue_free()
	
