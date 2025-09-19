extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Button.hide()




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _on_button_pressed() -> void: 
	$LapseVermelho.play() # Replace with function body.
	$Button.visible = false
	$Button.disabled = true



func _on_timer_inicial_button_timeout() -> void:
	$Button.show()


func _on_video_stream_player_2_finished() -> void:
	$LapseVermelho.stop() # Replace with function body.
