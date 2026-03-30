@tool
class_name Chest extends Area2D

@onready var _animation_player: AnimationPlayer = %AnimationPlayer

@export var possible_items: Array[Item] = []

var is_player_nearby := false
var is_opened := false

func _ready() -> void:
	update_configuration_warnings()
	body_entered.connect(func(body: Node) -> void:
		if body is Player:
			is_player_nearby = true
	)
	body_exited.connect(func(body: Node) -> void:
		if body is Player:
			is_player_nearby = false 
	)
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and is_player_nearby and not is_opened:
		_animation_player.play("open")
		spawn_random_item()
		get_viewport().set_input_as_handled()
		
func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if possible_items == null:
		warnings.append("You must include at least one possible item the chest can spawn in its array.")
	return warnings

func spawn_random_item() -> void:
	if possible_items == []:
		return
	
	for item in possible_items:
		var pickup: Pickup = preload("res://pickups/pickup.tscn").instantiate()
		pickup.item = item
		add_child(pickup)
		
		var random_angle := randf_range(0.0, 2.0 * PI) # 2 x pi = 360 degrees
		var random_direction := Vector2(1.0, 0.0).rotated(random_angle)
		var random_distance := randf_range(60.0, 120.0)
		var land_position = random_direction * random_distance
		const FLIGHT_TIME := 0.4
		const HALF_FLIGHT_TIME := FLIGHT_TIME / 2.0
		
		var tween = create_tween()
		tween.set_parallel()
		pickup.scale = Vector2(0.25, 0.25)
		
		tween.tween_property(pickup, "scale", Vector2(1.0, 1.0), HALF_FLIGHT_TIME)
		tween.tween_property(pickup, "position:x", land_position.x, FLIGHT_TIME)

		tween = create_tween()
		tween.set_trans(Tween.TRANS_QUAD) #change anim speed over time
		tween.set_ease(Tween.EASE_OUT) #item starts fast and slows down
		
		var jump_height := randf_range(30.0, 80.0)
		
		tween.tween_property(pickup, "position:y", land_position.y - jump_height, HALF_FLIGHT_TIME)
		tween.set_ease(Tween.EASE_IN) #start slow and speed up 
		tween.tween_property(pickup, "position:y", land_position.y, HALF_FLIGHT_TIME)

	is_opened = true
