extends CharacterBody2D

class_name Player

@export var speed: float = 100.0
@export var jump_velocity: float = -350.0
var gravity: float = 980.0
var is_attacking = false
var is_agachando = false

@onready var progress_bar: ProgressBar = $ProgressBarGojo
@onready var animacao = $Animacao_Gojo
@onready var timer_attack = $Animacao_Gojo/TimerAttack

var dashing = false
var DASH_SPEED = 500
var can_dash = true
func _ready():
	var project_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
	if project_gravity:
		gravity = project_gravity
 





func _physics_process(delta):

	if not is_on_floor():
		velocity.y += gravity * delta
	
	if is_attacking == false && is_agachando == false:
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
		if dashing ==  true:
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
	var direction = Input.get_axis("left_gojo", "right_gojo")
	if Input.is_action_just_pressed("AttackGojoUp"):
		$Animacao_Gojo.play("Attack_Cima_Gojo")
		if direction > 0:
			$AttackArea/ColisionShape.disabled = false
		if direction < 0:
				$AttackArea/ColisionShape2.disabled = false
		is_attacking = true
		$Hitbox/colisao_cima.disabled = false
	if Input.is_action_pressed("gojo_agachando") && is_attacking == false:
		$Animacao_Gojo.play("gojo_agachando")
		is_agachando = true
		$Hitbox/colisao_cima.disabled = true
	elif Input.is_action_just_released("gojo_agachando") && is_attacking == false:
		$Hitbox/colisao_cima.disabled = false
		is_agachando = false
	elif not is_on_floor():
		animacao.play("jump_gojo")
	else:
		if abs(velocity.x) > 0 && is_attacking == false && is_agachando == false:
			animacao.play("walk_gojo")
		else:
			if is_attacking == false && is_agachando == false:
				animacao.play("battle_preparation_gojo")
	if Input.is_action_just_pressed("dash_gojo_key") && can_dash == true:
		$Animacao_Gojo.play("dash_gojo")
		dashing = true
		$Timer_DG.start()
		$Timer_DG_can_dash.start()
		can_dash = false
  


func _on_animacao_gojo_animation_finished() -> void:
	if $Animacao_Gojo.animation == "Attack_Cima_Gojo":
		$AttackArea/ColisionShape.disabled =  true
		$AttackArea/ColisionShape2.disabled = true
		is_attacking = false


func take_damage():
	progress_bar.value -= 1
	print("Dano tomado! Vida: ", progress_bar.value)

func _on_hitbox_area_entered(area: Area2D) -> void:
	take_damage()
	move_and_slide()
func _on_timer_dg_timeout() -> void:
	dashing = false
func _on_timer_dg_can_dash_timeout() -> void:
	can_dash = true
