extends Area2D

@export_enum("Left to Right", "Right to Left")
var activation_direction: String = "Left to Right"

@export var space_state: bool = true

func _on_body_entered(body: Node2D) -> void:
	if body.name == "CharacterBody2D":
		var correct_direction := false

		if activation_direction == "Left to Right":
			correct_direction = body.velocity.x > 0
		elif activation_direction == "Right to Left":
			correct_direction = body.velocity.x < 0

		if correct_direction:
			body.set_space_movement(space_state)
		else:
			body.set_space_movement(false)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
