extends Control

@onready var ship_health_bar = $ShipHealthBar
@onready var hazard_pointer = $CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#await get_tree().create_timer(1).timeout
	#add_hazard(0, Vector2(140,420),"FIRE")
	#await get_tree().create_timer(2).timeout
	#add_hazard(1, Vector2(-200,-200),"FIRE")
	#add_hazard(2, Vector2(1260,300),"FIRE")
	#await get_tree().create_timer(3).timeout
	#remove_hazard(0)
	#remove_hazard(1)
	#remove_hazard(2)
	#ship_health_bar.add_ship_bar(0, "FIRE")
	#await get_tree().create_timer(1).timeout
	#ship_health_bar.add_ship_bar(1, "FIRE")
	#await get_tree().create_timer(3).timeout
	#ship_health_bar.remove_ship_bar(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_hazard(hazard_id, hazard_pos, hazard_type):
	hazard_pointer.add_hazard_pointer(hazard_id, hazard_pos,hazard_type)
	ship_health_bar.add_ship_bar(hazard_id, hazard_type)

func remove_hazard(hazard_id):
	hazard_pointer.remove_hazard_pointer(hazard_id)
	ship_health_bar.remove_ship_bar(hazard_id)
