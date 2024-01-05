extends CharacterBody2D

@export var speed: float = 256.0
@export var camera_rotation_enabled: bool = true
@export var camera_rotation_strength: float = 1.
@export var camera_movement_enabled: bool = true
@export var camera_movement_strength: float = 1.
var dtbf:          float
var gravity:       float = 2000.
var jump_impulse:  float = -800.


func _ready():
	if is_multiplayer_authority():
		$Label.text = "[color=#00FF00]"+str(name)+"[/color]"
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	else:
		$Label.text = "[color=#00FFFF]"+str(name)+"[/color]"


func _process(delta):
	if position.y > (512/2 * 8):
		position.y -= 512 * 8
	if position.x > (512/2 * 8):
		position.x -= 512 * 8
	if position.x < (-512/2 * 8):
		position.x += 512 * 8
	var direction: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if Input.is_key_pressed(KEY_SHIFT):
		dtbf = delta_time_based_factor(pow(2, 20), delta)
		velocity /= 1+dtbf
		if direction.length():
			velocity += direction * speed * dtbf * 3
	else:
		$SlideParticles.emitting = false
		if is_on_floor(): 
			velocity.y = 0
			dtbf = delta_time_based_factor(pow(2, 20), delta)
			velocity.x /= 1+dtbf
			if Input.is_action_just_pressed("ui_up"):
				velocity.y = jump_impulse
			if direction.length():
				velocity.x += direction.x * speed * dtbf
		else:
			dtbf = delta_time_based_factor(2, delta)
			velocity.y += gravity * delta
			velocity.x /= 1+dtbf
			if direction.length():
				velocity.x += direction.x * speed * dtbf
			if $L.is_colliding() or $R.is_colliding():
				$SlideParticles.position.x = -(float($L.is_colliding())-float($R.is_colliding()))*10
				$SlideParticles.emitting = true
				velocity.y = min(velocity.y, 64)
				if Input.is_action_just_pressed("ui_up"):
					velocity.x = (float($L.is_colliding())-float($R.is_colliding())) * speed * 2
					velocity.y = jump_impulse * .5
	move_and_slide()
	$Cursor.position = get_local_mouse_position()
	var d = clamp(1-(get_local_mouse_position().length()/128), 0, 1)
	dtbf = delta_time_based_factor(16, delta)
	$Label.scale += (Vector2.ONE * d) * dtbf
	$Label.scale /= 1+dtbf
	$Label.position += (-($Label.size*d/2) - Vector2(0, 32) * d) * dtbf
	$Label.position /= 1+dtbf
	if camera_rotation_enabled:
		$Camera2D.rotation += velocity.x * camera_rotation_strength / 8192 * dtbf
		$Camera2D.rotation /= 1+dtbf
	if camera_movement_enabled:
		$Camera2D.position -= velocity * camera_movement_strength / 8 * dtbf
		$Camera2D.position /= 1+dtbf
	$Camera2D/Sprite2D4.material.set_shader_parameter("velocity", (velocity*delta))
	$Camera2D.zoom *= Input.get_axis("ui_page_down", "ui_page_up")*.01+1


func delta_time_based_factor(factor: float, delta: float):
	return pow(factor, delta)-1
