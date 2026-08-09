extends CanvasLayer
# init
const FIRE_SYM = preload("res://Assets/Menus/fire_indicator.png")
const FIRE_POINTER = preload("res://Assets/Menus/fire_indicator_pointer.png")
var hazard_pointer = preload("res://Scenes/Menus/hazard_pointer.tscn")
var hazards = {}
var camera_zoom

func _ready():
	pass
	
func add_hazard_pointer(pt_id, hazard_pos, pt_type):
	var new_hazard = hazard_pointer.instantiate()
	add_child(new_hazard)
	new_hazard.set_hazard_position(hazard_pos)
	new_hazard.set_hazard_texture(_get_hazard_texture(pt_type+"_POINTER"))
	new_hazard.set_hazard_sym_texture(_get_hazard_texture(pt_type+"_SYM"))
	hazards.set(pt_id, [pt_type, hazard_pos, new_hazard])

func _get_hazard_texture(pt_type):
	match pt_type:
		"FIRE_POINTER":
			return FIRE_POINTER
		"FIRE_SYM":
			return FIRE_SYM
		_:
			pass

func remove_hazard_pointer(pt_id):
	hazards.get(pt_id)[2].pop_out()
	hazards.erase(pt_id)
