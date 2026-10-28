extends Node2D

var score: int = 0
const TOTAL_COINS = 5

# Тука дефинираме променлива со точно исто име што го користиме долу
@onready var label: Label = $Label

func _ready() -> void:
	if label:
		label.text = "Score: " + str(score) + " / " + str(TOTAL_COINS)

func add_point() -> void:
	score += 1
	if label:
		label.text = "Score: " + str(score) + " / " + str(TOTAL_COINS)
	
	if score >= TOTAL_COINS:
		print("Победа! Ги собравте сите парички!")
