extends CharacterBody2D

@export var initialX = 0
@export var initialY = 0
@export var health = 10
@export var speed = 400.0
@export var jump_velocity = -800
@export var gravity = 3000
@export_range(0.0, 1.0) var friction = 0.9
@export_range(0.0 , 1.0) var acceleration = 1
@export_range(0.0, 1.0) var resistance = 0.3

@export var jump_buffer_time = 0.075
var jump_buffer_counter =0

@export var coyote_time = 0.075
var coyote_counter =0

var double_jump_counter = 0

@onready var animated_sprite = get_node("AnimatedSprite2D")
@onready var anim = get_node("AnimationPlayer")

@export var platform= preload("res://Prefab/platform.tscn")
@export var platform_node: Node2D

@export var explosion = preload("res://Prefab/explosion.tscn")
@export var explosion_node: Node2D

@export var time=10.0
@export var timerNode:Timer



var respawning = false

@onready var collider =get_node("CollisionShape2D")

@onready var camera = get_node("Camera2D")
@export var tilemap:TileMap


# Velocidade de interpolação
@export var interp_speed = 1.25

# Distância de lookahead
@export var lookahead = 250.0

var death_audio = preload("res://audios/death.wav")
var jump_audio = preload("res://audios/jump.wav")
var explosion_audio = preload("res://audios/explosion.wav")
var wood_audio = preload("res://audios/wood.wav")
var step_audio=preload("res://audios/step.wav")

@onready var audio_player = $AudioStreamPlayer2D


const lines:Array[String] = ["Ola genteee","VAmossss"]

@export var levelNumber:int
@export var sceneName=""
@export var nextLevel= "res://world_2.tscn"
var nextLevelBool = false


#@onready var pause_menu=$Camera2D/PauseMenu
var pause_menu=preload("res://pause_menu.tscn")
var pause_menu_instance
var paused=false

@onready var pause_button = $"../../UI/Button"


@onready var transition_node= $"../../Transition"
@onready var transition = get_node("../../Transition/Fill")
@onready var anim_transition = get_node("../../Transition/Fill/Animation")

@onready var reward = preload("res://reward/reward.tscn")
@onready var rewardpos=$"../../Cherry".position
var rewardwait=true

#######################################################################################
func _ready():
	position.x=initialX
	position.y=initialY
	
	var used = tilemap.get_used_rect()
# Defina os limites da câmera para os limites do TileMap
	camera.limit_left = used.position.x * tilemap.cell_quadrant_size
	camera.limit_top = used.position.y * tilemap.cell_quadrant_size
	camera.limit_right = (used.position.x + used.size.x) * tilemap.cell_quadrant_size
	camera.limit_bottom = (used.position.y + used.size.y) * tilemap.cell_quadrant_size

	print(camera.limit_left)
	print(camera.limit_right)
	print(camera.limit_top)
	print(camera.limit_bottom)
	
	#pause_menu.finished_pausing.connect(pauseMenu)
	health=1
	paused=false
	transition_node.visible=false
	
	timerNode.wait_time=time
	_out_transition(2,1.0,0) 
	await anim_transition.animation_finished
	transition_node.visible=false
	
	if time>0:
		timerNode.start()

	GameManager.currentLevel=sceneName
	GameManager.currentLevelNumber=levelNumber
	GameManager.nextLevel=nextLevel

	
	#pause_menu.hide()

	

#######################################################################################
func _physics_process(delta):
	
		
		
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
		
	if Input.is_action_just_pressed("pause"):
		pauseMenu()
		
	if Input.is_action_just_pressed("next") or nextLevelBool:
		var reward_instance = reward.instantiate()
		reward_instance.destination=camera.get_screen_center_position()
		reward_instance.finished_animation.connect(_next_level_transition)
		reward_instance.position=rewardpos
		platform_node.add_child(reward_instance)
		nextLevelBool=false
	
	
	if health>0 and not respawning and not paused:
		handleMovement(delta)
		handleJump(delta)
		if Input.is_action_just_pressed("platform"):
			createPlatform()
		if Input.is_action_just_pressed("explode"):
			createExplosion()
		
	cameraMove(delta)



