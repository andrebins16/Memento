extends CanvasLayer

@onready  var fill=$Fill
@onready  var anim=$Fill/Animation



func _in(type,duration,player):
	fill.material.set_shader_parameter("type",type)
	#anim.playback_speed=duration
	if type==1:
		fill.material.set_shader_parameter("player",player)
	anim.play("transition_in")
	await anim.animation_finished
	queue_free()
	
func _out(type,duration,player):
	fill.material.set_shader_parameter("type",type)
	#anim.playback_speed=duration
	if type==1:
		fill.material.set_shader_parameter("player",player)
	anim.play("transition_out")
	await anim.animation_finished
	queue_free()

