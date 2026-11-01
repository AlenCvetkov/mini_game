extends Area2D

var found: bool = false

func _on_body_entered(body: Node2D) -> void:
	if found or body.name != "PLayer":
		return
	found = true
	get_node("../SecretPlatform/Sprite2D").show()
	var hidden_coin := get_node("../SecretCoin") as Area2D
	hidden_coin.visible = true
	hidden_coin.monitoring = true
	get_tree().current_scene.show_secret_found()