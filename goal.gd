extends Area2D

@export var open_texture: Texture2D

func _on_body_entered(body: Node2D) -> void:
	if body.name != "PLayer":
		return
	var game = get_tree().current_scene
	if game.score < game.TOTAL_COINS:
		game.show_need_coins()
		return
	$Sprite2D.texture = open_texture
	game.complete_level()