extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ship_health = 100
	ship_health_max = 100
	await get_tree().process_frame

# init
@onready var health_bar = $ShipHealthBarContainer
@onready var health_head = $ShipHealthBarContainer/HealthHead
@onready var health_middle = $ShipHealthBarContainer/HealthMiddle
@onready var health_end = $ShipHealthBarContainer/HealthEnd
const FIRE_HAZARD_HEAD = preload("res://Assets/Menus/fire_head.png")
const FIRE_HAZARD_MIDDLE = preload("res://Assets/Menus/fire_middle.png")
const FIRE_HAZARD_END = preload("res://Assets/Menus/fire_end.png")

var max_health_on_texture
var ship_health
var ship_health_max
var additional_bars = {}

func _change_bar_size(texturerect, new_x, speed):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(texturerect, "custom_minimum_size:x", new_x, speed)

func _get_max_health_on_texture():
	await get_tree().process_frame
	return health_bar.size.x

func _set_ship_health(bar_id, value):
	
	var bar_to_set = additional_bars.get(bar_id)
	var new_bar_value = bar_to_set[1] + value
	additional_bars.get(bar_id)[1] = new_bar_value
	print(bar_to_set[1])
	var bar_middle = bar_to_set[3]
	_change_bar_size(bar_middle, await _scale_value_to_texture(new_bar_value), 0.5)
	print(await _scale_value_to_texture(new_bar_value))
	print(bar_middle.custom_minimum_size.x)
		
func add_ship_bar(bar_id, bar_type):
	var new_bar_head = TextureRect.new()
	var new_bar_middle = TextureRect.new()
	var new_bar_end = TextureRect.new()
	var new_bar_timer = Timer.new()
	var new_bar_value = 0
	var head_native_x = 0
	var end_native_x = 0
	
	new_bar_head.expand_mode = 1 # fit width proportional
	new_bar_head.stretch_mode = 6 # keep aspect covered
	new_bar_middle.expand_mode = 1 # ignore size
	new_bar_middle.stretch_mode = 0 # scale
	new_bar_end.expand_mode = 1 # fit width proportional
	new_bar_end.stretch_mode = 6
	
	new_bar_middle.pivot_offset.x = 0
	
	new_bar_head.texture = _get_bar_texture(bar_type + "_HEAD")
	head_native_x = _get_bar_texture(bar_type + "_HEAD").get_width()
	new_bar_middle.texture = _get_bar_texture(bar_type + "_MIDDLE")
	new_bar_end.texture = _get_bar_texture(bar_type + "_END")
	end_native_x =  _get_bar_texture(bar_type + "_END").get_width()
	
	new_bar_middle.custom_minimum_size.x = 0
	new_bar_head.custom_minimum_size.x = 0
	new_bar_end.custom_minimum_size.x = 0
	await _change_bar_size(new_bar_end,end_native_x, 0.3)
	_change_bar_size(new_bar_head,head_native_x, 0.3)
	
	
	health_bar.add_child(new_bar_head)
	health_bar.add_child(new_bar_middle)
	health_bar.add_child(new_bar_end)
	add_child(new_bar_timer)
	
	
	new_bar_timer.wait_time = 3
	
	new_bar_timer.timeout.connect(_on_bar_timer_timeout.bind(bar_id))
	
	additional_bars.set(bar_id, [bar_type, new_bar_value, new_bar_head, new_bar_middle, new_bar_end, new_bar_timer])
	_set_ship_health(bar_id, 0)
	new_bar_timer.start()
	new_bar_timer.start()

	
func _on_bar_timer_timeout(bar_id):
	print("TIMER OFF")
	_set_ship_health(bar_id, 1)
	
	
func _process_ship_health():
	pass
	
func remove_ship_bar(bar_id):
	var bar_to_remove = additional_bars.get(bar_id)
	bar_to_remove[5].stop()
	remove_child(bar_to_remove[5])
	health_bar.remove_child(bar_to_remove[2])
	health_bar.remove_child(bar_to_remove[3])
	health_bar.remove_child(bar_to_remove[4])
	additional_bars.erase(bar_id)

func _get_bar_texture(bar_type):
	match bar_type:
		"FIRE_HEAD":
			return FIRE_HAZARD_HEAD
		"FIRE_MIDDLE":
			return FIRE_HAZARD_MIDDLE
		"FIRE_END":
			return FIRE_HAZARD_END
		_:
			pass

func _scale_value_to_texture(value):
	return (await _get_max_health_on_texture() / 100) * value

func _scale_value_from_texture(value):
	return value * (100 / await _get_max_health_on_texture())


func _on_health_middle_resized() -> void:
	await get_tree().process_frame
	if health_middle.size.x <= 0:
		print("End")
		#health_head.visible = false
		#health_middle.visible = false
		#health_end.visible = false
		get_tree().paused = true
