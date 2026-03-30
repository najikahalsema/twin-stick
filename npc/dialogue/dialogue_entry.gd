class_name DialogueEntry extends Resource

@export_group("Images")
@export var expression: Texture = preload("uid://d000xjtr4iqtk")
@export var character: Texture = preload("uid://copkt78vgp37i")
@export_group("Text")
@export_multiline var text: String = ""
@export_group("Voice")
@export var voice: AudioStream = preload("uid://bm2mvov4dm0aw")
