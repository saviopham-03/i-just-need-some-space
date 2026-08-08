extends Control

@onready var ship_health_bar = $ShipHealthBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ship_health_bar.add_ship_bar(0, "FIRE")
	await get_tree().create_timer(1).timeout
	ship_health_bar.add_ship_bar(1, "FIRE")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var current_hazards = []
