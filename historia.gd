extends Node2D


const lines:Array[String] = ["Meu nome é... É... Otto! Mas onde eu estou?",
							"A última coisa que me lembro é estar no hospital...",
							"Onde está a minha amada Mary? Ela está aqui?",
							"Preciso me lembrar dos melhores momentos da minha vida...",
							"Mas eu não estou conseguindo me lembrar dela...",
							"Mas eu preciso me lembrar do rosto dela, dos nossos momentos...",
							"Agora minha missão é entrar nas minhas memórias para lembrar de Mary!"
							]

func _ready():
	
	GameManager.start_dialog(Vector2(400,350),lines)

	
func _process(delta):
	#print(GameManager.is_dialog_active)
	if not GameManager.is_dialog_active:
		get_tree().change_scene_to_file("res://tutorial.tscn")
