extends Control

var ui
@export var game_engine: Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	ui = get_parent()
	var closeButton = get_node("CloseButton")
	closeButton.pressed.connect(ui.buildings_button_clicked)
	var houseButton = get_node("HouseButton")
	houseButton.pressed.connect(building_selected.bind("house"))
	var quarryButton = get_node("QuarryButton")
	quarryButton.pressed.connect(building_selected.bind("quarry"))
	var lumberjackButton = get_node("LumberjackButton")
	lumberjackButton.pressed.connect(building_selected.bind("lumberjack"))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func building_selected(building):
	print("Start building: ", building)
	if game_engine.is_enough_materials_building(building):
		game_engine.start_building_mode(building)
		ui.buildings_button_clicked()
