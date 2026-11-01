extends Area2D

@export var checkpoint_text: String = "Checkpoint saved!"
var activated: bool = false

func _on_body_entered(body: Node2D) -> void:
	if activated or body.name != "PLayer":
		return
	activated = true
	get_tree().current_scene.activate_checkpoint(body.global_position, checkpoint_text)