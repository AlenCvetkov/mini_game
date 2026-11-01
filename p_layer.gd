extends CharacterBody2D

const SPEED = 600.0
const JUMP_VELOCITY = -420.0
const MAX_LIVES = 3

var lives: int = MAX_LIVES
var invulnerable: bool = false

func _physics_process(delta: float) -> void:
	var game = get_tree().current_scene
	if game.level_finished or game.is_game_over:
		velocity = Vector2.ZERO
		return

	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

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
	get_tree().current_scene.update_lives(lives)
	$AnimatedSprite2D.modulate.a = 0.4
	if lives <= 0:
		get_tree().current_scene.game_over()
		await get_tree().create_timer(2.0).timeout
		get_tree().reload_current_scene()
		return
	await get_tree().create_timer(1.2).timeout
	$AnimatedSprite2D.modulate.a = 1.0
	invulnerable = false