extends Node2D


const lines:Array[String] = ["Finalmente... Finalmente eu me lembrei dela!",
							"É tão bom poder relembrar minha amada Mary...",
							"Nossa maravilhosa vida juntos, o nosso amor!",
							"Agora já posso seguir a minha vida em paz...",
							]

@onready var transition_node= $Transition
@onready var transition = get_node("Transition/Fill")
@onready var anim_transition = get_node("Transition/Fill/Animation")

var start_transition=false

var started_dialog=false


func _ready():
	transition_node.visible=false
	_out_transition(2,1.0,0) 
	await anim_transition.animation_finished
	transition_node.visible=false
	GameManager.start_dialog(Vector2(180,360),lines)
	started_dialog=true

	
func _process(delta):
	if start_transition:
		return
		
	if not GameManager.is_dialog_active and started_dialog:
		start_transition=true
	
	if start_transition:
		_in_transition(2,0.7,0)
		await anim_transition.animation_finished 
		transition_node.visible=false
		get_tree().change_scene_to_file("res://main.tscn")

func _in_transition(type,duration,player):
	print("inn")
	transition_node.visible=true
	transition.material.set_shader_parameter("type",type)
	anim_transition.speed_scale=duration
	if type==1:
		transition.material.set_shader_parameter("player",player)
	anim_transition.play("transition_in")
		
		
func _out_transition(type,duration,player):
	transition_node.visible=true
	transition.material.set_shader_parameter("type",type)
	anim_transition.speed_scale=duration
	if type==1:
		transition.material.set_shader_parameter("player",player)
	anim_transition.play("transition_out")
