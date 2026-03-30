extends Control

@onready var replay: Button = %Replay
@onready var quit: Button = %Quit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	replay.pressed.connect(func() -> void: print("replay"))
	quit.pressed.connect(get_tree().quit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func open() -> void:
	visible = true
	# get_tree().paused = true
