extends Node2D

var score: int = 0
const TOTAL_COINS: int = 20
var level_finished: bool = false
var is_game_over: bool = false

@onready var label: Label = $CanvasLayer/Label
@onready var lives_label: Label = $CanvasLayer/LivesLabel
@onready var message_label: Label = $CanvasLayer/MessageLabel

func _ready() -> void:
	_update_score()
	update_lives(3)

func add_point() -> void:
	if score >= TOTAL_COINS:
		return
	score += 1
	_update_score()
	if score == TOTAL_COINS:
		print("You collected all 20 coins!")

func _update_score() -> void:
	if is_instance_valid(label):
		label.text = "Coins: %d / %d" % [score, TOTAL_COINS]

func update_lives(lives: int) -> void:
	if is_instance_valid(lives_label):
		lives_label.text = "Lives: " + "♥".repeat(maxi(lives, 0))

func show_need_coins() -> void:
	message_label.text = "Find all 20 coins first!"
	message_label.show()
	await get_tree().create_timer(2.0).timeout
	if not level_finished and not is_game_over:
		message_label.hide()

func complete_level() -> void:
	level_finished = true
	message_label.text = "LEVEL COMPLETE!"
	message_label.show()

func game_over() -> void:
	is_game_over = true
	message_label.text = "GAME OVER"
	message_label.show()