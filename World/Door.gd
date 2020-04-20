extends Area2D

export(String) var scene_to_change_path
export(bool) var traversable = false


func _on_area_entered(_area):
	if traversable: SceneChanger.change_scene(scene_to_change_path)
