extends Node2D

@onready var factory_grid = get_node("FactoryGrid")

var current_grid_pointer
var old_grid_pointer
var mouse_pos

var current_rotation = 0
var current_level = 0

func _ready():
	$CanvasLayer.show()  # Show the canvas layer containg the game's UI
	
	var tile_set = $FactoryGrid.tile_set
	var tile_set_atlas_source = tile_set.get_source(1)
	var texture = tile_set_atlas_source.texture
	
	var factory_tab = $CanvasLayer/UI/BuildTabs/FactoryTab
	
	factory_tab.add_item("Factory", extract_region(texture, Vector2i(Global.item_rotation["Up"] + Global.item_level["Lvl 1"], Global.item_type["Factory"])))
	factory_tab.add_item("Mega\nFactory", extract_region(texture, Vector2i(Global.item_rotation["Up"] + Global.item_level["Lvl 2"], Global.item_type["Factory"])))
	factory_tab.add_item("Ultra\nFactory", extract_region(texture, Vector2i(Global.item_rotation["Up"] + Global.item_level["Lvl 3"], Global.item_type["Factory"])))

func _process(_delta):
	current_grid_pointer = $FactoryGrid.local_to_map($FactoryGrid.get_local_mouse_position())
	Global.mouse_position_for_grid = $CanvasLayer/UI.get_global_mouse_position()
	# Camera movement script
	
	if Input.is_action_pressed("up"):
		$Camera2D.move_up()
	if Input.is_action_pressed("down"):
		$Camera2D.move_down()
	if Input.is_action_pressed("left"):
		$Camera2D.move_left()
	if Input.is_action_pressed("right"):
		$Camera2D.move_right()
	if Input.is_action_just_pressed("mouse_scroll_up") and (Global.mouse_inside_tab == false):
		$Camera2D.zoom_in()
	if Input.is_action_just_pressed("mouse_scroll_down") and (Global.mouse_inside_tab == false):
		$Camera2D.zoom_out()
	if Input.is_action_pressed("mouse_thumb_button_1"):
		skew = skew + 0.01
	if Input.is_action_pressed("mouse_thumb_button_2"):
		skew = skew - 0.01
	if Input.is_action_pressed("shift_middle_mouse"):
		skew = 0
	
	# Rotation script
	if Input.is_action_just_pressed("R key"):
		if $CanvasLayer/UI.selected_tab != "None" and $CanvasLayer/UI.selected_item != -1:
			if current_rotation < 3:
				current_rotation += 1
			else:
				current_rotation = 0
	
	
	# If build tab is open, something is selected and mouse is in "okay" areas, show what will be built in the HoverLayer.
	if ($CanvasLayer/UI.selected_tab != "None") and ($CanvasLayer/UI.selected_item != -1) and (Global.mouse_inside_tab == false) and (Global.mouse_position_for_grid.y < 980):
		$HoverLayer.set_cell(current_grid_pointer, 1, Vector2i(current_rotation, $CanvasLayer/UI.selected_item))
	if old_grid_pointer != current_grid_pointer:
		$HoverLayer.clear()               # ADD BRUSH SETTINGS AND LINE TOOL.
		
	# If build tab is open, something is selected and mouse is in "okay" areas, build or remove upon LMB or RMB respectively.
	if ($CanvasLayer/UI.selected_tab != "None") and ($CanvasLayer/UI.selected_item != -1) and (Global.mouse_inside_tab == false) and (Global.mouse_position_for_grid.y < 980):
		if Input.is_action_pressed("mouse_left_click"):
			$FactoryGrid.set_cell(current_grid_pointer, 1, Vector2i(current_rotation, $CanvasLayer/UI.selected_item))
		if Input.is_action_pressed("mouse_right_click"):
			$FactoryGrid.erase_cell(current_grid_pointer)
	old_grid_pointer = current_grid_pointer


func extract_region(original_texture: Texture2D, coordinates: Vector2i):
	var size = Vector2i(32, 32)
	var position_of_texture = coordinates * 32
	var image_for_cropping = original_texture.get_image()
	var cropped_image = image_for_cropping.get_region(Rect2i(position_of_texture, size))
	var cropped_texture = ImageTexture.create_from_image(cropped_image)
	return cropped_texture
