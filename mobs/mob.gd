class_name Mob extends CharacterBody2D

var _player: Player = null
var sounds := {
	"die": preload("uid://cte8ddxd7o4de"),
	"damaged": preload("uid://dfc5tcrthtntk")
}
## The radius around the mob which detects whether a Node has entered, and if so follows that Node 
@onready var _detection_area: Area2D = %DetectionArea
## The collision area which deals damage upon body_entered
@onready var _hitbox: Area2D = %Hitbox
@onready var _damage_timer: Timer = %DamageTimer
@onready var _animation_player: AnimationPlayer = %AnimationPlayer
@onready var _audio_stream_player: AudioStreamPlayer2D = %AudioStreamPlayer2D

@export var max_speed := 250.0
@export var acceleration := 700.0
@export var damage := 1
@export var health := 3: set = set_health

func _ready() -> void:
	_detection_area.body_entered.connect(func (body: Node) -> void:
		if body is Player:
			_player = body
	)
	_detection_area.body_exited.connect(func (body: Node) -> void:
		if body is Player:
			_player = null
	)
	_hitbox.body_entered.connect(func(body: Node) -> void:
		# if player in hitbox, take damage and start timer
		if body is Player and _damage_timer.is_stopped():
			if _player == null:
				push_error("Touched hitbox but not detection area")
				_player = body
			_player.health -= damage
			_damage_timer.start()
	)
	_hitbox.body_exited.connect(func (body: Node) -> void:
		if body is Player:
			_damage_timer.stop()
	)
	_damage_timer.timeout.connect(func () -> void:
		if _player:
			_player.health -= damage
			_damage_timer.start()
	)

func set_health(new_health: int) -> void:
	var prev_health := health
	health = new_health

	if health <= 0:
		die()
	elif health < prev_health:
		take_damage()

func _physics_process(delta: float) -> void:
	if _player != null:
		var player_pos := get_global_player_position()
		var direction := global_position.direction_to(player_pos)
		var distance := global_position.distance_to(player_pos)
		var speed := max_speed if distance > 120.0 else max_speed * distance / 120.0
		var desired_velocity := direction * speed 
		velocity = velocity.move_toward(desired_velocity, acceleration * delta)
	else: 
		velocity = velocity.move_toward(Vector2.ZERO, acceleration * delta)

	move_and_slide()
		
func get_global_player_position() -> Vector2:
	return _player.global_position

func take_damage() -> void:
	_animation_player.play("damaged")
	_audio_stream_player.stream = sounds.damaged
	_audio_stream_player.play()

func die() -> void:
	if _hitbox == null:
		return
	set_physics_process(false)
	collision_layer = 0
	collision_mask = 0
	_hitbox.queue_free()
	
	_animation_player.play("die")
	_audio_stream_player.stream = sounds.die
	_audio_stream_player.play()
	_audio_stream_player.finished.connect(queue_free)
