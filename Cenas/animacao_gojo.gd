extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func trigger_animation(velocity: Vector2, direction: int):
	
	if direction != 0:
		scale.x = direction
	
	if not get_parent().is_on_floor():
		play("jump_gojo") 
	elif sign(velocity.x) != sign(direction) && velocity.x != 0 && direction != 0:
		play("Lapse_Vermelho") 
	else: 
		play("jump_gojo")
