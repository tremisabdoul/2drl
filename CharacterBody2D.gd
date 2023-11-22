extends CharacterBody2D

@export var speed: float = 50.0
var dtbf: float


func _physics_process(delta):
	var direction: Vector2
	direction += Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	if is_on_floor():
		dtbf = delta_time_based_factor(4096, delta)
		
		velocity.x *= 1/dtbf
		if direction.length():
			velocity += direction * speed * dtbf
	else:
		dtbf = delta_time_based_factor(2, delta)
		
		velocity.x *= 1/dtbf
		if direction.length():
			velocity += direction * speed * dtbf * .1
	
	move_and_slide()
	
	
	dtbf = delta_time_based_factor(16, delta)
	$Camera2D.position += velocity / 100 * dtbf
	$Camera2D.position /= dtbf
	$Camera2D.rotation += velocity.x / 300000 * dtbf
	$Camera2D.rotation /= dtbf


func delta_time_based_factor(division: float, delta: float):
	return pow(division, delta)
