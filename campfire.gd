extends Area2D

onready var collider = $CollisionShape2D
onready var sprite = $Sprite
onready var light = $Light2D

func _on_Campfire_area_entered(_area):
	#if(!collider.disabled):
	if Globals.HEALTH < Globals.HEALTH_MAX:
		sprite.frame = 1
		collider.set_deferred("disabled", true)
		light.energy = 0
		Globals.HEALTH += 1
		print("HP:",Globals.HEALTH)
	else:
		print("Full HP:",Globals.HEALTH)
