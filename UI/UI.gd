extends Node2D

onready var sprite = $AnimatedSprite

func _ready():
	Globals.connect("health_change", self, "health_update")

func health_update():
	var hp = Globals.HEALTH
	var frame = clamp(4 - hp, 0, 4)
	sprite.frame = frame
