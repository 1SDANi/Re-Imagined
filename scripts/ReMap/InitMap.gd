extends Node3D

@export var primaries : Array[String]
@export var secondaries : Array[String]

@export var initial_primary : String
@export var initial_secondary : String

func _ready() -> void:
	game.map.primaries = primaries
	game.map.secondaries = secondaries

	game.map.primary = initial_primary
	game.map.secondary = initial_secondary
