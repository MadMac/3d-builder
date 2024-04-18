extends Control

var ui
@export var game_engine: Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	ui = get_parent()
	var closeButton = get_node("CloseButton")
	closeButton.pressed.connect(ui.buildings_button_clicked)
	var houseButton = get_node("HouseButton")
	houseButton.pressed.connect(building_selected)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func building_selected():
	game_engine.start_building_mode()
	ui.buildings_button_clicked()
