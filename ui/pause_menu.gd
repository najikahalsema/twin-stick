class_name PauseMenu extends Control

@onready var resume_button: Button = %ResumeButton
@onready var settings_button: Button = %SettingsButton
@onready var quit_button: Button = %QuitButton
@onready var _panel_container: PanelContainer = %PanelContainer
@onready var _bg_rect: ColorRect = %BackgroundRect

@export_range(0.1, 10.0, 0.01, "or_greater") var animation_duration := 2.3
@export_range(0, 1.0) var menu_opened_amount := 0.0:
	set = set_menu_opened_amount
	
var _tween: Tween
var _is_currently_opening := false

func set_menu_opened_amount(amount: float) -> void:
	menu_opened_amount = amount
	visible = amount > 0 
	
	if _panel_container == null or _bg_rect == null:
		return
		
	_bg_rect.material.set_shader_parameter("blur_amount", lerp(0.0, 1.5, amount))
	_bg_rect.material.set_shader_parameter("tint_strength", lerp(0.0, 0.2, amount))
	
	_panel_container.modulate.a = amount
	
func _ready() -> void:
	resume_button.pressed.connect(toggle)
	settings_button.pressed.connect(func () -> void:
		pass
	)
	quit_button.pressed.connect(get_tree().quit)

func _process(delta: float) -> void:
	pass

func toggle() -> void:
	_is_currently_opening = not _is_currently_opening
	var duration := animation_duration
	
	# If the tween exists
	if _tween != null:
		# and the tween is animating, KILL THE TWEEN!
		if not _is_currently_opening:
			# if the previous tween was animating, we want to animate back
			# from the current point in the animation
			duration = _tween.get_total_elapsed_time()
		_tween.kill()
		
	_tween = create_tween()
	_tween.set_ease(Tween.EASE_OUT)
	_tween.set_trans(Tween.TRANS_QUART)
	
	var target_amount := 1.0 if _is_currently_opening else 0.0
	_tween.tween_property(self, "menu_opened_amount", target_amount, duration)
