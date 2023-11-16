extends Node2D

@export var imgs:Array[String]
@onready var sprite=$Sprite2D

@onready var transition_node= $Transition
@onready var transition = get_node("Transition/Fill")
@onready var anim_transition = get_node("Transition/Fill/Animation")

@onready var but=$VBoxContainer/Menu
# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.texture=load(imgs[GameManager.currentLevelNumber])
	_out_transition(2,0.7,0)
	await anim_transition.animation_finished 
	transition_node.visible=false



func _on_menu_pressed():
	print("cliqueii")
	get_tree().change_scene_to_file("res://main.tscn")


func _on_next_pressed():
	get_tree().change_scene_to_file(GameManager.nextLevel)


func _out_transition(type,duration,player):
	transition_node.visible=true
	transition.material.set_shader_parameter("type",type)
	anim_transition.speed_scale=duration
	if type==1:
		transition.material.set_shader_parameter("player",player)
	anim_transition.play("transition_out")
