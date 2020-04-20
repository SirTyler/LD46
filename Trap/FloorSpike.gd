extends Node2D

export(int) var timer_length = 1

onready var timer = $Timer
onready var animTree = $AnimationTree
onready var animState = animTree.get("parameters/playback")

func _ready():
	timer.set_wait_time(timer_length)
	timer.start()

func _on_timeout():
	animState.travel("trigger")
	timer.start()
