extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Background/AnimatedSprite2D.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_start_btn_pressed() -> void:
	$MainMenu/click_start.play()
	SceneTransitions.change_scene("res://Scenes/Levels/TestBox.tscn")


func _on_options_btn_mouse_entered() -> void:
	$MainMenu/hover.play()
func _on_options_btn_pressed() -> void:
	$MainMenu/click.play()

func _on_exit_btn_mouse_entered() -> void:
	$MainMenu/hover.play()
func _on_exit_btn_pressed() -> void:
	$MainMenu/click.play()
