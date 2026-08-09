extends Control
# init
@onready var hazard_texture = $Pivot/HazardTexture
@onready var hazard_sym_texture = $HazardSymTexture
@onready var hazard_pivot = $Pivot
var camera_zoom
var hazard_pos_world = Vector2.ZERO
var size_scale = Vector2.ZERO
var popped_in = false
var first = true

func _ready():
	camera_zoom = get_viewport().get_camera_2d().zoom
	popped_in = false
	scale = Vector2.ZERO
	first = true
	
func _process(delta: float) -> void:
	if hazard_pos_world == Vector2.ZERO:
		return
	if first == true:
		_scale_hazard_pt()
		pop_in()
		first = false
		popped_in = true
		return
	if popped_in == false:
		return
	var hazard_pos_screen = (hazard_pos_world - _get_camera_rect().position) * camera_zoom
		
	var on_screen = _get_camera_rect().has_point(hazard_pos_world)
		
	# if hazard on screen
	if on_screen:
		var float_above = 40
		global_position = hazard_pos_screen - Vector2(0,float_above)
		#size_scale = Vector2(1,1)
		if popped_in:
			scale = size_scale
		hazard_pivot.rotation = deg_to_rad(135)
		#hazard_texture.rotation = (PI * 3/4) 
	else:
		_set_screen_pos(hazard_pos_screen)
		_rotate_hazard_pt()
		#_scale_hazard_pt()
	_scale_hazard_pt()
	
func _get_camera_rect():
	var pos = get_viewport().get_camera_2d().get_screen_center_position()
	var screen_size = get_viewport_rect().size / camera_zoom
	return Rect2(pos - screen_size / 2, screen_size)

func _set_screen_pos(pos_screen):
	var screen_size = get_viewport_rect().size
	var screenPadding = 50
	var hazard_pos_onscreen = pos_screen
	
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
	var dir = (hazard_pos_world - curr_pos).normalized().angle()
	if dir >= 0:
		dir = dir + deg_to_rad(135)
	if dir < 0:
		dir = dir + deg_to_rad(45)
	hazard_pivot.rotation = dir

func _scale_hazard_pt():
	var on_screen = _get_camera_rect().has_point(hazard_pos_world)
	if on_screen:
		size_scale = Vector2(1,1)
	else:
		var max_dis = 1000
		var curr_pos = get_viewport().get_camera_2d().get_screen_center_position()
		var dis = curr_pos.distance_to(hazard_pos_world)
		dis = min(max_dis, dis)
		var percent = min(round((max_dis-dis)/max_dis * 100) / 100, 2)
		size_scale = Vector2(exp_scale(percent, 0.5, 2), exp_scale(percent, 0.5, 2))
	if popped_in:
		scale = size_scale
	
func exp_scale(x, min, max):
	return min * pow(max / min, x)
	
func set_hazard_texture(texture):
	hazard_texture.texture = texture

func set_hazard_sym_texture(texture):
	hazard_sym_texture.texture = texture
	
func set_hazard_position(world_position):
	hazard_pos_world = world_position
	
func pop_in():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_ease(Tween.EASE_OUT)
	await tween.tween_property(self, "scale", size_scale, 0.5)

func pop_out():
	popped_in = false
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "scale", Vector2.ZERO, 0.5)
	tween.tween_callback(queue_free)
