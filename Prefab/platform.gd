extends StaticBody2D
@onready var sprite =$Sprite2D
var boolean=true

var gift_path="res://audios/gift.png"

func _ready():
	if GameManager.currentLevelNumber>5:
		sprite.texture=load(gift_path)
		sprite.scale=Vector2(0.25,0.25)
	else:
		sprite.scale=Vector2(0.5,1.0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if boolean:
		var tween = get_tree().create_tween()
		if GameManager.currentLevelNumber>5:
			tween.tween_property(sprite,"scale", Vector2(1.0,1.0),0.5)
		else:
			tween.tween_property(sprite,"scale", Vector2(2.0,4.0),0.5)

		await tween.finished
		boolean=false
