class_name WeaponPivot extends Node2D

var is_using_gamepad:= false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion or event is InputEventKey:
		is_using_gamepad = false
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		is_using_gamepad = true

func _process(delta: float) -> void:
	var aim_direction := Vector2.ZERO
	if is_using_gamepad:
		pass
	else:
		aim_direction = global_position.direction_to(get_global_mouse_position())
	if aim_direction.length() > 0.1: 
		rotation = aim_direction.angle()
	
	z_index = 3
	if aim_direction.y < 0.0:
		z_index = 1 # render hands behind head when aiming up
