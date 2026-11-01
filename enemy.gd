extends Area2D

@export var speed: float = 95.0
@export var patrol_distance: float = 125.0
@export_enum("Patrol", "Fast", "Jumper") var movement_type: String = "Patrol"
@export var jump_height: float = 80.0
@export var jump_frequency: float = 2.3
var direction: float = 1.0
var left_limit: float
var right_limit: float
var start_y: float
var jump_phase: float = 0.0

func _ready() -> void:
	left_limit = position.x - patrol_distance
	right_limit = position.x + patrol_distance
	start_y = position.y

func _physics_process(delta: float) -> void:
	position.x += speed * direction * delta
	if position.x >= right_limit:
		position.x = right_limit
		direction = -1.0
	elif position.x <= left_limit:
		position.x = left_limit
		direction = 1.0
	if movement_type == "Jumper":
		jump_phase += delta * jump_frequency
		position.y = start_y - absf(sin(jump_phase)) * jump_height

func _on_body_entered(body: Node2D) -> void:
	if not body.has_method("take_damage"):
		return
	var player_shape := body.get_node_or_null("CollisionShape2D") as CollisionShape2D
	var player_rect := player_shape.shape as RectangleShape2D
	var player_bottom := player_shape.global_position.y + player_rect.size.y * 0.5
	if body.velocity.y > 0.0 and player_bottom <= global_position.y - 12.0:
		body.stomp_enemy()
		get_tree().current_scene.add_enemy_bonus(2)
		get_tree().current_scene.spawn_spark_effect(global_position, Color(1.0, 0.72, 0.18, 1.0))
		queue_free()
	else:
		body.take_damage()