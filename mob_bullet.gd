class_name MobBullet extends Area2D

@export var speed := 750.0 
@export var damage := 1
@export var targets_player := false: set = set_targets_player

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

func set_targets_player(val: bool) -> void:
	targets_player = val 
	
	const PLAYER_PHYSICS_LAYER = 1
	const MOB_PHYSICS_LAYER = 3
	set_collision_mask_value(MOB_PHYSICS_LAYER, not targets_player)
	set_collision_mask_value(PLAYER_PHYSICS_LAYER, targets_player)
