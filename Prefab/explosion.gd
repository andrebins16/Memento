extends StaticBody2D

var tilemap:TileMap
var explodiu=false
@onready var anim = get_node("AnimationPlayer")

func _physics_process(_delta):
	if explodiu:
		#await get_tree().create_timer(2.0).timeout
		var cell_pos = tilemap.local_to_map(self.get_global_transform().origin)
		var radius = 4
		for x in range(-radius, radius + 1):
			for y in range(-radius, radius + 1):
				var new_cell_pos = Vector2(cell_pos) + Vector2(x, y)
				if new_cell_pos.distance_to(cell_pos) <= radius:
					tilemap.set_cell(0, new_cell_pos, -1)
	anim.play("explosion")
	await anim.animation_finished
	self.queue_free()



func setDestroy(body):
		if body.is_in_group("destroy"):
			if body is TileMap:
				tilemap = body
				explodiu = true
			else:
				print("explodiuoutro")
				body.queue_free()
	



func _on_centro_body_entered(body):
	setDestroy(body)


