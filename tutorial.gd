extends Node2D

const lines:Array[String] = ["Eu me lembro disso... É a floresta do nosso chalé de férias!","Press the arrows to move!","Press Q to explode... But you will return to your start position!","Press the up arrow to jump!","Press E to create a platform... But you will return to your start position... Again!"]
const inputs:Array[String] = ["Enter","right","explode","jump","platform"]
var index=0
@onready var player = $Player/Player
func _ready():
	GameManager.start_dialog(Vector2(400,410),lines)
	print(player.global_position)

func _process(delta):
	if index ==0:
		if Input.is_action_just_pressed(inputs[index]):
			index+=1
	
	else: 
		if index<inputs.size():
			if Input.is_action_just_pressed(inputs[index]):
				index+=1
				GameManager.nextLine()
