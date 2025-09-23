extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("cutscene_gojo") || Input.is_action_just_pressed("cutscene_sukuna"):
		progress_bar()


func progress_bar():
	if $sukuna/ProgressBarSukuna.value <= 90.0:
		$Mahoragaaa.play()
	if $Player/ProgressBarGojo.value <= 90.0:
		pass
	
