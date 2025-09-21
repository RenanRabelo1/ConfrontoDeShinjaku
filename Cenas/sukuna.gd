extends CharacterBody2D

@export var speed: float = 100.0
@export var jump_velocity: float = -350.0
var gravity: float = 980.0
var is_agachando = false
var is_attacking = false
@onready var progress_bar: ProgressBar = $ProgressBarSukuna
@onready var animacao = $Animacao_Sukuna
var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0

var DASH_SPEED = 300
var dashing = false
var can_dash = true

func _ready():
	var project_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
	if project_gravity:
		gravity = project_gravity

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if is_agachando == false && is_attacking == false:
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
		if dashing == true:
			velocity.x = direction * DASH_SPEED
		else:
			velocity.x = direction * speed
		if direction > 0:
			animacao.flip_h = false
		else:
			animacao.flip_h = true
	else:
		velocity.x = 0

func update_animation():
	if Input.is_action_just_pressed("AttackSukunaUp"):
		$Animacao_Sukuna.play("attack_sukuna")
		$AttackArea/AttackColisao.disabled = false
		is_attacking = true
		$Hitbox/ColisaoDeCima.disabled = false
	if Input.is_action_pressed("sukuna_agachar") && is_attacking == false:
			animacao.play("sukuna_agachando")
			$Hitbox/ColisaoDeCima.disabled = true
			is_agachando = true
	elif Input.is_action_just_released("sukuna_agachar") && is_attacking == false:
		$Hitbox/ColisaoDeCima.disabled = false
		is_agachando = false
	elif not is_on_floor():
		animacao.play("sukuna_jumping")
	elif abs(velocity.x) > 0 && is_agachando == false && is_attacking == false:
		animacao.play("sukuna_andando")
	else:
		if  is_agachando == false && is_attacking == false:
			animacao.play("idle")
	if Input.is_action_just_pressed("dash_sukuna_key") && can_dash == true:
		dashing = true
		$Animacao_Sukuna.play("dash_sukuna")
		$Timer_DS_can_dash.start()
		$Timer_DS.start()
		can_dash = false


func take_damage():
	progress_bar.value -= 1
	print("Dano tomado! Vida: ", progress_bar.value)

func _on_hitbox_area_entered(area: Area2D) -> void:
	take_damage()
	move_and_slide()

func _on_animacao_sukuna_animation_finished() -> void:
	if $Animacao_Sukuna.animation == "attack_sukuna":
		$AttackArea/AttackColisao.disabled = true
		is_attacking = false
func _on_timer_timeout() -> void:
	dashing = false
func _on_timer_ds_can_dash_timeout() -> void:
	can_dash = true
