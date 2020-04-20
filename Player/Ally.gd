extends RigidBody2D

signal ally_death(Ally)

func _ready():
	pass # Replace with function body.


func _on_area_entered(_area):
	emit_signal("ally_death", self)
