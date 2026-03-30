extends Area2D

@onready var dialogue_box: DialogueBox = %DialogueBox

var _player: Player = null

func _ready() -> void:
	dialogue_box.hide()
	body_entered.connect(func(body: Node) -> void:
		if body is Player:
			_player = body
	)
	body_exited.connect(func(body: Node) -> void:
		if body is Player:
			_player = null
	)
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and _player:
		dialogue_box.show()
		dialogue_box.show_text()
		
		_player.toggle_player_control(false)
		
		if not dialogue_box.dialogue_finished.is_connected(
			_player.toggle_player_control
		):
			dialogue_box.dialogue_finished.connect(
				_player.toggle_player_control.bind(true)
			)
