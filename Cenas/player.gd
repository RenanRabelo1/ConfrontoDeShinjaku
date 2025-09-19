extends CharacterBody2D

class_name Player

@export var speed: float = 100.0
@export var jump_velocity: float = -350.0
var gravity: float = 980.0
var is_attacking: bool = false
var can_damage: bool = true
var attack_cooldown: float = 0.0  # Timer manual para cooldown

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var animacao = $Animacao_Gojo
@onready var timer_attack = $Animacao_Gojo/TimerAttack
@onready var attack_area_cima = $AttackAreaCima
@onready var timer_colisao_attack = $Animacao_Gojo/TimerColisaoAttack

func _ready():
	var project_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
	if project_gravity:
		gravity = project_gravity
	
	timer_attack.timeout.connect(_on_timer_attack_timeout)
	timer_colisao_attack.timeout.connect(_on_timer_colisao_attack_timeout)
	
	attack_area_cima.body_entered.connect(_on_attack_area_body_entered)
	attack_area_cima.monitoring = false

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Atualizar cooldown do ataque
	if attack_cooldown > 0:
		attack_cooldown -= delta
	
	if not is_attacking:
		handle_movement()
	
	handle_attacks()
	update_animation()
	move_and_slide()

func handle_movement():
	if Input.is_action_just_pressed("jump_gojo") and is_on_floor():
		velocity.y = jump_velocity
	
	if Input.is_action_just_released("jump_gojo") and velocity.y < 0:
		velocity.y *= 0.5
	
	var direction = Input.get_axis("left_gojo", "right_gojo")
	
	if direction != 0:
		velocity.x = direction * speed
		if direction > 0:
			animacao.flip_h = false
		else:
			animacao.flip_h = true
	else:
		velocity.x = 0

func handle_attacks():
	if Input.is_action_just_pressed("Attack_Cima_Gojo") and not is_attacking and attack_cooldown <= 0:
		is_attacking = true
		can_damage = true
		timer_attack.start()
		timer_colisao_attack.start()
		
	if Input.is_action_just_pressed("Rasteira_Gojo") and not is_attacking and attack_cooldown <= 0:
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
	attack_cooldown = 0.5  # 0.5 segundos de cooldown entre ataques

func _on_timer_colisao_attack_timeout():
	attack_area_cima.monitoring = true
	# Usar um timer mais confiável
	var timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.wait_time = 0.1
	timer.timeout.connect(_disable_attack_area.bind(timer))
	timer.start()

func _disable_attack_area(timer: Timer):
	attack_area_cima.monitoring = false
	timer.queue_free()

func _on_attack_area_body_entered(body):
	if can_damage and body.has_method("take_damage") and body != self:
		body.take_damage()
		can_damage = false  # Só causa dano uma vez por ataque

func take_damage():
	if progress_bar:
		progress_bar.value -= 1
		print("Dano tomado! Vida: ", progress_bar.value)
