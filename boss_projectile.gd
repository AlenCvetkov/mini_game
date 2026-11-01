extends Area2D

@export var speed: float = 390.0
var direction: Vector2 = Vector2.LEFT

func set_target(target_position: Vector2) -> void:
	direction = (target_position - global_position).normalized()

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta
	if global_position.x < 0.0 or global_position.x > 8000.0 or global_position.y > 900.0:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage()
	queue_free()