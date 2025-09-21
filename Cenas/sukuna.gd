extends CharacterBody2D

@export var speed: float = 100.0
@export var jump_velocity: float = -350.0
var gravity: float = 980.0
var is_agachando = false

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var animacao = $Animacao_Sukuna

func _ready():
	var project_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
	if project_gravity:
		gravity = project_gravity

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if is_agachando == false:
		handle_movement()
	
	update_animation()
	move_and_slide()

func handle_movement():
	if Input.is_action_just_pressed("jump_sukuna") and is_on_floor():
		velocity.y = jump_velocity
	
	if Input.is_action_just_released("jump_sukuna") and velocity.y < 0:
		velocity.y *= 0.5
	
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction != 0:
		velocity.x = direction * speed
		if direction > 0:
			animacao.flip_h = false
		else:
			animacao.flip_h = true
	else:
		velocity.x = 0

func update_animation():
	if Input.is_action_pressed("sukuna_agachar"):
		if animacao.animation != "sukuna_agachando":
			animacao.play("sukuna_agachando")
			$Hitbox/ColisaoDeCima.disabled = true
			is_agachando = true
	elif Input.is_action_just_released("sukuna_agachar"):
		$Hitbox/ColisaoDeCima.disabled = false
		is_agachando = false
	elif not is_on_floor():
		if animacao.animation != "sukuna_jumping":
			animacao.play("sukuna_jumping")
	elif abs(velocity.x) > 0 and not is_agachando:
		if animacao.animation != "sukuna_andando":
			animacao.play("sukuna_andando")
	else:
		if animacao.animation != "idle":
			animacao.play("idle")


func take_damage():
	progress_bar.value -= 1
	print("Dano tomado! Vida: ", progress_bar.value)

func _on_hitbox_area_entered(area: Area2D) -> void:
	take_damage()
	apply_knockback(area.global_position)

func apply_knockback(attacker_position: Vector2):
	var direction = (global_position - attacker_position).normalized()
	velocity = direction * 1000
	move_and_slide()
