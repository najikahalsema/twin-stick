class_name DialogueBox extends Control

signal dialogue_finished 

@onready var body: TextureRect = %Body
@onready var expression: TextureRect = %Expression
@onready var rich_text_label: RichTextLabel = %RichTextLabel
@onready var next_button: Button = %NextButton
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer

@export var dialogue_items: Array[DialogueEntry] = []
var current_item_index := 0

func _ready() -> void:
	next_button.pressed.connect(advance)

func show_text() -> void:
	var current_item := dialogue_items[current_item_index]
	rich_text_label.text = current_item.text
	expression.texture = current_item.expression
	body.texture = current_item.character 
	
	# Animation code 
	rich_text_label.visible_ratio = 0.0
	var tween := create_tween()
	var text_appearing_duration: float = current_item["text"].length() / 30.0
	tween.tween_property(rich_text_label, "visible_ratio", 1.0, text_appearing_duration)
	
	# Cut random chunk of audio for the length of dialogue
	var sound_max_offset := audio_stream_player.stream.get_length() - text_appearing_duration
	var sound_start_position := randf() * sound_max_offset
	audio_stream_player.play(sound_start_position)
	tween.finished.connect(audio_stream_player.stop)
	
	# Only slide in on the first dialogue item 
	if current_item_index == 0:
		slide_in()
	
func advance() -> void:
	current_item_index += 1
	if current_item_index == dialogue_items.size():
		current_item_index = 0 
		hide()
		dialogue_finished.emit()
	else:
		show_text()

func slide_in() -> void:
	var slide_tween := create_tween()
	slide_tween.set_ease(Tween.EASE_OUT)
	body.position.x = get_viewport_rect().size.x / 7
	slide_tween.tween_property(body, "position:x", 0, 0.3)
	body.modulate.a = 0
	slide_tween.parallel().tween_property(body, "modulate:a", 1, 0.2)
