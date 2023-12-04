extends Node2D


const lines:Array[String] = ["Meu nome é... é... Otto! Mas onde que eu estou???",
							"A última coisa que me lembro é estar no hospital...",
							"Preciso me lembrar dos bons momentos da minha vida...",
							"Onde está a minha amada Mary??? Ela  não está aqui???",
							"Eu não consigo me lembrar do rosto da  minha Mary...",
							"Mas eu preciso me lembrar dela, dos nossos momentos...",
							"Devo explorar as minhas memórias para lembrar dela!!!"
							]

@onready var transition_node= $Transition
@onready var transition = get_node("Transition/Fill")
@onready var anim_transition = get_node("Transition/Fill/Animation")

var start_transition=false


func _ready():
	transition_node.visible=false
	GameManager.start_dialog(Vector2(380,360),lines)

	
func _process(delta):
	if start_transition:
		return
		
	if not GameManager.is_dialog_active:
		start_transition=true
	
	if start_transition:
		_in_transition(2,0.7,0)
		await anim_transition.animation_finished 
		transition_node.visible=false
		get_tree().change_scene_to_file("res://tutorial.tscn")
		
		
		
func _in_transition(type,duration,player):
	print("inn")
	transition_node.visible=true
	transition.material.set_shader_parameter("type",type)
	anim_transition.speed_scale=duration
	if type==1:
		transition.material.set_shader_parameter("player",player)
	anim_transition.play("transition_in")
		
		
