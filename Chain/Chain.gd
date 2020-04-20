extends Node2D

const LOOP = preload("res://Chain/Loop.tscn")
const LINK = preload("res://Chain/Link.tscn")
const ALLY = preload("res://Player/Ally.tscn")
const DUMMY = preload("res://Actor/Dummy.tscn")

export(bool) var add_ally_to_chain = false
export(bool) var add_dummy_to_chain = false
export(bool) var anchor_visible = true
export(int) var length = 1
export(Vector2) var spawn_dir = Vector2(0,1)
export(bool) var physics_on_chain = true
export(float) var to_scale = 1

signal ally_created(ally)

onready var anchor = $Anchor

func _ready():
	var parent = anchor
	for _i in range(length):
		var child = add_loop(parent)
		add_link(parent, child)
		parent = child
	if add_ally_to_chain:
		var child = add_ally(parent)
		add_link(parent, child)
	if add_dummy_to_chain:
		var child = add_dummy(parent)
		add_link(parent, child)
	$Anchor.get_child(1).visible = anchor_visible

func add_loop(parent):
	var loop = LOOP.instance();
	loop.position = parent.position
	loop.position.y += spawn_dir.y * (18 * to_scale)
	loop.position.x += spawn_dir.x * (18 * to_scale)
	loop.set_collision_layer_bit(5, physics_on_chain)
	add_child(loop)
	for i in range(loop.get_child_count()):
		var v = loop.get_child(i)
		v.set_scale(Vector2(to_scale / 2, to_scale / 2))
	return loop

func add_ally(parent):
	var ally = ALLY.instance();
	ally.position = parent.position
	ally.position.y += spawn_dir.y * (18 * to_scale)
	ally.position.x += spawn_dir.x * (18 * to_scale )
	add_child(ally)
	emit_signal("ally_created", ally)
	return ally
	
func add_dummy(parent):
	var dummy = DUMMY.instance();
	dummy.position = parent.position
	dummy.position.y += spawn_dir.y * (18 * to_scale )
	dummy.position.x += spawn_dir.x * (18 * to_scale)
	add_child(dummy)
	return dummy

func add_link(parent, child):
	var pin = LINK.instance();
	pin.node_a = parent.get_path()
	pin.node_b = child.get_path()
	parent.add_child(pin)
	for i in range(pin.get_child_count()):
		var v = pin.get_child(i)
		v.set_scale(Vector2(to_scale, to_scale))
