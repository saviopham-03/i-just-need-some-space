extends TileMap


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_ladder()
	
	pass # Replace with function body.
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


var ladder_height1: float = 320

var ladder_height2: float = 576
@onready var spriteLadder1: Sprite2D = $LadderLower/Sprite2D
@onready var collisionLadder1: CollisionShape2D = $LadderLower/CollisionShape2D
@onready var spriteLadder2: Sprite2D = $LadderUpper/Sprite2D
@onready var collisionLadder2: CollisionShape2D = $LadderUpper/CollisionShape2D
func update_ladder():
	spriteLadder1.region_rect.size.y = ladder_height1
	spriteLadder2.region_rect.size.y = ladder_height2
	# Move sprite so its bottom stays at the origin
	spriteLadder1.position.y = -ladder_height1 / 2.0
	spriteLadder2.position.y = -ladder_height2 / 2.0

	var shape1 = collisionLadder1.shape as RectangleShape2D
	shape1.size.y = ladder_height1
	
	var shape2 = collisionLadder2.shape as RectangleShape2D
	shape2.size.y = ladder_height2
	
	# Same for collision
	collisionLadder1.position.y = -ladder_height1 / 2.0
	collisionLadder2.position.y = -ladder_height2 / 2.0
