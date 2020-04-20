extends Node2D

export(int) var delay = 10
export(int) var speed = 0

onready var point = $Position2D
onready var control = $Control

var cur_delay = 0
var move_delay = 0
var move_to_point = true

func _physics_process(_delta):
	var vel = Vector2.ZERO
	cur_delay += 1
	if cur_delay > delay:
		move_delay += 1
		if(move_delay > speed):
			if(move_to_point):
				if(control.position != point.position):
					vel = point.position - control.position
					vel = vel.normalized()
				else:
					move_to_point = !move_to_point
					vel = Vector2.ZERO
					cur_delay = 0
			else:
				if(control.position != Vector2.ZERO):
					vel = Vector2.ZERO - control.position
					vel = vel.normalized()
				else:
					move_to_point = !move_to_point
					vel = Vector2.ZERO
					cur_delay = 0
			control.position.x = control.position.x + vel.x
			control.position.y = control.position.y + vel.y
			move_delay = 0
