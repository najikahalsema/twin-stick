extends Node2D

@onready var _invisible_walls: TileMapLayer = %InvisibleWalls
@onready var _end_menu: Control = %EndMenu
@onready var _teleporter: Area2D = %Teleporter
@onready var game: Node2D = $"."

func _ready() -> void:
	_teleporter.body_entered.connect(func (body: Node) -> void:
		if body is Player:
			body.toggle_player_control(false)
			_end_menu.open()
	)
	_invisible_walls.hide()
