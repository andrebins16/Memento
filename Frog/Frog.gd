extends CharacterBody2D

@export var speed = 250
@export var acceleration = 0.5
@export var gravity = 4000
 
var chase = false

@onready var player = get_node("../Player/Player")
@onready var animated_sprite = get_node("AnimatedSprite2D")
@onready var raycast = $RayCast2D

func _ready():
	animated_sprite.play("Idle")
	#raycast.cast_to = Vector2(0, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
#	if not is_on_floor():
#		velocity.y += gravity * delta
	var blend
	if animated_sprite.animation != "Death":
		
		if chase: 
			var direction = (player.position - self.position).normalized()
			raycast.target_position = direction *150 # Define a direção do raio
			raycast.force_raycast_update()
			if raycast.is_colliding() and raycast.get_collider().name == "Player":
				
				animated_sprite.play("Jump")
				blend =  1 - pow(0.5 , delta * acceleration *15)
				velocity=lerp(velocity,direction*speed,blend)
				if direction.x > 0:
					#velocity.x = lerp(velocity.x,1.0*speed,blend)
					animated_sprite.flip_h = true
				else:
					#velocity.x = lerp(velocity.x,-1.0*speed,blend)
					animated_sprite.flip_h = false
			else:
				
				animated_sprite.play("Idle")
				velocity=Vector2.ZERO
		else:
		
			animated_sprite.play("Idle")
			velocity=Vector2.ZERO
		move_and_slide()


func _on_player_detection_body_entered(body):
	if body.name == "Player":
		chase = true
		
		
		
func _on_player_detection_body_exited(body):
	if body.name == "Player":
		chase = false


func _on_player_death_body_entered(body):
	if body.name == "Player" and not body.respawning :
		if animated_sprite.animation != "Death":
			body.resetPos()
			#body.health =0
			#Game.player_hp =0
