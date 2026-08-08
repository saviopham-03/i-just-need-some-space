extends Button


# Called when the node enters the scene tree for the first time.
@onready var sprite = $AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	sprite.animation_finished.connect(_on_animation_finished)

func _on_mouse_entered():
	sprite.play("transient")
	$"../hover".play()

func _on_mouse_exited():
	sprite.play("idle")

func _on_animation_finished():
	if sprite.animation == "transient":
		sprite.play("steady")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_main_menu_mouse_entered() -> void:
	pass # Replace with function body.
