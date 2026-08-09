extends Control
# init
#@onready var hazard_texture = $HazardTexture
const FIRE_SYM = preload("res://Assets/Menus/fire_indicator.png")
const FIRE_POINTER = preload("res://Assets/Menus/fire_indicator_pointer.png")
@onready var zoom = get_viewport().get_camera_2d().zoom
var hazards = {}

func _ready():
	zoom = get_viewport().get_camera_2d().zoom
	
func add_hazard_pointer(pt_id, hazard_pos, pt_type):
	var new_hazard_sym = TextureRect.new()
	var new_hazard_pt = TextureRect.new()
	new_hazard_pt.texture = _get_hazard_texture(pt_type+"_POINTER")
	new_hazard_sym.texture = _get_hazard_texture(pt_type+"_SYM")
	new_hazard_pt.scale = Vector2(0.1, 0.1)
	new_hazard_sym.scale = Vector2(0.1, 0.1)
	
	new_hazard_pt.pivot_offset = _get_hazard_texture(pt_type+"_POINTER").get_size() / 2
	new_hazard_sym.pivot_offset = _get_hazard_texture(pt_type+"_SYM").get_size() / 2
	print(new_hazard_pt.pivot_offset)
	#var new_hazard_pt2 = TextureRect.new()
	#new_hazard_pt2.texture = _get_hazard_texture(pt_type+"_POINTER")
	#new_hazard_pt2.scale = Vector2(0.1, 0.1)
	
	#new_hazard_pt2.pivot_offset = new_hazard_pt.size / 2
	#add_child(new_hazard_pt2)
	
	hazards.set(pt_id, [pt_type, hazard_pos, new_hazard_pt, new_hazard_sym])
	add_child(new_hazard_pt)
	add_child(new_hazard_sym)
	
	

func _get_hazard_texture(pt_type):
	match pt_type:
		"FIRE_POINTER":
			return FIRE_POINTER
		"FIRE_SYM":
			return FIRE_SYM
		_:
			pass

func remove_hazard_pointer(pt_id):
	var hazard_pt = hazards.get(pt_id)[2]
	var hazard_sym = hazards.get(pt_id)[3]
	hazards.erase(pt_id)
	remove_child(hazard_pt)
	remove_child(hazard_sym)
	
func world_to_screen(world_pos: Vector2) -> Vector2:
	var cam := get_viewport().get_camera_2d()
	if cam == null:
		return Vector2.ZERO

	# Transform world -> canvas -> screen
	var canvas_transform := get_viewport().get_canvas_transform()
	return canvas_transform * world_pos


func _process(delta: float) -> void:
	var camera := get_viewport().get_camera_2d()
	if camera == null:
		return
	var viewport_rect = _get_viewport_rect()
	var center_viewport = viewport_rect.position + viewport_rect.size / 2
	#var rect := get_viewport_rect()
	#var camera_center = rect.position + rect.size / 2
	
	for pt_id in hazards.keys():
		var curr_hazard = hazards[pt_id]
		var hazard_pos_world = curr_hazard[1]
		if hazard_pos_world == Vector2.ZERO:
			pass
		#var camera := get_viewport().get_camera_2d()
		#var zoom := camera.zoom
		#var hazard_screen = (hazard_pos_world - _get_viewport_rect().position) * zoom
		var pt = curr_hazard[2]
		var sym = curr_hazard[3]
		var hazard_screen = center_viewport + (hazard_pos_world - camera.global_position) * camera.zoom
		var on_screen = viewport_rect.has_point(hazard_screen)
		
		#var local_pos = hazard_screen - rect.position
		# if hazard on screen
		if on_screen:
			var local_pos = hazard_screen - viewport_rect.position
			pt.position = local_pos - pt.size / 2 * pt.scale
			sym.position = local_pos - sym.size / 2 * sym.scale
		else:
			#var clamping = hazard_screen # clamp to edge
			#var padding = 50
			#clamping.x = clamp(clamping.x, rect.position.x + padding, rect.position.x + rect.size.x - padding)
			#clamping.y = clamp(clamping.y, rect.position.y + padding, rect.position.y + rect.size.y - padding)
			#var clamping_local = clamping - rect.position
			#pt.position = clamping_local - pt.size / 2 * pt.scale
			#sym.position = clamping_local - sym.size / 2 * pt.scale
		#var screen_center = camera.unprojected_position(camera.get_screen_center_position())
		#var center = get_viewport_rect().get_center() + get_viewport_rect().position
			#var screen_center = rect.position + rect.size / 2
			var dir = (hazard_screen - center_viewport)
			if dir.length_squared() == 0:
				continue
			dir = dir.normalized()
			
			var t_min = INF
			# left
			if dir.x != 0:
				var t = (viewport_rect.position.x - center_viewport.x) / dir.x
				var y = center_viewport.y + dir.y * t
				if t > 0 and y >= viewport_rect.position.y and y <= viewport_rect.position.y + viewport_rect.size.y:
					t_min = min(t_min, t)
				# right
				t = (viewport_rect.position.x + viewport_rect.size.x - center_viewport.x) / dir.x
				y = center_viewport.y + dir.y * t
				if t > 0 and y >= viewport_rect.position.y and y <= viewport_rect.position.y + viewport_rect.size.y:
					t_min = min(t_min, t)
			# top
			if dir.y != 0:
				var t = (viewport_rect.position.y - center_viewport.y) / dir.y
				var x = center_viewport.x + dir.x * t
				if t > 0 and x >= viewport_rect.position.x and x <= viewport_rect.position.x + viewport_rect.size.x:
					t_min = min(t_min, t)
				# bottom
				t = (viewport_rect.position.y + viewport_rect.size.y - center_viewport.y) / dir.y
				x = center_viewport.x + dir.x * t
				if t > 0 and x >= viewport_rect.position.x and x <= viewport_rect.position.x + viewport_rect.size.x:
					t_min = min(t_min, t)
			if t_min == INF:
				continue # if failed, just center it
			var edge_point = center_viewport + dir * t_min
			var padding = 50
			var inset_point = edge_point - dir * padding
			var local_pos = inset_point - viewport_rect.position
			pt.position = local_pos - pt.size / 2 * pt.scale
			sym.position = local_pos - sym.size / 2 * sym.scale
			
		if on_screen:
			pt.rotation =  (PI * 3.0 / 4.0)
		else:
			var center_to_hazard = hazard_screen - center_viewport
			var dir_angle = center_to_hazard.angle()
			pt.rotation = dir_angle + (PI * 3.0 / 4.0)
func _get_viewport_rect() -> Rect2:
	# Use viewport dimensions in pixels; Control local is also based on those.
	# Zoom is handled by the world->viewport conversion above.
	return Rect2(Vector2.ZERO, get_viewport_rect().size)
	
func __get_viewport_rect():
	var pos = get_viewport().get_camera_2d().get_screen_center_position()
	var screen_size = get_viewport_rect().size / zoom
	return Rect2(pos - screen_size / 2, screen_size)

func _set_screen_pos(pt_id, hazard_screen_pos):
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
		
	hazards[pt_id][2].global_position = hazard_pos_onscreen
	hazards[pt_id][3].global_position = hazard_pos_onscreen
	
func _rotate_hazard_pt(curr_hazard_pt, curr_hazard_pos):
	var curr_pos = get_viewport().get_camera_2d().get_screen_center_position()
	var dir = (curr_hazard_pos - curr_pos).normalized()
	hazards[curr_hazard_pt][2].rotation = dir.angle() + (PI * 3/4)
	
	
	
