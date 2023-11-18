extends Node2D

@export var size = 10.0

@export var speed = 0.1

@onready var spike=$Spikes
@onready var sprite=$Spikes/Sprite2D
@onready var col1=$Spikes/Area2D/CollisionShape2D
@onready var col2=$Spikes/CollisionShape2D
@onready var area=$Area2D

func _ready():
	sprite.scale=Vector2(6.533*size,size)
	col1.scale=Vector2(size*1.02,size/1.98)
	col2.scale=Vector2(size,size/2)
	area.scale=Vector2(size,size/2)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation+=speed


func _on_area_2d_body_entered(body):
	print("olaaaaaaaaaa")
	if not body.name =="Spikes" and not body.name=="Player":
		speed=0
		
