extends Node3D

var player_materials: Dictionary = {"wood": 1000, "stone": 1000}

var buildable_buildings: Dictionary = {
	"house" = {
		"wood": 100,
		"stone": 100,
		"object": "res://house_object.tscn"
	},
	"quarry" = {
		"wood": 50,
		"stone": 50,
		"object": "res://quarry_object.tscn"
	},
	"lumberjack" = {
		"wood": 25,
		"stone": 0,
		"object": "res://lumberjack_object.tscn"
	}
}

@export var camera: Camera3D
const RAY_LENGTH = 1000

@export var UI: Control

var playerUnits: Array = []

# Tracks which units are selected
var selectedUnits: Array = []
var rightMouseButtonTimer: Timer
var mouse_dragging: bool = false
var mouse_drag_init: Vector3
var unitSelector

var playerBuildings: Array = []

var is_building_mode: bool = false
var building_object: RigidBody3D = null
var building_item = null



# Called when the node enters the scene tree for the first time.
func _ready():
	rightMouseButtonTimer = Timer.new()
	rightMouseButtonTimer.one_shot = true
	rightMouseButtonTimer.autostart = false
	rightMouseButtonTimer.wait_time = 0.5	
	unitSelector = get_node("UnitSelector")
	add_child(rightMouseButtonTimer)
	update_ui()
	
	generate_initial_units()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if mouse_dragging:
		unitSelector.visible = true
		var unprojected_init_coord = camera.unproject_position(mouse_drag_init)
		var mousepos = camera.get_current_mouse_pos()
		unitSelector.set_coords(unprojected_init_coord, mousepos)
	else: 
		unitSelector.visible = false

func _input(event):
	
	# Timter checks how long right button is pressed
	# so that units are only moved with quick clicks
	if event.is_action_pressed("mouse_right_button"):
		rightMouseButtonTimer.wait_time = 0.5
		rightMouseButtonTimer.start()
	
	# UNIT SELECTION
	if !is_building_mode:
		if event is InputEventMouseButton && event.button_index == 1:
				if event.is_pressed():
					mouse_dragging = true
					var mouse_pos = get_mouse_to_world(event.position)
					mouse_drag_init = mouse_pos.position
					var unprojected_init_coord = camera.unproject_position(mouse_drag_init)
					unitSelector.set_coords(unprojected_init_coord, unprojected_init_coord)
					
				if event.is_released():
					var mouse_pos = get_mouse_to_world(event.position)
					selectedUnits.clear()
					if selectedUnits.size() > 0:
							for unit in selectedUnits:
								unit.disable_unit_selector()
					if mouse_dragging: 
						mouse_dragging = false
						for playerUnit in playerUnits:
							var playerUnitCharacter = playerUnit
							playerUnitCharacter.disable_unit_selector()
							var unitPosInCamera = camera.unproject_position(playerUnit.position)
							if is_point_in_square(camera.unproject_position(mouse_drag_init), camera.get_current_mouse_pos(), unitPosInCamera):
								selectedUnits.append(playerUnitCharacter)
								playerUnitCharacter.enable_unit_selector()
					print("Selectedunits: ", selectedUnits)
					
					if playerUnits.has(mouse_pos.collider):
						if selectedUnits.has(mouse_pos.collider):
							print("Object already in array")
						else:
							selectedUnits.append(mouse_pos.collider)
							mouse_pos.collider.enable_unit_selector()
						
		# UNIT MOVEMENT
		elif event.is_action_released("mouse_right_button") && !rightMouseButtonTimer.is_stopped():
			for unit in selectedUnits:
				var mouse_pos = get_mouse_to_world(event.position)
				unit.set_moving_target(mouse_pos.position)
	
	if is_building_mode:
		var mouse_pos = get_mouse_to_world(camera.get_current_mouse_pos())
		mouse_pos.position = Vector3(mouse_pos.position.x, 2, mouse_pos.position.z)
		building_object.position = mouse_pos.position
		if event is InputEventMouseButton && event.button_index == 1 && building_object.can_build():
			build_building()

func get_mouse_to_world(pos):
	var from = camera.project_ray_origin(pos)
	var to = from + camera.project_ray_normal(pos) * RAY_LENGTH
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	return space_state.intersect_ray(query)

func is_point_in_square(square_top_left: Vector2, square_bottom_right: Vector2, point: Vector2) -> bool:
	var square_left = square_top_left.x if square_top_left.x <= square_bottom_right.x else square_bottom_right.x
	var square_right = square_bottom_right.x if square_top_left.x <= square_bottom_right.x else square_top_left.x
	var square_top = square_top_left.y if square_top_left.y <= square_bottom_right.y else square_bottom_right.y
	var square_bottom = square_bottom_right.y if square_top_left.y <= square_bottom_right.y else square_top_left.y

	# Check if the point is within the square's boundaries
	if point.x >= square_left && point.x <= square_right && point.y >= square_top && point.y <= square_bottom:
		return true
	else:
		return false

func generate_initial_units(): 
	for n in 50:
		var pawnScene = load("res://pawn.tscn")
		var instance = pawnScene.instantiate()
		instance.position = Vector3(randf_range(-40, 40), 5, randf_range(-30, 30))
		add_child(instance)
		playerUnits.append(instance)
		
func start_building_mode(building):
	is_building_mode = true
	var buildingObject = load(buildable_buildings[building]["object"])
	building_object = buildingObject.instantiate()
	add_child(building_object)
	building_item = building
	
	
func is_enough_materials_building(building):
	if (buildable_buildings[building]["wood"] <= player_materials["wood"] && buildable_buildings[building]["stone"] <= player_materials["stone"]):
		return true;
	else:
		print("Not enough resources")
		return false;
		
func update_ui():
	UI.update_wood_value(player_materials["wood"]);
	UI.update_stone_value(player_materials["stone"])
	
func build_building():
	is_building_mode = false
	building_object.get_node("CollisionShape3D").disabled = false
	building_object.gravity_scale = 1
	building_object.start_building()
	building_object = null
	
	player_materials["wood"] -= buildable_buildings[building_item]["wood"]
	player_materials["stone"] -= buildable_buildings[building_item]["stone"]
	update_ui()