######################################################################################
func cameraMove(delta):
	# Calcule a posição de lookahead
	var target_pos = position + velocity.normalized() * lookahead 
	# Interpole a posição da câmera para a posição de lookahead
	var moveVec = camera.global_position - target_pos
	
	camera.global_position += target_pos.normalized() * interp_speed *delta



#######################################################################################
func _on_timer_timeout():
	fullDeath()



######################################################################################
func resetPos():
	respawning=true
	#anim.play("Death")
	#await anim.animation_finished
	#anim.stop()
	audio_player.volume_db=0
	audio_player.stream=death_audio
	audio_player.play()
	var tween = get_tree().create_tween()
	var tween2= get_tree().create_tween()
	var tween5= get_tree().create_tween()
	tween.tween_property(animated_sprite,"modulate:g", 0.4,0.5)
	tween2.tween_property(animated_sprite,"modulate:b", 0.4,0.5)
	tween5.tween_property(animated_sprite, "rotation_degrees", 720, 0.5)

	await tween.finished
	await tween2.finished
	
	
	#animated_sprite.visible=false
	modulate.a=0
	collider.disabled=true
	animated_sprite.play("Idle") #pra nao bugar
	
	
	velocity.x=0
	velocity.y=0
	coyote_counter=0
	double_jump_counter=0
	jump_buffer_counter=0
	await get_tree().create_timer(0.33).timeout
	
	animated_sprite.modulate=Color(1, 1, 1, 1)
	animated_sprite.rotation_degrees=0
	# animações para voltar ao ponto inicial
	var tween3 = get_tree().create_tween()
	var tween4= get_tree().create_tween()
	tween3.tween_property(self,"position", Vector2(initialX,initialY),0.5)
	tween4.tween_property(self,"modulate:a", 1,0.5)
	await get_tree().create_timer(0.5).timeout
	#animated_sprite.visible=true
	respawning=false
	collider.disabled=false


#######################################################################################
func fullDeath():
	health=0
	timerNode.stop()
	audio_player.volume_db=0
	audio_player.stream=death_audio
	audio_player.play()
	var tween = get_tree().create_tween()
	var tween2= get_tree().create_tween()
	var tween5= get_tree().create_tween()
	tween.tween_property(animated_sprite,"modulate:g", 0.2,2)
	tween2.tween_property(animated_sprite,"modulate:b", 0.2,2)
	tween5.tween_property(animated_sprite, "rotation_degrees", 1440, 2)
#	await tween.finished
#	await tween2.finished
	animated_sprite.modulate=Color(1, 1, 1, 1)
	animated_sprite.rotation_degrees=0
	_in_transition(4,1.0,0) 
	await anim_transition.animation_finished
	transition_node.visible=false
	self.queue_free()
	get_tree().change_scene_to_file("res://deathscreen.tscn")


#######################################################################################
func createPlatform():
	
	respawning=true
#	animated_sprite.scale=Vector2(1.0,1.0)
#	anim.play("Respawn")
#	await anim.animation_finished
#	anim.stop()
	audio_player.volume_db=24
	audio_player.stream=wood_audio
	audio_player.play()
	animated_sprite.scale = Vector2(0.015, 0.015)
	#animated_sprite.visible=false
	collider.disabled=true
	modulate.a=0
	animated_sprite.play("Idle") #pra nao bugar

	var platform_temp = platform.instantiate()
	platform_temp.position = Vector2(position.x,position.y+10)
	platform_node.add_child(platform_temp)
	velocity.x=0
	velocity.y=0
	coyote_counter=0
	double_jump_counter=0
	jump_buffer_counter=0
	await get_tree().create_timer(0.33).timeout

	# animações para voltar ao ponto inicial
	var tween = get_tree().create_tween()
	var tween2= get_tree().create_tween()
	tween.tween_property(self,"position", Vector2(initialX,initialY),0.5)
	tween2.tween_property(self,"modulate:a", 1,0.5)
	await get_tree().create_timer(0.5).timeout
	#animated_sprite.visible=true
	respawning=false
	collider.disabled=false





