extends Area2D

func _on_body_entered(body) -> void:
	if body.name == "Bird":
		var main_node = get_tree().get_first_node_in_group("MainGame")
		if main_node and main_node.has_method("bird_hit"):
			main_node.bird_hit()

func set_letter(letter: String):
	$Pipe/Label1.text = letter
	$Pipe/Label1.show()

func hide_letter():
	$Pipe/Label1.hide()
