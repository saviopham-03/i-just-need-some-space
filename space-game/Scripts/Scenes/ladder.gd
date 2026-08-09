extends Area2D

func _on_body_entered(body: Node2D) -> void:
	
	if body.name == "CharacterBody2D":
		if body.has_method("set_on_ladder"):
			print("PLAYER ENTERED LADDER")
			body.set_on_ladder(true)

func _on_body_exited(body: Node2D) -> void:
	if body.name == "CharacterBody2D":
		if body.has_method("set_on_ladder"):
			body.set_on_ladder(false)
	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
