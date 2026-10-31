extends Node2D

var score: int = 0
const TOTAL_COINS: int = 20

@onready var label: Label = $CanvasLayer/Label

func _ready() -> void:
	_update_score()

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
