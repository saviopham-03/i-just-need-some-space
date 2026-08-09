extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -550.0
const CLIMB_SPEED = 150.0

const SPACE_ACCELERATION = 400.0
const SPACE_MAX_SPEED = 250.0
const SPACE_DRAG = 50.0

var in_gravity: bool = true
var is_on_ladder: bool = false
var is_in_space: bool = false
var is_dead: bool = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
	

func get_obstacle() -> void:
	var tilemap: TileMapLayer = get_tree().get_first_node_in_group("tilemap")
	if not tilemap:
		return
	var cell = tilemap.local_to_map(tilemap.to_local(global_position))
	var data: TileData = tilemap.get_cell_tile_data(cell)
	
	if data:
		var obby: int = data.get_custom_data("obstacle")
		if obby==2: #ladder
			set_on_ladder(true)
		if obby==3: #exit space
			set_space_movement(false)
		if obby==4: #enter space
			set_space_movement(true)
		if obby==5: #dead
			print("you died")
	else:
		set_on_ladder(false)
	return

func _process(_delta: float) -> void:
	get_obstacle()
		
	if is_on_ladder:
		animated_sprite.play("idle")
		return
	if velocity.y > 0:
		animated_sprite.play("falling")
	if velocity.x != 0:
		if is_on_floor():
			animated_sprite.play("walk")
		animated_sprite.flip_h = velocity.x < 0
	else:
		animated_sprite.play("idle")


func _physics_process(delta: float) -> void:
	
	if is_on_ladder:
		handle_ladder_movement()
		move_and_slide()
		return
	
	if is_in_space:
		print("SPACE MOVEMENT ACTIVE")
		handle_space_movement(delta)
		move_and_slide()
		return

	if in_gravity:
		if not is_on_floor():
			velocity += get_gravity() * delta

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animated_sprite.play("jump")

	# Horizontal movement
	var direction := Input.get_axis("ui_left", "ui_right")

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func handle_ladder_movement() -> void:
	var horizontal_dir := Input.get_axis("ui_left", "ui_right")
	velocity.x = horizontal_dir * (SPEED * 0.5)

	var vertical_dir := Input.get_axis("ui_up", "ui_down")

	if vertical_dir:
		velocity.y = vertical_dir * CLIMB_SPEED
	else:
		velocity.y = 0

	if Input.is_action_just_pressed("ui_accept"):
		is_on_ladder = false
		velocity.y = JUMP_VELOCITY


func set_on_ladder(value: bool) -> void:
	is_on_ladder = value

func handle_space_movement(delta: float) -> void:
	var horizontal_dir := Input.get_axis("ui_left", "ui_right")
	var vertical_dir := Input.get_axis("ui_up", "ui_down")

	# Accelerate horizontally
	if horizontal_dir != 0:
		velocity.x += horizontal_dir * SPACE_ACCELERATION * delta
	else:
		velocity.x = move_toward(velocity.x, 0, SPACE_DRAG * delta)

	# Accelerate vertically
	if vertical_dir != 0:
		velocity.y += vertical_dir * SPACE_ACCELERATION * delta
	else:
		velocity.y = move_toward(velocity.y, 0, SPACE_DRAG * delta)

	# Limit maximum speed
	velocity.x = clamp(velocity.x, -SPACE_MAX_SPEED, SPACE_MAX_SPEED)
	velocity.y = clamp(velocity.y, -SPACE_MAX_SPEED, SPACE_MAX_SPEED)

func set_space_movement(value:bool) -> void:
	is_in_space = value

func has_died(spawnx_coord:int, spawny_coord:int) -> void:
	position.x = spawnx_coord
	position.y = spawny_coord



func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "jump":
		animated_sprite.play("idle")
