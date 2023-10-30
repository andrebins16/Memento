extends Area2D

var variation=12
var initial_pos
var offset=0
var up=true

func _ready():
	initial_pos=position

func _on_body_entered(body):
	if body.name == "Player":
		body.nextLevelBool=true

func _process(delta):
	if up:
		offset+=0.3
		position.y+=0.3
		if offset>=variation:
			up=not up
	else:
		offset-=0.3
		position.y-=0.3
		if offset<=-variation:
			up=not up
