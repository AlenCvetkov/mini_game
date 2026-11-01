extends Area2D

@export var speed: float = 95.0
@export var patrol_distance: float = 125.0

var direction: float = 1.0
var left_limit: float
var right_limit: float

func _ready() -> void:
	left_limit = position.x - patrol_distance
	right_limit = position.x + patrol_distance

func _physics_process(delta: float) -> void:
	position.x += speed * direction * delta
	if position.x >= right_limit:
		position.x = right_limit
		direction = -1.0
	elif position.x <= left_limit:
		position.x = left_limit
		direction = 1.0

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage()