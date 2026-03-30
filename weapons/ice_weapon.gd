extends Weapon

@export var base_damage := 2
var charge_time := 0.0
@onready var _gpu_particles_2d: GPUParticles2D = %GPUParticles2D
@onready var _animation_player: AnimationPlayer = %AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bullet_scene = preload("uid://6mtedr4ilexb")
	shoot_sound = %ShootSound
	
func _physics_process(delta):
	if Input.is_action_just_pressed("shoot"):
		_animation_player.play("charge")

	if Input.is_action_pressed("shoot"):
		charge_time += delta
		charge_time = min(charge_time, 1.5)
	elif Input.is_action_just_released("shoot"):
		shoot()
		_gpu_particles_2d.emitting = false
		charge_time = 0.0


func shoot() -> void:
	var bullet: Node = bullet_scene.instantiate()
	get_tree().root.add_child(bullet)

	bullet.global_transform = global_transform
	bullet.max_range = max_range
	bullet.speed = max_bullet_speed
	bullet.damage = floor(base_damage * (1.0 + charge_time))
	bullet.scale = Vector2.ONE * (1.0 + charge_time)
	
	if shoot_sound != null:
		shoot_sound.play()
