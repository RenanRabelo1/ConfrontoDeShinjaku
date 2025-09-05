extends CharacterBody2D


class_name Player

@export_group("Locomotion")
@export var speed = 200
@export var jump_velocity = -350
@export var run_speed_damping = 0.5

const BULLET_SCENE = preload("res://Cenas/bullet.tscn")


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_shooting := false

@onready var bullet_position: Marker2D = $bullet_position
@onready var shoot_cooldown: Timer = $shoot_cooldown

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= 0.5
	
	var direction = Input.get_axis("left", "right")
	if Input.is_action_pressed("left"):
		if sign(bullet_position.position.x) == 1:
			bullet_position.position.x *= -1
	if Input.is_action_pressed("right"):
		if sign(bullet_position.position.x) == -1:
			bullet_position.position.x *= -1
	if direction:
		velocity.x = lerp(velocity.x, speed * direction, run_speed_damping * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, speed * delta)
	
	move_and_slide()
	if velocity.x > 0:
		$Animacao_Gojo.play("walk_gojo")
	elif velocity.x < 0:
		$Animacao_Gojo.play("walk_gojo_inverted")
	
	elif Input.is_action_pressed("Lapse_Vermelho"):
		$Animacao_Gojo.play("Lapse_Vermelho")
	elif Input.is_action_pressed("Vazio_Roxo"):
		is_shooting = true
		$Animacao_Gojo.play("Vazio_Roxo")
		if shoot_cooldown.is_stopped():
			shoot_bullet()
		
		
	
	else:
		$Animacao_Gojo.stop()
		is_shooting = false
	
func shoot_bullet():
	var bullet_instance = BULLET_SCENE.instantiate()
	if sign(bullet_position.position.x) == 1:
		bullet_instance.set_direction(1)
	else:
		bullet_instance.set_direction(-1)
		
	add_sibling(bullet_instance)
	bullet_instance.global_position = bullet_position.global_position
	shoot_cooldown.start()
	
