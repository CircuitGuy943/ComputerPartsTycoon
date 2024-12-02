extends Control

var original_image : Image
var edited_image : Image
var image_texture : CompressedTexture2D
var edited_texture : ImageTexture

var old_country = ""
var new_country = ""
var height
var width
var is_selected = false



func _on_button_pressed():
	get_tree().change_scene_to_file("res://Factory Scene/Factory.tscn")

func _ready():
	image_texture = load("res://WorldPicker/MapWithNoNames.png")
	original_image = image_texture.get_image()
	edited_image = image_texture.get_image()
	edited_texture = ImageTexture.create_from_image(edited_image)
	$WorldMap.texture = edited_texture
	height = original_image.get_height()
	width = original_image.get_width()
	
	for child in $WorldMap.get_children():
		for second_child : ReferenceRect in child.get_children():
			second_child.position = second_child.position / 1.05
	
func bound_boxes_visibilty(value : bool):
	for child in $WorldMap.get_children():
		for second_child : ReferenceRect in child.get_children():
			second_child.editor_only = not value
			child.visible = value

func _process(_delta):
	var text_value = get_country_behind_mouse()
	if Input.is_action_just_pressed("mouse_left_click"):
		if text_value != "":
			$CountryInformation/Name.text = "Name: " + text_value
			update_info_values(text_value)

func get_country_behind_mouse():
	old_country = new_country
	var map_mouse_pos = get_global_mouse_position()
	if map_mouse_pos.x > 0 and width > map_mouse_pos.x and map_mouse_pos.y > 0 and height > map_mouse_pos.y:
		var mouse_pixel_color = original_image.get_pixelv(Vector2i(map_mouse_pos))     
		
		if mouse_pixel_color in Global.value_to_colors: 
			var color = Global.value_to_colors[mouse_pixel_color]
			
			for country in get_node(NodePath("WorldMap/" + str(color))).get_children():
				var box_rect = Rect2(country.position, country.size)
				
				if box_rect.has_point(map_mouse_pos) == true:
					
					var real_name
					if "#" in country.name:
						real_name = country.name.left(-3)
					else:
						real_name = country.name
					
					new_country = real_name
					if new_country != old_country:
						edited_image.copy_from(original_image)
						for second_country_check in get_node(NodePath("WorldMap/" + str(color))).get_children():
							if real_name in second_country_check.name:
								draw_country_border(second_country_check, color)
						
						
						
					return real_name
		elif mouse_pixel_color not in Global.value_to_colors:
			edited_texture.update(edited_image)
			edited_texture.emit_changed()
			
			new_country = "NO COUNTRY"
			return ""

func draw_country_border(country : Node, color : String):
	for pixel_x in country.size.x:
		for pixel_y in country.size.y:
			
			var border_pixel_location = Vector2i(pixel_x + country.position.x, pixel_y + country.position.y)
			var border_pixel_color = original_image.get_pixelv(border_pixel_location)
			var border_adjacent_pixels = [original_image.get_pixel(border_pixel_location.x, border_pixel_location.y - 1),    # Above
										  original_image.get_pixel(border_pixel_location.x + 1, border_pixel_location.y),    # Right
										  original_image.get_pixel(border_pixel_location.x, border_pixel_location.y + 1),    # Below
										  original_image.get_pixel(border_pixel_location.x - 1, border_pixel_location.y)]    # Left
			
			if border_pixel_color not in Global.value_to_colors:
				if Global.colors_to_value[color] in border_adjacent_pixels:
					edited_image.set_pixelv(border_pixel_location, Color.BLACK)
	edited_texture.update(edited_image)
	edited_texture.emit_changed()

func update_info_values(country_name : String):
	
	if country_name.length() <= 15:
		$CountryInformation/Name.text = country_name
		$CountryInformation/Name.add_theme_font_size_override("font_size", 40)
	elif country_name.length() > 15:
		$CountryInformation/Name.add_theme_font_size_override("font_size", 30)
		$CountryInformation/Name.text = country_name
	elif country_name.length() > 35:
		$CountryInformation/Name.add_theme_font_size_override("font_size", 20)
		$CountryInformation/Name.text = country_name
		
	for information : Label in $CountryInformation/InfoDisplay.get_children():
		if information.name == "Population":
			information.text = humanize_number(Global.country_data[country_name][0])
		if information.name == "PopGrowthRate":
			information.text = str(Global.country_data[country_name][1]) + "%"
		if information.name == "BirthRate":
			information.text = str(Global.country_data[country_name][2])
		if information.name == "MedianAge":
			information.text = str(Global.country_data[country_name][3])
		if information.name == "Urbanization":
			information.text = str(Global.country_data[country_name][4]) + "%"
		if information.name == "GdpPerCapita":
			information.text = humanize_number(str(Global.country_data[country_name][5]))
		if information.name == "Classification":
			information.text = str(Global.country_data[country_name][6])
		if information.name == "InflationRate":
			information.text = str(Global.country_data[country_name][7]) + "%"
		if information.name == "Unemployment":
			information.text = str(Global.country_data[country_name][8]) + "%"
		if information.name == "TradeBalance":
			information.text = str(Global.country_data[country_name][9]) + "B"
		if information.name == "NationalDebt":
			information.text = humanize_number(Global.country_data[country_name][10] * 1000000000)

func humanize_number(unrefined):
	var number = float(unrefined)
	if (number >= 1000.0) and (number < 1000000.0):
		number = number / 1000.0
		number = round_to_dec(number, 2)
		return number + "K"
	elif (number >= 1000000.0) and (number < 1000000000.0):
		number = number / 1000000.0
		number = round_to_dec(number, 2)
		return number + "M"
	elif (number >= 1000000000.0) and (number < 1000000000000.0):
		number = number / 1000000000.0
		number = round_to_dec(number, 2)
		return number + "B"
	elif number >= 1000000000000.0:
		number = number / 1000000000000.0
		number = round_to_dec(number, 2)
		return number + "T"
	else:
		return str(number)
func round_to_dec(num, digit):
	return str(round(num * pow(10.0, digit)) / pow(10.0, digit))
