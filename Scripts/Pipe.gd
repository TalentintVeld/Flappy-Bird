extends Area2D

signal hit

func _on_body_entered(_body) -> void:
	hit.emit()

func set_letter(letter: String):
	$Label1.text = letter
	$Label1.show()
	$Label2.text = letter
	$Label2.show()

func hide_letter():
	$Label1.hide()
	$Label2.hide()
