extends CharacterBody2D

const SPEED = 600.0
const JUMP_VELOCITY = -420.0
const DASH_SPEED = 1400.0
const DASH_DURATION = 0.18
const DASH_COOLDOWN = 1.2
const MAX_LIVES = 3

var lives: int = MAX_LIVES
var invulnerable: bool = false
var dash_time_left: float = 0.0
var dash_cooldown_left: float = 0.0
var dash_direction: float = 1.0

func _physics_process(delta: float) -> void:
	var game = get_tree().current_scene
	if game.level_finished or game.is_game_over:
		velocity = Vector2.ZERO
		return

	dash_cooldown_left = maxf(0.0, dash_cooldown_left - delta)
	if Input.is_action_just_pressed("dash") and dash_cooldown_left <= 0.0:
		var wanted_direction := Input.get_axis("ui_left", "ui_right")
		if wanted_direction != 0.0:
			dash_direction = wanted_direction
		else:
			dash_direction = -1.0 if $AnimatedSprite2D.flip_h else 1.0
		dash_time_left = DASH_DURATION
		dash_cooldown_left = DASH_COOLDOWN
		$AnimatedSprite2D.modulate = Color(0.55, 0.88, 1.0, 1.0)
		game.spawn_spark_effect($AnimatedSprite2D.global_position, Color(0.3, 0.8, 1.0, 1.0))

	if dash_time_left > 0.0:
		dash_time_left = maxf(0.0, dash_time_left - delta)
		velocity = Vector2(dash_direction * DASH_SPEED, 0.0)
		if dash_time_left == 0.0:
			$AnimatedSprite2D.modulate = Color.WHITE
	else:
		if not is_on_floor():
			velocity += get_gravity() * delta
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			game.spawn_spark_effect($AnimatedSprite2D.global_position + Vector2(0, 28), Color(0.7, 0.85, 1.0, 1.0))
		var direction := Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
			$AnimatedSprite2D.play("run")
			$AnimatedSprite2D.flip_h = (direction < 0)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			$AnimatedSprite2D.stop()

	move_and_slide()

func take_damage() -> void:
	if invulnerable or lives <= 0:
		return
	invulnerable = true
	lives -= 1
	var game = get_tree().current_scene
	game.update_lives(lives)
	game.play_hit_sound()
	$AnimatedSprite2D.modulate = Color(1.0, 0.35, 0.35, 0.45)
	if lives <= 0:
		game.game_over()
		await get_tree().create_timer(2.0).timeout
		get_tree().reload_current_scene()
		return
	global_position = game.checkpoint_position
	velocity = Vector2.ZERO
	await get_tree().create_timer(1.2).timeout
	$AnimatedSprite2D.modulate = Color.WHITE
	invulnerable = false

func stomp_enemy() -> void:
	velocity.y = -320.0
