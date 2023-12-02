extends Node2D

const lines:Array[String] = ["Eu me lembro disso... É a floresta do nosso chalé de férias!","Clique nas setas para se mover!","CLique Q para explodir... Mas você vai retornar para sua posição de início!","Clique a seta para cima para pular!","Clique E para criar uma plataforma... Mas você vai retornar para sua posição de início... De novo!"]
const inputs:Array[String] = ["Enter","right","explode","jump","platform"]
var index=0
@onready var player = $Player/Player
func _ready():
	GameManager.start_dialog(Vector2(75,410),lines)
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
