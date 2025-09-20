extends CharacterBody2D

@export var speed: float = 100.0
@export var jump_velocity: float = -350.0
var gravity: float = 980.0
var is_attacking = false
var is_agachando = false

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var animacao = $Animacao_Sukuna
@onready var timer_attack = $TimerAttack

func _ready():
	var project_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
	if project_gravity:
		gravity = project_gravity

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if not is_attacking and not is_agachando:
		handle_movement()
	
	update_animation()
	move_and_slide()

func handle_movement():
	if Input.is_action_just_pressed("jump_sukuna") and is_on_floor():
		velocity.y = jump_velocity
	
	if Input.is_action_just_released("jump_sukuna") and velocity.y < 0:
		velocity.y *= 0.5
	
	var direction = Input.get_axis("left_sukuna", "right_sukuna")
	
	if direction != 0:
		velocity.x = direction * speed
		if direction > 0:
			animacao.flip_h = false
		else:
			animacao.flip_h = true
	else:
		velocity.x = 0

func start_attack():	
	is_attacking = true
	$TimerAttack.start()
	$TimerColisaoAttack.start()

func update_animation():
	# Agachar
	if Input.is_action_just_pressed("sukuna_agachar"):
		$Hitbox/ColisaoDeCima.disabled = true
		animacao.play("sukuna_agachando")
		is_agachando = true
		return
	
	if Input.is_action_just_released("sukuna_agachar"):
		$Hitbox/ColisaoDeCima.disabled = false
		is_agachando = false
	
	# Ataque
	if Input.is_action_just_pressed("AttackSukunaUp") and not is_agachando:
		animacao.play("Attack_Cima_Sukuna")
		$AttackArea/ColisionShape.disabled = false
		is_attacking = true
		return
	
	# Outras animações
	if not is_on_floor() && is_attacking == false && !is_agachando:
		animacao.play("sukuna_jumping")
	else:
		if abs(velocity.x) > 0 && is_attacking == false && !is_agachando:
			animacao.play("sukuna_andando")
		else:
			if is_attacking == false && !is_agachando:
				animacao.play("idle")

func take_damage():
	progress_bar.value -= 1
	print("Dano tomado! Vida: ", progress_bar.value)

func _on_animacao_sukuna_animation_finished() -> void:
	if animacao.animation == "Attack_Cima_Sukuna":
		$AttackArea/ColisionShape.disabled = true
		is_attacking = false
	elif animacao.animation == "sukuna_agachando":
		# Mantém agachado até soltar o botão
		pass

func _on_hitbox_area_entered(area: Area2D) -> void:
	take_damage()
	# CORREÇÃO: Passa a posição da área que causou o dano
	apply_knockback(area.global_position)

# Função de knockback corrigida
func apply_knockback(attacker_position: Vector2):
	var direction = (global_position - attacker_position).normalized()
	velocity = direction * 1000
	move_and_slide()
