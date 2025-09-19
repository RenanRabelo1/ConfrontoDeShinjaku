extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_hollow_purple_finished() -> void:
	$HollowPurple.stop()
	$HollowPurple.hide()
	get_tree().change_scene_to_file("res://Cenas/cena_2.tscn")


func _on_inicial_finished() -> void:
	$Inicial.stop()
	$Inicial.hide()
	$HollowPurple/Timer_Purple.start()
	$HollowPurple/Aviso.start()


func _on_timer_purple_timeout() -> void:
	if Input.is_action_pressed("Vazio_Roxo"):
		$HollowPurple.play()
 	
