extends Control

func open_menu() -> void:
	var game = get_tree().current_scene
	$Level2Button.disabled = game.unlocked_level < 2
	$Level2Button.text = "Level 2" if game.unlocked_level >= 2 else "Level 2 (Locked)"
	visible = true
	get_node("../PauseMenu").visible = false

func _on_level1_pressed() -> void:
	_load_level("res://game.tscn")

func _on_level2_pressed() -> void:
	if get_tree().current_scene.unlocked_level >= 2:
		_load_level("res://level_2.tscn")

func _on_back_pressed() -> void:
	visible = false
	get_node("../PauseMenu").visible = true

func _load_level(path: String) -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(path)