extends RigidBody3D

## How much vertical force to apply when moving (between 750 and 3000).
@export_range(750.0, 3000.0) var thrust: float = 1000.0

@export var torque_thrust: float = 100.0

var has_crashed: bool = false
var has_won: bool = false
var file_path: String = ""

func _process(delta: float) -> void:
	if Input.is_action_pressed("boost"):
		apply_central_force(basis.y * delta * thrust)
		
	if Input.is_action_pressed("rotate_left"):
		apply_torque(Vector3(0.0, 0.0, torque_thrust * delta))
		
	if Input.is_action_pressed("rotate_right"):
		apply_torque(Vector3(0.0, 0.0, -torque_thrust * delta))

func _on_body_entered(body: Node) -> void:
	if has_crashed || has_won:
		return
	if "LandingPad" in body.get_groups():
		win(body.file_path)
	if "Hazard" in body.get_groups():
		crash()

func crash() -> void:
	has_crashed = true
	set_process(false)
	print('KABOOM!')
	transition()

func win(next_level_file: String) -> void:
	file_path = next_level_file
	has_won = true
	set_process(false)
	print("You win!")
	transition()

func transition() -> void:
	var tween = create_tween()
	tween.tween_interval(1.0)
	if has_won:
		tween.tween_callback(get_tree().change_scene_to_file.bind(file_path))
	tween.tween_callback(get_tree().reload_current_scene)
	
