@tool
class_name Pickup extends Area2D

@export var item: Item = null: set = set_item

@onready var _sprite_2d: Sprite2D = %Sprite2D
@onready var _audio_stream_player: AudioStreamPlayer2D = %AudioStreamPlayer2D
@onready var _animation_player: AnimationPlayer = %AnimationPlayer

func _ready() -> void:
	set_item(item)
	
	_animation_player.play("idle")
	
	body_entered.connect(func(body: Node) -> void:
		if body is Player:
			item.use(body)
			_audio_stream_player.play()
			_animation_player.play("consume")
		# Disable collision monitoring to prevent multiple pickups
			set_deferred("monitoring", false)
			_animation_player.animation_finished.connect(func(_animation_name: String) -> void:
					queue_free()
			)
		#var is_audio_longer := _audio_stream_player.stream.get_length() > _animation_player.get_current_animation_length()
	)

func set_item(value: Item) -> void:
	item = value
	update_configuration_warnings()
	
	if _sprite_2d != null:
		_sprite_2d.texture = item.texture
	if _audio_stream_player != null:
		_audio_stream_player.stream = item.pickup_sound

func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	if item == null:
		warnings.append("The pickup has no item assigned. Please assign an item to the pickup in the inspector!")
	return warnings
