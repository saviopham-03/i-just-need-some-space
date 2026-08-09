extends Node2D
var spawn_x: int = 50
var spawn_y: int = -105
@onready var player: Node2D = $CharacterBody2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.global_position.y > 300:
		print("PLAYER FELL")
		player.has_died(spawn_x,spawn_y)
	pass
