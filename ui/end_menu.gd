extends Control

@onready var _replay_button: Button = %ReplayButton
@onready var _quit_button: Button = %QuitButton
@onready var _panel_container: PanelContainer = %PanelContainer
@onready var _bg_rect: ColorRect = %BackgroundRect
@onready var time_score: Label = %TimeScore

@export_range(0.1, 10.0, 0.01, "or_greater") var animation_duration := 2.3
@export_range(0, 1.0) var menu_opened_amount := 0.0:
	set = set_menu_opened_amount
	
@export_group("Confetti")
@export var confetti_amount := 5
@export var confetti_pop_delay := 0.5

var _tween: Tween 
var _start_time := Time.get_ticks_msec()

func set_menu_opened_amount(amount: float) -> void:
	menu_opened_amount = amount
	visible = amount > 0 
	
	if _panel_container == null or _bg_rect == null:
		return
		
	_bg_rect.material.set_shader_parameter("blur_amount", lerp(0.0, 1.5, amount))
	_bg_rect.material.set_shader_parameter("tint_strength", lerp(0.0, 0.2, amount))
	
	_panel_container.modulate.a = amount
	
func _ready() -> void:
	if Engine.is_editor_hint():
		return
	menu_opened_amount = 0.0
	 
	_replay_button.pressed.connect(func() -> void:
		get_tree().paused = false
		get_tree().reload_current_scene()
	)
	_quit_button.pressed.connect(get_tree().quit)

func open() -> void:
	set_menu_opened_amount(1.0)
	
	var end_time := Time.get_ticks_msec()
	var total_time_msec := end_time - _start_time
	var total_time_s := snappedf(total_time_msec / 1000.0, 0.1)
	time_score.text = "Time: " + str(total_time_s) + " seconds"
	
	if _tween != null:
		_tween.kill()
		
	_tween = create_tween()
	_tween.set_ease(Tween.EASE_OUT)
	_tween.set_trans(Tween.TRANS_QUART)

	_tween.tween_property(self, "menu_opened_amount", 1.0, animation_duration)
	pop_confetti()
	
func pop_confetti() -> void:
	var screen_size := get_viewport_rect().size
	for i in confetti_amount:
		await get_tree().create_timer(confetti_pop_delay).timeout
		var confetti: GPUParticles2D = preload("res://common/particles/confetti_particles.tscn").instantiate()
		add_child(confetti)
		
		confetti.global_position = Vector2(
			randf_range(0.0, screen_size.x),
			screen_size.y
		)
		confetti.emitting = true
