extends TextureProgressBar

# init
@onready var ship_damage_timer = $ShipDamageTimer
@onready var ship_damage_bar = $ShipDamageBar
var ship_health = 0 : set = _set_ship_health

func _set_ship_health(new_ship_health):
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
