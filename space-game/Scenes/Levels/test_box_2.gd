extends Node2D

# template for ui
@onready var ingame_ui = preload("res://Scenes/Menus/ingame_ui.tscn").instantiate()
@onready var ingame_ui_canvas = CanvasLayer.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(ingame_ui_canvas)
	ingame_ui_canvas.add_child(ingame_ui)
	
	ingame_ui.add_hazard(0, Vector2(490, 420), "FIRE")
	ingame_ui.add_hazard(1, Vector2(560, 160), "FIRE")
	

#	ingame_ui.remove_hazard(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
