extends RigidBody2D

@export var move=true
@export var speed = 250
@export var angle=0
var direction =Vector2.ZERO

func _ready():
	set_gravity_scale(0)
	direction= Vector2.DOWN.rotated(angle)
	if move:
		$Sprite2D.modulate.g=0.4
		$Sprite2D.modulate.b=0.4

func _physics_process(delta):
	if move:
		#var direction = Vector2.DOWN.rotated(rotation)
# Multiplique pela velocidade desejada
		var velocity = direction * speed
# Aplique a velocidade ao RigidBody2D
		set_linear_velocity(velocity)


func _on_area_2d_body_entered(body):
	print("bateu")
	if body.name == "Player" and not body.respawning:
		#body.health =0
		body.resetPos()
		print("baaaaaay")
	else:
		print(body)
		if ( not body.name == "Spikes") and move:
			await get_tree().create_timer(0.3).timeout
			queue_free()
