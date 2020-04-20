extends Node2D

onready var chain_one = $Chain
onready var chain_two = $Chain2
onready var timer = $Timer

var rand_min = 1
var rand_max = 5
var dir = false

func _ready():
	randomize()
	timer.connect("timeout", self, "timer_done")
	timer.set_wait_time(5)
	timer.start()
	
func _process(_delta):
	if Input.is_action_just_pressed("jump"):
		SceneChanger.change_scene("res://World/Levels/Level0.tscn")
		Globals.HEALTH = Globals.HEALTH_MAX

func _new_rand_time():
	return int(rand_range(rand_min, rand_max))

func timer_done():
	var c = chain_one.get_child(clamp(chain_one.get_child_count()-_new_rand_time(), 0, chain_one.get_child_count()-1))
	if c != null:
		if dir: c.apply_impulse(c.position, Vector2(_new_rand_time(),0))
		else: c.apply_impulse(c.position, Vector2(-_new_rand_time(),0))
	dir = !dir
	c = chain_two.get_child(clamp(chain_two.get_child_count()-_new_rand_time(), 0, chain_two.get_child_count()-1))
	if c != null:
		if dir: c.apply_impulse(c.position, Vector2(_new_rand_time(),0))
		else: c.apply_impulse(c.position, Vector2(-_new_rand_time(),0))
	timer.set_wait_time(_new_rand_time())
	timer.start()
