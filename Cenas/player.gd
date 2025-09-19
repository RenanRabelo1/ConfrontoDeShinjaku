
extends CharacterBody2D

class_name Player

@export var speed: float = 100.0
@export var jump_velocity: float = -350.0
var gravity: float = 980.0
var is_attacking: bool = false

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var animacao = $Animacao_Gojo
@onready var timer_attack = $Animacao_Gojo/TimerAttack
@onready var attack_area_cima = $AttackAreaCima
@onready var timer_colisao_attack = $Animacao_Gojo/TimerColisaoAttack

func _ready():
	# Garantir que gravity tem um valor
	var project_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
	if project_gravity:
		gravity = project_gravity
	
	# Conectar os sinais dos timers
	timer_attack.timeout.connect(_on_timer_attack_timeout)
	timer_colisao_attack.timeout.connect(_on_timer_colisao_attack_timeout)
	
	# Garantir que a área de ataque começa desativada
	attack_area_cima.monitoring = false

func _physics_process(delta):
	# Aplicar gravidade
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Só permite movimento se não estiver atacando
	if not is_attacking:
		handle_movement()
	
	handle_attacks()
	
	update_animation()
	move_and_slide()

func handle_movement():
	# Pular
	if Input.is_action_just_pressed("jump_gojo") and is_on_floor():
		velocity.y = jump_velocity
	
	# Pulo mais curto se soltar o botão
	if Input.is_action_just_released("jump_gojo") and velocity.y < 0:
		velocity.y *= 0.5
	
	# Movimento horizontal simples
	var direction = Input.get_axis("left_gojo", "right_gojo")
	
	if direction != 0:
		velocity.x = direction * speed
		# Virar o personagem na direção do movimento
		if direction > 0:
			animacao.flip_h = false
		else:
			animacao.flip_h = true
	else:
		velocity.x = 0

func handle_attacks():
	if Input.is_action_just_pressed("Attack_Cima_Gojo") and not is_attacking:
		is_attacking = true
		timer_attack.start()
		timer_colisao_attack.start()
		
	if Input.is_action_just_pressed("Rasteira_Gojo") and not is_attacking:
		is_attacking = true
		timer_attack.start()

func update_animation():
	if is_attacking:
		animacao.play("Attack_Cima_Gojo")
	elif not is_on_floor():
		animacao.play("jump_gojo")
	else:
		if abs(velocity.x) > 0:
			animacao.play("walk_gojo")
		else:
			animacao.play("battle_preparation_gojo")

func _on_timer_attack_timeout():
	is_attacking = false
	attack_area_cima.monitoring = false

func _on_timer_colisao_attack_timeout():
	attack_area_cima.monitoring = true

func take_damage():
	if progress_bar:
		progress_bar.value -= 1
		print("Dano tomado! Vida: ", progress_bar.value)