#######################################################################################
func createExplosion():
	respawning=true
	modulate.a=0
	collider.disabled=true
	audio_player.volume_db=-5
	audio_player.stream=explosion_audio
	audio_player.play()
	var explosion_temp = explosion.instantiate()
	explosion_temp.position = Vector2(position.x,position.y)
	explosion_node.add_child(explosion_temp)
	velocity.x=0
	velocity.y=0
	coyote_counter=0
	double_jump_counter=0
	jump_buffer_counter=0
	await get_tree().create_timer(0.75).timeout
	
	# animações para voltar ao ponto inicial
	var tween = get_tree().create_tween()
	var tween2= get_tree().create_tween()
	tween.tween_property(self,"position", Vector2(initialX,initialY),0.5)
	tween2.tween_property(self,"modulate:a", 1,0.5)
	await get_tree().create_timer(0.5).timeout
	#animated_sprite.visible=true
	respawning=false
	collider.disabled=false
	
	

#######################################################################################
func handleMovement(delta):
	var direction = Input.get_axis("left", "right")
	var blend
	if direction:
		if velocity.y == 0:
			anim.play("Run")
			if not audio_player.is_playing():
				audio_player.volume_db=-20
				audio_player.stream=step_audio
				audio_player.play()
		blend =  1 - pow(0.5 , delta * acceleration *15)
		velocity.x = lerp(velocity.x,direction*speed,blend)
		if direction > 0:
			animated_sprite.flip_h=false
		else:
			animated_sprite.flip_h=true
	else:
		if velocity.y == 0:
			anim.play("Idle")
			
		if is_on_floor():
			blend =  1 - pow(0.5 , delta * friction*15)
			velocity.x = lerp(velocity.x,0.0,blend)
		else:
			blend = 1 - pow(0.5 , delta * resistance*15)
			velocity.x = lerp(velocity.x,0.0,blend)

	move_and_slide()



#######################################################################################
func handleJump(delta):
	if is_on_floor():
		coyote_counter = coyote_time
		double_jump_counter=0
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		if coyote_counter > 0:
			coyote_counter-= delta
		if jump_buffer_counter > 0 and double_jump_counter < 1:
			coyote_counter = 1 #to jump
			double_jump_counter+=1
			
		
	# Handle Jump.
	if Input.is_action_just_pressed("jump"):
		jump_buffer_counter = jump_buffer_time
	
	if jump_buffer_counter > 0:
		jump_buffer_counter -= delta
	
	if jump_buffer_counter > 0 and coyote_counter > 0:
		audio_player.volume_db=-10
		audio_player.stream=jump_audio
		audio_player.play()
		anim.play("Jump")
		velocity.y = jump_velocity
		jump_buffer_counter = 0
		coyote_counter = 0
	
	if velocity.y > 0:
		anim.play("Fall")
		
	if Input.is_action_just_released("jump"):
		if velocity.y < 0:
			velocity.y += 200
			
			
			
			
#############################################

func pauseMenu():
	
	if paused:
		pause_button.show()
		pause_button.set_disabled(false)
		pause_menu_instance.queue_free()
		Engine.time_scale=1
	else:
		pause_button.hide()
		pause_button.set_disabled(true)
		pause_menu_instance=pause_menu.instantiate()
		pause_menu_instance.finished_pausing.connect(pauseMenu)
		platform_node.add_child(pause_menu_instance)
		Engine.time_scale=0
	
	paused = not paused


func _on_button_pressed():
	pauseMenu()
	
func _in_transition(type,duration,player):
	print("inn")
	transition_node.visible=true
	transition.material.set_shader_parameter("type",type)
	anim_transition.speed_scale=duration
	if type==1:
		transition.material.set_shader_parameter("player",player)
	anim_transition.play("transition_in")
	

	
	
	
func _out_transition(type,duration,player):
	transition_node.visible=true
	transition.material.set_shader_parameter("type",type)
	anim_transition.speed_scale=duration
	if type==1:
		transition.material.set_shader_parameter("player",player)
	anim_transition.play("transition_out")
	
	
	
func _next_level_transition():
	_in_transition(2,0.7,0)
	await anim_transition.animation_finished 
	get_tree().change_scene_to_file("res://reward_screen/reward_screen.tscn")

	

	


