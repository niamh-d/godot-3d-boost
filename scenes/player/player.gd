extends Node3D

func _process(delta: float) -> void:
	if Input.is_action_pressed("space"):
		position.y += delta
