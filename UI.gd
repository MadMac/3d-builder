extends Control

var buildingsButton
var buildingsMenu

# Called when the node enters the scene tree for the first time.
func _ready():
	buildingsButton = get_node("BuildingsButton")
	buildingsMenu = get_node("BuildingsMenu")
	buildingsButton.pressed.connect(self.buildings_button_clicked)
	
	buildingsMenu.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func buildings_button_clicked(): 
	if !buildingsMenu.visible:
		buildingsMenu.visible = true
		print("Open buildings menu")
	else: 
		buildingsMenu.visible = false

