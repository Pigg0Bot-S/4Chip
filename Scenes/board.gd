extends Node2D
class_name Board

enum CoinColor {NONE, RED ,BLUE}
enum Direction {HORIZONTAL, VERTICAL, DIAGONAL, DIAGONAL_DOWN}

@onready var coins = $"Coins"
var turn_color : CoinColor = CoinColor.RED
var won = false
var coin_scene : PackedScene = preload("res://Scenes/coin.tscn")
var columns : Array[Array] = [
	[],
	[],
	[],
	[],
	[],
	[],
	[]
]


const COLUMN_WIDTH : int = 158

func _process(_delta):
	if Input.is_action_just_pressed("Reset"): # Reset when 'r' pressed
		reset()

func _input(event):
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		handle_click(event.position)
		
	if event is InputEventMouseMotion:
		handle_motion(event.position)

## Gets the Color value for the CoinColor passed
func get_color_modulate(color : CoinColor):
	if color == CoinColor.RED:
		return Color(1,0,0,1)
	return Color(0,0,1,1)


## Returns a coin node and modulates it to appear as <color>
func get_coin_node(color : CoinColor) -> Sprite2D:
	var new_coin : Sprite2D = coin_scene.instantiate()
	new_coin.modulate = get_color_modulate(color)
	return new_coin

## Appends a coin to the column passed, and returns its coordinates.
func add_coin(color : CoinColor, column : int) -> Vector2i:
	var row = columns[column].size()
	if row == 6:
		return Vector2i(-1, -1)
	
	columns[column].append(color)
	
	
	var new_coin = get_coin_node(color)
	new_coin.position = Vector2(column,-row)*(COLUMN_WIDTH+19)+Vector2(98, 982)
	$Coins.add_child(new_coin)
	return Vector2i(column, row)

## Gets the color of the coin at pos
func get_coin(pos : Vector2i) -> CoinColor:
	if (not (pos.x in range(0,7) and pos.y in range(0,7))) or columns[pos.x].size() <= pos.y:
		return CoinColor.NONE
	
	return columns[pos.x][pos.y]

## Checks if a coin at pos is part of a winning streak
func check_coin_win(pos : Vector2i) -> bool:
	for i in range(0,4): # runs coin scan for each direction
		if coin_scan(pos, i):
			return true
		
	return false

## Checks for winning streak in direction at pos
func coin_scan(pos : Vector2i, direction : Direction) -> bool:
	var winning_color : CoinColor = get_coin(pos)
	var current_row : int = 0
	
	for i in range(-3, 4):
		var coin_color : CoinColor
		match direction:
			Direction.HORIZONTAL:
				coin_color = get_coin(Vector2i(pos.x+i,pos.y))
			Direction.VERTICAL:
				coin_color = get_coin(Vector2i(pos.x, pos.y+i))
			Direction.DIAGONAL:
				coin_color = get_coin(Vector2i(pos.x+i, pos.y+i))
			Direction.DIAGONAL_DOWN:
				coin_color = get_coin(Vector2i(pos.x+i,pos.y-i))
		
		if coin_color != winning_color:
			current_row = 0
			continue
		
		current_row += 1
		if current_row == 4:
			return true
			
	return false

## Alternates turn color
func switch_turn():
	if turn_color == CoinColor.RED:
		turn_color = CoinColor.BLUE
	else:
		turn_color = CoinColor.RED
	$Selector.modulate = get_color_modulate(turn_color)

## Resets the game
func reset():
	for coin in $Coins.get_children():
		coin.queue_free()
	for i in range(7):
		columns[i] = []
	
	if turn_color == CoinColor.BLUE:
		switch_turn()
	$Control/WinText.hide()
	won = false

## Locks game and shows win text
func win():
	won = true
	$Win.play()
	$Control/WinText.self_modulate = get_color_modulate(turn_color)
	$Control/WinText.show()

## Gets the column the mouse cursor is under
func get_column(pos : Vector2):
	var column_num : int = floor(pos.x/(COLUMN_WIDTH+19))
	if pos.x - (COLUMN_WIDTH+19)*column_num <= 19:
		return -1
	
	return column_num

## Handles click events and coin placements
func handle_click(pos : Vector2):
	var column = get_column(pos)
	if column == -1 or won:
		return
	
	var coin_pos : Vector2i = add_coin(turn_color, column)
	if coin_pos == Vector2i(-1, -1):
		$Error.play()
		return
	
	var did_win : bool = check_coin_win(coin_pos)
	if did_win:
		win()
		return
		
	$Place.play()
	switch_turn()

## Handles the selector based on mouse motion events
func handle_motion(pos : Vector2):
	var column = get_column(pos)
	if column == -1 or won:
		$Selector.hide()
		return
	$Selector.position = Vector2(column,0)*177+Vector2(98, 0)
	$Selector.show()
