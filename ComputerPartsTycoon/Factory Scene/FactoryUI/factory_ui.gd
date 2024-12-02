extends Control

var selected_tab = "None"
var selected_item = -1
var mouse_inside_tab = false

func _ready():
	# Get everything in that group and add a signal to make sure build doesn't happen when mouse is over it.
	var boxes = get_tree().get_nodes_in_group("CheckForMouseCovering")
	for box in boxes:  
		box.connect("mouse_entered", _on_tab_mouse_entered)
		box.connect("mouse_exited", _on_tab_mouse_exited)

func hide_all_build_tabs():
	$BuildTabs/FactoryTab.hide()
	$BuildTabs/UpgradesTab.hide()
	$BuildTabs/SellingTab.hide()
	$BuildTabs/ConveryersTab.hide()
	
	$BuildTabs/FactoryTab.deselect_all()
	$BuildTabs/UpgradesTab.deselect_all()
	$BuildTabs/SellingTab.deselect_all()
	$BuildTabs/ConveryersTab.deselect_all()
	
	selected_tab = "None"
	selected_item = -1


# Control opening and closing build tabs and control the Selected_tab variable
func _on_factory_toggle_pressed():
	if $BuildTabs/FactoryTab.visible == false:
		hide_all_build_tabs()
		$BuildTabs/FactoryTab.show()
		selected_tab = "Factory"
	else:
		hide_all_build_tabs()
func _on_upgrade_toggle_pressed():
	if $BuildTabs/UpgradesTab.visible == false:
		hide_all_build_tabs()
		$BuildTabs/UpgradesTab.show()
		selected_tab = "Upgrade"
	else:
		hide_all_build_tabs()
func _on_sell_toggle_pressed():
	if $BuildTabs/SellingTab.visible == false:
		hide_all_build_tabs()
		$BuildTabs/SellingTab.show()
		selected_tab = "Selling"
	else:
		hide_all_build_tabs()
func _on_conveyer_toggle_pressed():
	if $BuildTabs/ConveryersTab.visible == false:
		hide_all_build_tabs()
		$BuildTabs/ConveryersTab.show()
		selected_tab = "Conveyor"
	else:
		hide_all_build_tabs()

# Set the index to the item clicked in a tab
func _on_tab_item_clicked(index, at_position, mouse_button_index):
	selected_item = index


# Check if mouse is inside Build tab so it doesnt build or display
func _on_tab_mouse_entered():
	Global.mouse_inside_tab = true

func _on_tab_mouse_exited():
	Global.mouse_inside_tab = false
