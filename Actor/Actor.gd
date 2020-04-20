extends KinematicBody2D
class_name Actor

const FLOOR_NORMAL = Vector2.UP

export var FRICTION = 200
export var ACCELERATION = 200
export var MAX_SPEED = 100
export var GRAVITY = 3500

var vel = Vector2.ZERO

func _physics_process(delta):
	vel.y += GRAVITY * delta
