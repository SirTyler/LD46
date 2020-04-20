extends Node

onready var HEALTH = 4 setget set_health
onready var HEALTH_MAX = 4

signal health_change()

func set_health(value : int):
	HEALTH = value
	emit_signal("health_change")
