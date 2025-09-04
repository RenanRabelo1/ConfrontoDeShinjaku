extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AudioStreamPlayer2D.play()
	$Button.hide()




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _on_button_pressed() -> void: 
	$VideoStreamPlayer2.play()# Replace with function body.
	$TimerAcabarvideo1.start()
	$Button.visible = false
	$Button.disabled = true

func _on_timer_timeout() -> void:
	$VideoStreamPlayer2.stop()

func _on_timer_inicial_button_timeout() -> void:
	$Button.show()
