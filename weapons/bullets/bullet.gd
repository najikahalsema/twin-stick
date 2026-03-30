class_name Bullet extends Area2D

@export var speed := 750.0 
@export var damage := 1
@export var targets_player := false

# TO-DO: make this able to switch out depending on weapon type
@onready var hit_sound: AudioStreamPlayer2D = %HitSound

var max_range := 600.0
var _distance_travelled := 0.0 

func _ready() -> void:
	body_entered.connect(func(body: Node) -> void:
		if (body is Player and targets_player) or (not targets_player and body is Mob):
			body.health -= damage
			_destroy()
	)
	
func _physics_process(delta: float) -> void:
	var distance := speed * delta
	var motion := Vector2.RIGHT.rotated(rotation) * distance
	position += motion
	
	_distance_travelled += distance
	
	if _distance_travelled > max_range:
		_destroy()
	
func _destroy() -> void:
	if hit_sound != null:
		hit_sound.play()
		set_deferred("monitoring", false)
		set_physics_process(false)
		hide()
		hit_sound.finished.connect(queue_free)
	else:
		queue_free()
