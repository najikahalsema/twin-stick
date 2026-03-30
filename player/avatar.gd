extends Sprite2D

const AVATAR_BOTTOM = preload("uid://bw03btxpkxde4")
const AVATAR_BOTTOM_RIGHT = preload("uid://cm33qabjyo48g")
const AVATAR_UP = preload("uid://b2q8n8kfhhbi7")
const AVATAR_UP_RIGHT = preload("uid://deiak2vt25cwr")
const AVATAR_RIGHT = preload("uid://dscj1kv8s4bxa")

const UP_RIGHT = Vector2.UP + Vector2.RIGHT
const UP_LEFT = Vector2.UP + Vector2.LEFT
const DOWN_RIGHT = Vector2.DOWN + Vector2.RIGHT
const DOWN_LEFT = Vector2.DOWN + Vector2.LEFT

func _physics_process(delta: float) -> void:
	var input_direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction_discrete := input_direction.sign()
	
	match direction_discrete:
		Vector2.RIGHT, Vector2.LEFT:
			texture = AVATAR_RIGHT
		Vector2.UP:
			texture = AVATAR_UP
		Vector2.DOWN:
			texture = AVATAR_BOTTOM
		UP_RIGHT, UP_LEFT:
			texture = AVATAR_UP_RIGHT
		DOWN_RIGHT, DOWN_LEFT:
			texture = AVATAR_BOTTOM_RIGHT
	if direction_discrete.length() > 0.0:
		flip_h = direction_discrete.x < 0.0
