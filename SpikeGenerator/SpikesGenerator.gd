extends StaticBody2D

enum EnumState {PRE, FALL}
var state= EnumState.PRE
var spike_scene = preload("res://Spikes/spikes.tscn")
@onready var sprite = $Sprite2D
@export var delay = 3.0
var counter=0
var spike_instance
@onready var collider =get_node("CollisionShape2D")
@export var spike_speed=250

func _physics_process(delta):
	if state == EnumState.PRE:
		if counter >= delay:
			state =EnumState.FALL
			counter= 0
			spike_instance = spike_scene.instantiate()
			spike_instance.angle= rotation
			spike_instance.speed=spike_speed
			add_child(spike_instance)
			sprite.visible=false
			sprite.modulate.g=1.0
			sprite.modulate.b=1.0
			print(sprite.modulate)
			collider.disabled=true
		else:
			var tween = get_tree().create_tween()
			var tween2= get_tree().create_tween()
			if counter ==0:
				tween.tween_property(sprite,"modulate:g", 0.4,delay)
				tween2.tween_property(sprite,"modulate:b", 0.4,delay)
#				tween.tween_property(sprite,"modulate:g", 0.55,delay/3)
#				tween2.tween_property(sprite,"modulate:b", 0.55,delay/3)
#			if counter >= (2*delay)/3:
#				tween.tween_property(sprite,"modulate:g", 0.4,delay/3)
#				tween2.tween_property(sprite,"modulate:b", 0.4,delay/3)
#			else:
#				if counter >=delay/3:
#					tween.tween_property(sprite,"modulate:g", 1,delay/3)
#					tween2.tween_property(sprite,"modulate:b", 1,delay/3)
		counter +=delta
	else:
		if state == EnumState.FALL:
			counter+=delta
			if not is_instance_valid(spike_instance) or counter >= 6.0:
				state=EnumState.PRE
				sprite.modulate.g=1
				sprite.modulate.b=1
				sprite.visible=true
				collider.disabled=false
				counter=0


func _on_area_2d_body_entered(body):
	if body.name =="Player" and sprite.visible:
		body.resetPos()
