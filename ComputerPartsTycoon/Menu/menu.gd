extends Control


func _on_enter_pressed():
	get_tree().change_scene_to_file("res://Factory Scene/Factory.tscn")

func _on_load_pressed():
	get_tree().change_scene_to_file("res://WorldPicker/WorldPick.tscn")

func _on_settings_pressed():
	pass
