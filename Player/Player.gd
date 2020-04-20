extends Actor

export var JUMP_SPEED = 100
export var JUMP_HEIGHT = 100

var extra_button_frame_max = 20
var extra_button_frame = 0

var extra_frame_max = 20
var extra_frame = 0
var ally = null
var first_link = null
var is_in_transition = false
var just_transitioned = false
var after_transition_count = 0
var after_transition_count_max = 20
var is_dead = false

onready var dir = direction()
onready var camera = $Position2D/Camera2D
onready var animTree = $AnimationTree
onready var animState = animTree.get("parameters/playback")

signal transition_start
signal transition_end

func _physics_process(delta):
	if !is_in_transition and !is_dead:
		if Input.is_action_just_pressed("secondary"):
			print(position)
			ally.apply_central_impulse(Vector2(100, 100))
		
		var is_jump_interrupted = Input.is_action_just_released("jump") and vel.y < 0
		if is_jump_interrupted:
			extra_button_frame_max = 0
		if extra_frame < extra_frame_max:
			dir = direction()
		vel = calc_velocity(vel, dir, is_jump_interrupted)
		var snap: Vector2 = Vector2.DOWN * 60.0 if dir.y == 0 else Vector2.ZERO
		if dir.x != 0:
			animTree.set("parameters/walk/blend_position", dir.x)
			animTree.set("parameters/idle/blend_position", dir.x)
			vel = move_and_slide_with_snap(vel, snap, FLOOR_NORMAL, true)
			animState.travel("walk")
		else:
			vel.x = (vel.move_toward(Vector2.ZERO, FRICTION * delta)).x
			vel = move_and_slide_with_snap(vel, snap, FLOOR_NORMAL, true)
			animState.travel("idle")
	elif is_dead:
		pass

func begin_transition():
	emit_signal("transition_start")
	is_in_transition = true
	pass

func end_transition():
	emit_signal("transition_end")
	is_in_transition = false
	pass

func direction() -> Vector2:
	extra_button_frame += 1
	return Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		-Input.get_action_strength("jump") if is_on_floor() or extra_button_frame < extra_button_frame_max and Input.is_action_just_pressed("jump") else 0.0
	)

func calc_velocity(
	linear: Vector2,
	direction: Vector2,
	is_jump_interrupted: bool
) -> Vector2:
	var vel = linear
	vel.x = clamp(ACCELERATION * direction.x, -MAX_SPEED, MAX_SPEED)
	if direction.y < 0:
		vel.y = clamp(JUMP_SPEED * direction.y, -JUMP_HEIGHT, 0)
	elif direction.y != 0:
		vel.y = clamp(GRAVITY * direction.y, -JUMP_HEIGHT, 0)
		
	if is_jump_interrupted:
		vel.y = 0.0
		extra_frame = 0
		
	if vel.y < 0:
		extra_frame += 1
		
	if is_on_floor() or is_on_wall():
		extra_frame = 0	
	return vel
	
func on_ally_death(_ally):
	if is_dead: pass
	Globals.HEALTH -= 1
	print("HP:",Globals.HEALTH)
	if Globals.HEALTH <= 0:
		is_dead = true
		print("dead")

func _add_ally(_ally):
	ally = _ally
	first_link = $PlayerChain/Anchor.get_node("Link").get_node("Sprite")
	ally.connect("ally_death", self, "on_ally_death")
