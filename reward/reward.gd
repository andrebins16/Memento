extends Sprite2D

var destination
@export var imgs:Array[String]

signal finished_animation()
# Called when the node enters the scene tree for the first time.

func _ready():
	self.z_index = 1
	texture=load(imgs[GameManager.currentLevelNumber])
	var tween = get_tree().create_tween()
	tween.tween_property(self,"position", destination,1.0)
	var tween2= get_tree().create_tween()
	tween2.tween_property(self,"scale", Vector2(0.3,0.3),1.0)
	var tween3 = get_tree().create_tween()
	tween3.tween_property(self, "rotation_degrees", 1080,1.0)
	await get_tree().create_timer(3.0).timeout
	finished_animation.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
