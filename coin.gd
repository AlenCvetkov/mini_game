extends Area2D

# Дефинираме колку поени носи паричката
var score_value: int = 1


func _ready() -> void:
	# Ова автоматски ја пушта анимацијата за вртење штом ќе се појави паричката
	$AnimatedSprite2D.play("default")


func _on_body_entered(body: Node2D) -> void:
	if body.name == "PLayer":
		print("Паричката е собрана!")
		
		# Го наоѓаме Label-от на екранот и му ги зголемуваме поените
		var score_label = get_node("/root/World/CanvasLayer/Label")
		if score_label:
			# Ги земаме тековните поени од текстот, ги претвораме во број и додаваме +1
			var current_score = score_label.text.to_int()
			current_score += score_value
			score_label.text = str(current_score)
			
		queue_free() # Ја брише паричката откако ќе ја собере
