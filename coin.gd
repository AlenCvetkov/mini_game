extends Area2D

var score_value: int = 1

func _ready() -> void:
	$AnimatedSprite2D.play("default")

func _on_body_entered(body: Node2D) -> void:
	if body.name == "PLayer":
		var game = get_tree().current_scene
		game.spawn_spark_effect($CollisionShape2D.global_position, Color(1.0, 0.82, 0.25, 1.0))
		game.add_point()
		queue_free()
