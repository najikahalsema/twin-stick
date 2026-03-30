class_name DialogueEntry extends Resource

@export_group("Images")
@export var expression: Texture = null
@export var character: Texture = null
@export_group("Text")
@export_multiline var text: String = ""
@export_group("Voice")
@export var voice: AudioStream = null
