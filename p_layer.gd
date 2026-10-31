extends CharacterBody2D

# Брзина на движење и јачина на скок
const SPEED = 600.0
const JUMP_VELOCITY = -420.0

func _physics_process(delta: float) -> void:
	# 1. Гравитација: ако ликот не е на земја, додавај му забрзување надолу
	if not is_on_floor():
		velocity += get_gravity() * delta

	# 2. Скокање: ако е притиснато копчето за скок (Space или Up стрелка) и ликот е на земја
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# 3. Земи го правецот на движење (-1 лево, 1 десно) преку стрелките или A/D
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		# Пушти ја анимацијата за трчање и сврти го ликот лево/десно
		$AnimatedSprite2D.play("run")
		$AnimatedSprite2D.flip_h = (direction < 0)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		# Запри ја анимацијата кога ликот стои мирно
		$AnimatedSprite2D.stop()

	# Изврши го движењето и пресметај ги судирите
	move_and_slide()
