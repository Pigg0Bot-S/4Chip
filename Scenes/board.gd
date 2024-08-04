extends Node2D

@onready var coins = $"Coins"

class coin_grid:
	const null_row : Array = [null,null,null,null,null,null]
	@export var grid : Array[Array]
	
	func _init():
		grid = [null_row.duplicate(),
				null_row.duplicate(),
				null_row.duplicate(),
				null_row.duplicate(),
				null_row.duplicate(),
				null_row.duplicate()
		]
	
	func add_coin(color : bool):
		

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func reset():
	pass
