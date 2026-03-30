class_name Item extends Resource

@export var display_name := ""
@export var texture: Texture2D = null
@export var pickup_sound: AudioStream = null

func use(player: Player) -> void:
	pass
