extends Area2D

var bullet_speed := 300.0
var direction  := 1
# Called when the node enters the scene tree for the first time


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += bullet_speed * direction * delta 
	if Input.is_action_pressed("Vazio_Roxo"):
		$AnimatedSprite2D.play("Purple_animation")

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
func set_direction(dir):
	direction = dir
	if dir <0:
		$AnimatedSprite2D.set_flip_h(true)
	else:
		$AnimatedSprite2D.set_flip_h(false)
	

 # Replace with function body.
