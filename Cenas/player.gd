extends CharacterBody2D


class_name Player

@export_group("Locomotion")
@export var speed = 200
@export var jump_velocity = -350
@export var run_speed_damping = 0.5

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= 0.5
	
	var direction = Input.get_axis("left", "right")
	
	if direction:
		velocity.x = lerp(velocity.x, speed * direction, run_speed_damping * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, speed * delta)
	
	move_and_slide()
	if velocity.x > 0:
		$Animacao_Gojo.play("walk_gojo")
	elif velocity.x < 0:
		$Animacao_Gojo.play("walk_gojo_inverted")
	else:
		$Animacao_Gojo.stop()
		
	if Input.is_action_just_pressed("Lapse_Vermelho"):
		$Animacao_Gojo.play("Lapse_Vermelho")
