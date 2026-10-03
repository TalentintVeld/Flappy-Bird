extends Area2D

func _on_body_entered(body) -> void:
	if body.name == "Bird":
		var main_node = get_tree().get_first_node_in_group("MainGame")
		if main_node and main_node.has_method("bird_hit"):
			main_node.bird_hit()

func set_letter(letter: String):
	$Lower/Label1.text = letter
	$Lower/Label1.show()
	$Upper/Label2.text = letter
	$Upper/Label2.show()

func hide_letter():
	$Lower/Label1.hide()
	$Upper/Label2.hide()
