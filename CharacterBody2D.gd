extends CharacterBody2D

@export var speed: float = 30.0
var dtbf:          float
var gravity:       float = 800.
var jump_impulse:  float = -400.


func _ready():
	if is_multiplayer_authority():
		$Label.text = "[color=#00FF0088]"+str(name)+"[/color]"


func _physics_process(delta):
	var direction: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if Input.is_key_pressed(KEY_SHIFT):
		dtbf = delta_time_based_factor(pow(2, 20), delta)
		velocity /= dtbf
		if direction.length():
			velocity += direction * speed * dtbf
	else:
		if is_on_floor(): 
			dtbf = delta_time_based_factor(pow(2, 20), delta)
			velocity.x /= dtbf
			if Input.is_action_just_pressed("ui_up"):
				velocity.y = jump_impulse
				velocity.x += direction.x * speed
			if direction.length():
				velocity.x += direction.x * speed * dtbf
		else:
			dtbf = delta_time_based_factor(2, delta)
			velocity.y += gravity * delta
			velocity.x /= dtbf
			if direction.length():
				velocity.x += direction.x * speed * dtbf * .1
			if $L.is_colliding() or $R.is_colliding():
				if Input.is_action_just_pressed("ui_up"):
					velocity.x = (float($L.is_colliding())+-float($R.is_colliding())) * speed * 10
					velocity.y = jump_impulse / 2
	
	move_and_slide()
	
	dtbf = delta_time_based_factor(16, delta)
	$Camera2D.position += velocity / 300 * dtbf
	$Camera2D.position /= dtbf
	$Camera2D.rotation += velocity.x / 300000 * dtbf
	$Camera2D.rotation /= dtbf
	$Camera2D.zoom += Vector2.ONE * Input.get_axis("ui_text_scroll_up", "ui_text_scroll_down")
	$Camera2D/Sprite2D4.material.set_shader_parameter("velocity", (velocity*delta))


func delta_time_based_factor(factor: float, delta: float):
	return pow(factor, delta)
