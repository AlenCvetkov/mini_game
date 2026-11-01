extends Area2D

func _ready() -> void:
	var tween := create_tween().set_loops()
	tween.tween_property($Sprite2D, "scale", Vector2(1.65, 1.65), 0.35)
	tween.tween_property($Sprite2D, "scale", Vector2(1.4, 1.4), 0.35)

func _process(delta: float) -> void:
	$Sprite2D.rotation += delta * 2.2

func _on_body_entered(body: Node2D) -> void:
	if body.name != "PLayer":
		return
	var game = get_tree().current_scene
	game.spawn_spark_effect(global_position, Color(1.0, 0.82, 0.12, 1.0))
	game.add_bonus_points(5)
	queue_free()