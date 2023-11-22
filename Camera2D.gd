extends Camera2D

@export var camera_speed: float = 1.0
var direction: Vector2
var last_relative_mouse_position: Vector2 = Vector2()

func _physics_process(delta):
	#position -= last_relative_mouse_position
	#last_relative_mouse_position = get_global_mouse_position() - global_position
	#position += last_relative_mouse_position
	var dtbd = delta_time_based_division(1024, delta)
	direction += Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized() * dtbd
	direction *= 1/dtbd
	if direction.length():
		position += direction * camera_speed


func delta_time_based_division(division: float, delta: float):
	return pow(division, delta)
