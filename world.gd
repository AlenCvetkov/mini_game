extends Node2D

@export var level_number: int = 1
@export_file("*.tscn") var next_level_path: String = ""

var score: int = 0
var bonus_points: int = 0
const TOTAL_COINS: int = 20
var level_finished: bool = false
var is_game_over: bool = false
var boss_defeated: bool = false
var checkpoint_position: Vector2 = Vector2.ZERO
var elapsed_time: float = 0.0
var best_time: float = 0.0
var unlocked_level: int = 1

@onready var label: Label = $CanvasLayer/Label
@onready var lives_label: Label = $CanvasLayer/LivesLabel
@onready var bonus_label: Label = $CanvasLayer/BonusLabel
@onready var time_label: Label = $CanvasLayer/TimeLabel
@onready var record_label: Label = $CanvasLayer/RecordLabel
@onready var level_label: Label = $CanvasLayer/LevelLabel
@onready var boss_label: Label = $CanvasLayer/BossLabel
@onready var message_label: Label = $CanvasLayer/MessageLabel
@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var completion_panel: Control = $CanvasLayer/CompletionPanel
@onready var completion_title: Label = $CanvasLayer/CompletionPanel/CompletionTitle
@onready var next_level_button: Button = $CanvasLayer/CompletionPanel/NextLevelButton

func _ready() -> void:
	_load_progress()
	if level_number > unlocked_level:
		get_tree().call_deferred("change_scene_to_file", "res://game.tscn")
		return
	_update_score()
	update_lives(3)
	_update_bonus()
	level_label.text = "LEVEL %d" % level_number
	if has_node("Boss"):
		update_boss_health($Boss.health, 5)
	else:
		boss_label.hide()
	_update_clock()
	music_player.play()

func _process(delta: float) -> void:
	if not level_finished and not is_game_over:
		elapsed_time += delta
		_update_clock()

func add_point() -> void:
	if score >= TOTAL_COINS:
		return
	score += 1
	_update_score()
	play_coin_sound()

func add_bonus_points(amount: int) -> void:
	bonus_points += amount
	_update_bonus()
	play_coin_sound()

func add_enemy_bonus(amount: int) -> void:
	bonus_points += amount
	_update_bonus()
	play_coin_sound()

func _update_score() -> void:
	label.text = "Coins: %d / %d" % [score, TOTAL_COINS]

func _update_bonus() -> void:
	bonus_label.text = "Bonus: %d" % bonus_points

func update_lives(lives: int) -> void:
	lives_label.text = "Lives: " + "♥".repeat(maxi(lives, 0))

func update_boss_health(health: int, maximum: int) -> void:
	boss_label.text = "BOSS: " + "♥".repeat(maxi(health, 0)) + "♡".repeat(maximum - maxi(health, 0))
	boss_label.show()

func defeat_boss() -> void:
	boss_defeated = true
	boss_label.hide()
	add_enemy_bonus(10)
	spawn_spark_effect($Boss.global_position, Color(1.0, 0.28, 0.12, 1.0))
	_show_temporary_message("Boss defeated! Reach the exit!", 2.5)

func show_boss_remaining() -> void:
	_show_temporary_message("Defeat the boss before leaving!", 2.0)

func _format_time(value: float) -> String:
	var total_seconds := int(value)
	var minutes := int(total_seconds / 60)
	var seconds := total_seconds % 60
	return "%02d:%02d" % [minutes, seconds]

func _update_clock() -> void:
	time_label.text = "Time: " + _format_time(elapsed_time)
	record_label.text = "Best: " + (_format_time(best_time) if best_time > 0.0 else "--:--")

func show_need_coins() -> void:
	_show_temporary_message("Find all 20 coins first!", 2.0)

func show_secret_found() -> void:
	_show_temporary_message("Secret path found! Bonus coin inside!", 2.5)

func _show_temporary_message(text: String, duration: float) -> void:
	message_label.text = text
	message_label.show()
	await get_tree().create_timer(duration).timeout
	if not level_finished and not is_game_over and message_label.text == text:
		message_label.hide()

func activate_checkpoint(position: Vector2, checkpoint_text: String) -> void:
	checkpoint_position = position
	spawn_spark_effect(position + Vector2(95.0, 524.0), Color(0.35, 1.0, 0.55, 1.0))
	_show_temporary_message(checkpoint_text, 1.8)

func spawn_spark_effect(world_position: Vector2, color: Color) -> void:
	for i in range(8):
		var spark := ColorRect.new()
		spark.color = color
		spark.size = Vector2(8.0, 8.0)
		spark.position = world_position - spark.size * 0.5
		add_child(spark)
		var angle := TAU * float(i) / 8.0
		var destination := spark.position + Vector2(cos(angle), sin(angle)) * 38.0
		var tween := create_tween().set_parallel(true)
		tween.tween_property(spark, "position", destination, 0.32)
		tween.tween_property(spark, "modulate:a", 0.0, 0.32)
		tween.chain().tween_callback(spark.queue_free)

func play_coin_sound() -> void:
	$CoinSfx.play()

func play_hit_sound() -> void:
	$HitSfx.play()

func play_goal_sound() -> void:
	$FinishSfx.play()

func _on_music_finished() -> void:
	music_player.play()

func complete_level() -> void:
	if level_finished:
		return
	level_finished = true
	if not next_level_path.is_empty():
		unlocked_level = maxi(unlocked_level, level_number + 1)
	if best_time <= 0.0 or elapsed_time < best_time:
		best_time = elapsed_time
	_save_progress()
	_update_clock()
	completion_title.text = "LEVEL %d COMPLETE!" % level_number
	next_level_button.text = "Next Level" if not next_level_path.is_empty() else "Play Again"
	completion_panel.show()
	play_goal_sound()

func game_over() -> void:
	is_game_over = true
	message_label.text = "GAME OVER"
	message_label.show()

func _load_progress() -> void:
	var save := ConfigFile.new()
	if save.load("user://game_progress.cfg") == OK:
		unlocked_level = int(save.get_value("progress", "unlocked_level", 1))
		best_time = float(save.get_value("records", "level_%d" % level_number, 0.0))

func _save_progress() -> void:
	var save := ConfigFile.new()
	save.load("user://game_progress.cfg")
	save.set_value("progress", "unlocked_level", unlocked_level)
	save.set_value("records", "level_%d" % level_number, best_time)
	save.save("user://game_progress.cfg")

func _on_next_level_button_pressed() -> void:
	get_tree().paused = false
	var destination := next_level_path if not next_level_path.is_empty() else "res://game.tscn"
	get_tree().change_scene_to_file(destination)
