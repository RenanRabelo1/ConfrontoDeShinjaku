extends CharacterBody2D

class_name Player

@export var speed = 100
@export var jump_velocity = -350
@export var acceleration = 5.0
@export var friction = 10.0
var gravity = 980
var is_attacking: bool = false

func _ready():
	# Garantir que gravity tem um valor
	var project_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
	if project_gravity:
		gravity = project_gravity

func _physics_process(delta: float) -> void:
	# Aplicar gravidade
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Só permite movimento se não estiver atacando
	if not is_attacking:
		# Pular
		if Input.is_action_just_pressed("jump_gojo") and is_on_floor():
			velocity.y = jump_velocity
		
		# Pulo mais curto se soltar o botão
		if Input.is_action_just_released("jump_gojo") and velocity.y < 0:
			velocity.y *= 0.5
		
		# Movimento horizontal suave
		var direction = Input.get_axis("left_gojo", "right_gojo")
		
		if direction != 0:
			velocity.x = move_toward(velocity.x, direction * speed, acceleration)
		else:
			velocity.x = move_toward(velocity.x, 0, friction)
	
	# Ataque
	if Input.is_action_just_pressed("Attack_Cima_Gojo"):
		is_attacking = true
		$Animacao_Gojo.play("Attack_Cima_Gojo")
		$TimerAttack.start()
	
	update_animation()
	
	move_and_slide()

func update_animation():
	if is_attacking:
		$AnimationPlayer.play("Attack")
		
	elif not is_on_floor():
		$Animacao_Gojo.play("jump_gojo")
	else:
		if velocity.x > 0:
			$Animacao_Gojo.play("walk_gojo")
		elif velocity.x < 0:
			$Animacao_Gojo.play("walk_gojo_inverted")
		else:
			$Animacao_Gojo.play("battle_preparation_gojo")

@onready var progress_bar: ProgressBar = $ProgressBar

func take_damage():
	if progress_bar:
		progress_bar.value -= 1
		print("Dano tomado! Vida: ", progress_bar.value)


func _on_timer_attack_timeout() -> void:
	$Animacao_Gojo.stop()
	is_attacking = false
