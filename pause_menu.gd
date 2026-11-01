extends Control

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and not event.is_echo():
		if get_tree().current_scene.level_finished or get_tree().current_scene.is_game_over:
			return
		set_paused(not get_tree().paused)

func set_paused(value: bool) -> void:
	get_tree().paused = value
	visible = value

func _on_resume_pressed() -> void:
	set_paused(false)

func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_levels_pressed() -> void:
	get_node("../LevelSelectPanel").open_menu()

func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().quit()