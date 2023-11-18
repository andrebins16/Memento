extends RigidBody2D

@export var delay=3.0
@onready var timer=$Timer

@onready var player = get_node("../Player/Player")

var spike_scene = preload("res://Spikes/spikes.tscn")
@onready var shot=preload("res://Shots/shot_kill.tscn")

@export var shot_node: Node2D

@onready var visibility_notifier = $VisibleOnScreenNotifier2D

func _ready():
	timer.wait_time=delay
	timer.start()

func _process(delta):
	self.look_at(player.global_position)

func _on_timer_timeout():
	if visibility_notifier.is_on_screen():
		var shot_instance=shot.instantiate()
		shot_instance.angle=rotation
		shot_instance.speed=150
		shot_instance.position=position+Vector2.RIGHT.rotated(rotation).normalized()*38
		shot_node.add_child(shot_instance)
	timer.start()
