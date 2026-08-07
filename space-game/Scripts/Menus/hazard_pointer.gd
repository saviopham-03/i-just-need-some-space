extends Control
# init
@export var hazard_pos: Vector2
@onready var hazard_texture = $HazardTexture
const POINTER = preload("res://Assets/Menus/hazard_pointer.png")
var zoom = get_viewport().get_camera_2d().zoom

func _ready():
	zoom = get_viewport().get_camera_2d().zoom

func _process(delta: float) -> void:
	if hazard_pos == Vector2.ZERO:
		return
	else:
		hazard_texture.texture = POINTER
	var hazard_screen_pos = (hazard_pos - _get_viewport_rect().position) * zoom
	# if hazard on screen
	if _get_viewport_rect().has_point(hazard_pos):
		hazard_texture.rotation = 0
		global_position = hazard_screen_pos
	else:
		_set_screen_pos(hazard_screen_pos)
		_rotate_hazard_pt()

func _get_viewport_rect():
	var pos = get_viewport().get_camera_2d().get_screen_center_position()
	var screen_size = get_viewport_rect().size / zoom
	return Rect2(pos - screen_size / 2, screen_size)

func _set_screen_pos(hazard_screen_pos):
	var screen_size = get_viewport_rect().size
	var screenPadding = 50
	var hazard_pos_onscreen = hazard_screen_pos
	
	if hazard_pos_onscreen.x < screenPadding:
		hazard_pos_onscreen.x = screenPadding
	if hazard_pos_onscreen.x > screen_size.x - screenPadding:
		hazard_pos_onscreen.x = screen_size.x - screenPadding
	if hazard_pos_onscreen.y < screenPadding:
		hazard_pos_onscreen.y = screenPadding
	if hazard_pos_onscreen.y > screen_size.y - screenPadding:
		hazard_pos_onscreen.y = screen_size.y - screenPadding
		
	global_position = hazard_pos_onscreen
	
func _rotate_hazard_pt():
	var curr_pos = get_viewport().get_camera_2d().get_screen_center_position()
	var dir = (hazard_pos - curr_pos).normalized()
	hazard_texture.rotation = dir.angle()
	
	
	
