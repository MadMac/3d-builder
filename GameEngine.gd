extends Node3D

@export var camera: Camera3D
const RAY_LENGTH = 1000

# Tracks which units are selected
var selectedUnits: Array = []
var rightMouseButtonTimer: Timer
var mouse_dragging: bool = false
var mouse_drag_init: Vector2
var unitSelector

# Called when the node enters the scene tree for the first time.
func _ready():
	rightMouseButtonTimer = Timer.new()
	rightMouseButtonTimer.one_shot = true
	rightMouseButtonTimer.autostart = false
	rightMouseButtonTimer.wait_time = 0.5	
	unitSelector = get_node("UnitSelector")
	add_child(rightMouseButtonTimer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if mouse_dragging:
		unitSelector.visible = true
		var mousepos = get_viewport().get_mouse_position()
		unitSelector.set_coords(mouse_drag_init, mousepos)
	else: 
		unitSelector.visible = false

func _input(event):
	
	# Timter checks how long right button is pressed
	# so that units are only moved with quick clicks
	if event.is_action_pressed("mouse_right_button"):
		rightMouseButtonTimer.wait_time = 0.5
		rightMouseButtonTimer.start()
	
	# UNIT SELECTION
	if event is InputEventMouseButton && event.button_index == 1:
		if event.is_pressed():
			mouse_dragging = true
			mouse_drag_init = event.position
			unitSelector.set_coords(mouse_drag_init, mouse_drag_init)
			
		if event.is_released():
			var mouse_pos = get_mouse_to_world(event)
			print(mouse_pos.collider.name)
			mouse_dragging = false
			if mouse_pos.collider.name == "PawnCharacter":
				if selectedUnits.has(mouse_pos.collider):
					print("Object already in array")
				else:
					selectedUnits.append(mouse_pos.collider)
					mouse_pos.collider.enable_unit_selector()
			else:
				if selectedUnits.size() > 0:
					for unit in selectedUnits:
						unit.disable_unit_selector()
					selectedUnits.clear()
				print(mouse_pos.collider)
				
			print(selectedUnits)
	# UNIT MOVEMENT
	elif event.is_action_released("mouse_right_button") && !rightMouseButtonTimer.is_stopped():
		for unit in selectedUnits:
			var mouse_pos = get_mouse_to_world(event)
			unit.set_moving_target(mouse_pos.position)

func get_mouse_to_world(event):
	var from = camera.project_ray_origin(event.position)
	var to = from + camera.project_ray_normal(event.position) * RAY_LENGTH
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	return space_state.intersect_ray(query)
