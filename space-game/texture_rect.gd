extends TextureRect

@onready var tr = $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	tr.pivot_offset = tr.get_size() / 2
	print(tr.pivot_offset)
	#tr.pivot_offset = tr.size / 2
	tr.rotation_degrees = 135


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
