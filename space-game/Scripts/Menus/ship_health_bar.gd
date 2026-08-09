extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# init
@onready var ship_damage_timer = $ShipDamageTimer
@onready var ship_damage_bar = $ShipDamageBar
@onready var health_bar = $ShipHealthBarContainer
const FIRE_HAZARD_HEAD = preload("res://Assets/Menus/fire_head.png")
const FIRE_HAZARD_MIDDLE = preload("res://Assets/Menus/fire_middle.png")
const FIRE_HAZARD_END = preload("res://Assets/Menus/fire_end.png")

var max_health = health_bar.size.x
var ship_health = 100 : set = _set_ship_health

func _set_ship_health(healthid, value):

	var old_ship_health = ship_health
	ship_health = new_ship_health
	value = ship_health
	
	if ship_health <= 0:
		pass # trigger game over
	
	if ship_health < old_ship_health:
		ship_damage_timer.start()
	else:
		ship_damage_bar.value = ship_health


func _on_ship_damage_timer_timeout() -> void:
	ship_damage_bar.value = ship_health
