extends Area2D

@onready var dialogue_box: DialogueBox = %DialogueBox
var is_player_nearby := false 

func _ready() -> void:
	dialogue_box.hide()
	body_entered.connect(func(body: Node) -> void:
		if body is Player:
			is_player_nearby = true
	)
	body_exited.connect(func(body: Node) -> void:
		if body is Player:
			is_player_nearby = false 
	)
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"): # and is_player_nearby:
		get_viewport().set_input_as_handled()
		dialogue_box.show()
		dialogue_box.show_text()
