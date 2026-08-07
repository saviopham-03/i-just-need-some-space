extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Background/AnimatedSprite2D.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/TestBox.tscn")
