extends Camera2D

var is_zooming = 0


func _process(_delta):
	if is_zooming > 0:
		set_zoom(get_zoom() / 0.95)
		is_zooming = is_zooming - 1
	elif is_zooming < 0:
		set_zoom(get_zoom() * 0.95)
		is_zooming = is_zooming + 1

func zoom_out():
	if get_zoom().x < 2:
		is_zooming = is_zooming + 2
func zoom_in():
	if get_zoom().x > 0.25:
		is_zooming = is_zooming - 2
func move_up():
	if offset.y > -1500:
		offset.y = offset.y - (9 / get_zoom().x)
func move_down():
	if offset.y < 1500:
		offset.y = offset.y + (9 / get_zoom().x)
func move_left():
	if offset.x > -3000:
		offset.x = offset.x - (9 / get_zoom().x)
func move_right():
	if offset.x < 3000:
		offset.x = offset.x + (9 / get_zoom().x)

func get_camera_coors():
	return get_global_mouse_position()
	
