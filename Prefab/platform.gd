extends StaticBody2D
@onready var sprite =$Sprite2D
var boolean=true

func _ready():
	sprite.scale=Vector2(0.5,1.0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if boolean:
		var tween = get_tree().create_tween()
		tween.tween_property(sprite,"scale", Vector2(2.0,4.0),0.5)

		await tween.finished
		boolean=false
