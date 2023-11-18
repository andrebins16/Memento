extends RigidBody2D



@export var speed = 250
@export var angle=0
var direction =Vector2.ZERO

func _ready():
	set_gravity_scale(0)
	direction= Vector2.RIGHT.rotated(angle)


func _physics_process(delta):
# Multiplique pela velocidade desejada
	var velocity = direction * speed
# Aplique a velocidade ao RigidBody2D
	set_linear_velocity(velocity)


func _on_area_2d_body_entered(body):
	print(body)
	if body.name == "Player" and not body.respawning:
		#body.health =0
		queue_free()
		body.resetPos()
		#print("kill")
	else:
		var groups=body.get_groups()
		print("name")
		print(body.name)
		if (body.name.begins_with("Platform") or body.name.begins_with("Tile") or body.name.begins_with("Spike")) :
			queue_free()
