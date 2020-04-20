extends Area2D

export var transition_from_x = 0.0
export var transition_from_y = 0.0
export var transition_to_x = 0.0
export var transition_to_y = 0.0
export var camera_bounds = [0,0,0,0]

var player = null setget set_player
var stored_position = null

func set_player(_player):
	player = _player


func _on_area_entered(_area):
	player.begin_transition()
	stored_position = player.camera.position
	
	var cam_current = Vector2(
		transition_from_x,
		transition_from_y
	)
	var cam_next = Vector2(
		transition_to_x - transition_from_x, 
		transition_to_y - transition_from_y
	)
	
	var tween = Tween.new()
	player.camera.add_child(tween)
	tween.interpolate_property(
		player.camera, "position",
		cam_current, cam_next, 2,
		Tween.TRANS_QUAD, Tween.EASE_IN_OUT
	)
	tween.connect("tween_completed", self, "tween_done")
	tween.connect("tween_started", self, "tween_start")
	tween.start()

func tween_start(_obj, _key):
	player.camera.set_enable_follow_smoothing(false)
	#player.camera.set_limit(MARGIN_BOTTOM, 10000)
	player.camera.set_limit(MARGIN_RIGHT, 10000)
	player.camera.set_limit(MARGIN_LEFT, -10000)
	#player.camera.set_limit(MARGIN_TOP, -10000)

func tween_done(_obj, _key):
	player.camera.set_enable_follow_smoothing(true)
	player.camera.set_limit(MARGIN_BOTTOM, camera_bounds[2] + transition_from_y)
	player.camera.set_limit(MARGIN_RIGHT, camera_bounds[3] + transition_from_x)
	player.camera.set_limit(MARGIN_LEFT, camera_bounds[1] + transition_from_x)
	player.camera.set_limit(MARGIN_TOP, camera_bounds[0] + transition_from_y)
	player.camera.position = stored_position
	player.end_transition()
