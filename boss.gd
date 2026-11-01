extends Area2D

@export var projectile_scene: PackedScene
@export var health: int = 5
@export var move_speed: float = 75.0
var direction: float = -1.0
var left_limit: float
var right_limit: float
var attack_timer: float = 1.5
var hit_cooldown: float = 0.0

func _ready() -> void:
	left_limit = position.x - 170.0
	right_limit = position.x + 170.0

func _physics_process(delta: float) -> void:
	position.x += direction * move_speed * delta
	if position.x <= left_limit:
		position.x = left_limit
		direction = 1.0
	elif position.x >= right_limit:
		position.x = right_limit
		direction = -1.0

	attack_timer -= delta
	hit_cooldown = maxf(0.0, hit_cooldown - delta)
	if attack_timer <= 0.0:
		_shoot_at_player()
		attack_timer = 2.1

func _shoot_at_player() -> void:
	var player := get_tree().current_scene.get_node_or_null("PLayer")
	if player == null or projectile_scene == null:
		return
	var projectile := projectile_scene.instantiate() as Area2D
	get_tree().current_scene.add_child(projectile)
	projectile.global_position = global_position + Vector2(-38.0, -12.0)
	projectile.set_target(player.global_position + Vector2(95.0, 524.0))

func _on_body_entered(body: Node2D) -> void:
	if body.name != "PLayer":
		return
	var player_shape := body.get_node_or_null("CollisionShape2D") as CollisionShape2D
	var player_rect := player_shape.shape as RectangleShape2D
	var player_bottom := player_shape.global_position.y + player_rect.size.y * 0.5
	if body.velocity.y > 0.0 and player_bottom <= global_position.y - 34.0 and hit_cooldown <= 0.0:
		health -= 1
		hit_cooldown = 0.55
		body.stomp_enemy()
		get_tree().current_scene.spawn_spark_effect(global_position, Color(1.0, 0.22, 0.18, 1.0))
		$Sprite2D.modulate = Color(1.0, 0.45, 0.4, 1.0)
		await get_tree().create_timer(0.12).timeout
		if is_instance_valid(self):
			$Sprite2D.modulate = Color.WHITE
		if health <= 0:
			get_tree().current_scene.defeat_boss()
			queue_free()
	else:
		body.take_damage()