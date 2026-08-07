extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -700.0

@onready var _animated_sprite = $AnimatedSprite2D

func _process(_delta):
	
	if velocity.y > 0:
		_animated_sprite.play("falling")
	if velocity.x != 0:
		if is_on_floor():
			_animated_sprite.play("walk")
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity == Vector2(0,0):
		_animated_sprite.play("idle")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		_animated_sprite.play("jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_animated_sprite_2d_animation_finished() -> void:
	if _animated_sprite.animation == "jump":
		_animated_sprite.play("idle")
		
