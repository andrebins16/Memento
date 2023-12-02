extends Node2D


const lines:Array[String] = ["Meu nome é... é... Otto! Mas onde que eu estou???",
							"A última coisa que me lembro é estar no hospital...",
							"Preciso me lembrar dos bons momentos da minha vida...",
							"Onde está a minha amada Mary??? Ela  não está aqui???",
							"Eu não consigo me lembrar do rosto da  minha Mary...",
							"Mas eu preciso me lembrar dela, dos nossos momentos...",
							"Devo explorar as minhas memórias para lembrar dela!!!"
							]


func _ready():
	
	GameManager.start_dialog(Vector2(380,360),lines)

	
func _process(delta):
	#print(GameManager.is_dialog_active)
	if not GameManager.is_dialog_active:
		get_tree().change_scene_to_file("res://tutorial.tscn")
		
		
