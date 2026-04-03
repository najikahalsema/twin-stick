class_name MenuController extends Control

@onready var pause_menu: PauseMenu = %PauseMenu
var _player := Player

func _ready() -> void:
	pause_menu.resume_button.pressed.connect(func () -> void:
		pass
	)
	pause_menu.settings_button.pressed.connect(func () -> void:
		pass
	)
	pause_menu.quit_button.pressed.connect(func () -> void:
		pass
	)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("cancel") and not pause_menu.visible:
		pause_menu.toggle()

	
