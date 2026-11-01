extends AnimatableBody2D

@export var travel_distance: float = 32.0
@export var cycle_speed: float = 1.25

var start_y: float
var phase: float = 0.0

func _ready() -> void:
	start_y = position.y

func _physics_process(delta: float) -> void:
	phase += delta * cycle_speed
	position.y = start_y + sin(phase) * travel_distance