extends Node3D

@export var camera: Camera3D
const RAY_LENGTH = 1000

# Tracks which units are selected
var selectedUnits: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	# UNIT SELECTION
	if event is InputEventMouseButton && event.button_index == 1:
		if event.pressed:
			var mouse_pos = get_mouse_to_world(event)
			print(mouse_pos.collider.name)
			if mouse_pos.collider.name == "PawnCharacter":
				if selectedUnits.has(mouse_pos.collider):
					print("Object already in array")
				else:
					selectedUnits.append(mouse_pos.collider)
			else:
				if selectedUnits.size() > 0:
					selectedUnits.clear()
				print(mouse_pos.collider)
				
			print(selectedUnits)
	# UNIT MOVEMENT
	elif event is InputEventMouseButton && event.button_index == 2:
		if event.pressed:
			for unit in selectedUnits:
				var mouse_pos = get_mouse_to_world(event)
				unit.set_moving_target(mouse_pos.position)

func get_mouse_to_world(event):
	var from = camera.project_ray_origin(event.position)
	var to = from + camera.project_ray_normal(event.position) * RAY_LENGTH
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	return space_state.intersect_ray(query)
