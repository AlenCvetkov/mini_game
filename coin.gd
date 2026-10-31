extends Area2D

# Дефинираме колку поени носи паричката
var score_value: int = 1


func _ready() -> void:
	# Ова автоматски ја пушта анимацијата за вртење штом ќе се појави паричката
	$AnimatedSprite2D.play("default")


func _on_body_entered(body: Node2D) -> void:
	if body.name == "PLayer":
		get_tree().current_scene.call("add_point")
		queue_free() # Ја брише паричката откако ќе ја собере
