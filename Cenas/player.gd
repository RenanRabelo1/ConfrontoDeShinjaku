extends CharacterBody2D

class_name Player

@export var speed: float = 100.0
@export var jump_velocity: float = -350.0
var gravity: float = 980.0
var is_attacking = false

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var animacao = $Animacao_Gojo
@onready var timer_attack = $Animacao_Gojo/TimerAttack


func _ready():
	var project_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
	if project_gravity:
		gravity = project_gravity
 

func _physics_process(delta):
	
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if not is_attacking:
		handle_movement()
	
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

func start_attack():	
	is_attacking = true
	$Animacao_Gojo/TimerAttack.start()
	$Animacao_Gojo/TimerColisaoAttack.start() # Mostra e ativa a área

func update_animation():
	if Input.is_action_just_pressed("AttackGojoUp"):
		$Animacao_Gojo.play("Attack_Cima_Gojo")
		$AttackArea/ColisionShape.disabled = false
		is_attacking = true
	if not is_on_floor() && is_attacking == false:
		animacao.play("jump_gojo")
	else:
		if abs(velocity.x) > 0 && is_attacking == false:
			animacao.play("walk_gojo")
		else:
			if is_attacking == false:
				animacao.play("battle_preparation_gojo")
  # Esconde e desativa a área


func _on_animacao_gojo_animation_finished() -> void:
	if $Animacao_Gojo.animation == "Attack_Cima_Gojo":
		$AttackArea/ColisionShape.disabled =  true
		is_attacking = false


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
