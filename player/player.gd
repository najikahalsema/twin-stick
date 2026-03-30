class_name Player extends CharacterBody2D

@export var max_speed := 600.0
@export var acceleration := 1200.0
@export var deceleration := 1080.0 
@export var max_health := 5
@export var base_weapon_scene : PackedScene
@onready var health:= max_health: set = set_health
@onready var _collision_shape_2d: CollisionShape2D = %CollisionShape2D
@onready var health_bar: ProgressBar = %HealthBar
@onready var _avatar: Sprite2D = %Avatar

@onready var _weapon_pivot: WeaponPivot = %WeaponPivot
@onready var base_weapon: Weapon
@onready var weapon_anchor: Marker2D = %WeaponAnchor
@onready var current_weapon: Weapon
@onready var hand_left: Sprite2D = %HandLeft
@onready var hand_right: Sprite2D = %HandRight

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var _pain_sounds: AudioStreamPlayer = %PainSounds
@onready var _death_sounds: AudioStreamPlayer = %DeathSounds

var _weapon_timer: Timer = null

func set_health(new_health: int) -> void:
	var prev_health := health
	health = clampi(new_health, 0, max_health)
	health_bar.value = health

	if prev_health > health:
		take_damage()

	if health == 0:
		die()
	
func _ready() -> void:	
	health_bar.max_value = max_health
	health_bar.value = health
	
	weapon_anchor.add_child(base_weapon)
	current_weapon = base_weapon
	
	_weapon_timer = Timer.new()
	_weapon_timer.one_shot = true
	_weapon_timer.wait_time = 5.0
	_weapon_timer.timeout.connect(func() -> void: reset_weapon())
	add_child(_weapon_timer)
	
	
	
func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")

	var has_input_direction := direction.length() > 0.0
	if has_input_direction:
		var desired_velocity := direction * max_speed
		velocity = velocity.move_toward(desired_velocity, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
	move_and_slide()
	
func change_weapon(weapon_scene: PackedScene, hand_texture: Texture) -> void:
		if current_weapon != null:
			current_weapon.queue_free()
		# This is very cringe but it prevents the first weapon's bullets from also firing
		# weapon_anchor's first child is the fire bullets 
		weapon_anchor.remove_child(weapon_anchor.get_child(0))
		
		current_weapon = weapon_scene.instantiate()
		weapon_anchor.add_child(current_weapon)
		print(weapon_anchor.get_children())
		
		hand_left.texture = hand_texture
		hand_right.texture = hand_texture
		
		# Commenting out for now because the reset_weapon code doesn't do what i want
		_weapon_timer.stop()
		_weapon_timer.start()

func reset_weapon() -> void:
	if current_weapon != null:
		current_weapon.queue_free()
	current_weapon = base_weapon
	weapon_anchor.add_child(current_weapon)
	# This doesn't work so there's no bullet and the code crashes 
	# current_weapon.bullet_scene = preload("uid://d1cm7qj3w5xtl")

	hand_left.texture = preload("uid://dekkcmj408pvt")
	hand_right.texture = preload("uid://dekkcmj408pvt")

func take_damage() -> void:
	animation_player.play("damaged")
	_pain_sounds.play()

func die() -> void:
	toggle_player_control(false)

	# wait until physics engine processes updates before changing property
	_collision_shape_2d.set_deferred("disabled", true) 
	
	_death_sounds.play()
	animation_player.play("die")
	_death_sounds.finished.connect(get_tree().reload_current_scene.call_deferred)

func toggle_player_control(is_active: bool) -> void:
	set_physics_process(is_active)
	_avatar.set_physics_process(is_active)
	_weapon_pivot.set_process(is_active)
	#base_weapon.set_physics_process(is_active)
