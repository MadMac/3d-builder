extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var moving_target: Vector3

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var unitSelectSquare
var worldCamera: Camera3D

func _ready():
	unitSelectSquare = get_node("SelectUnit")
	worldCamera = get_node("/root/WorldMap/Camera")
	unitSelectSquare.visible = false

func _process(delta):
	var unitPosInCamera = worldCamera.unproject_position(global_transform.origin)
	var meshInstance: VisualInstance3D = get_node("MeshInstance3D")
	var aabb = get_screen_space_aabb(worldCamera, meshInstance)
	aabb.position.x -= 5
	aabb.position.y -= 5
	aabb.size.x += 10
	aabb.size.y += 10
	unitSelectSquare.position = aabb.position
	unitSelectSquare.size = aabb.size

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	var normal_to_target = (moving_target - position).normalized()
	if normal_to_target:
		velocity.x = normal_to_target.x * SPEED
		velocity.z = normal_to_target.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	rotation.y = atan2(velocity.x, velocity.z)

	move_and_slide()

func set_moving_target(target):
	print("New moving target: " + str(target))
	moving_target = target
	
func enable_unit_selector():
	unitSelectSquare.visible = true
	
func disable_unit_selector():
	unitSelectSquare.visible = false

func get_screen_space_aabb(camera: Camera3D, object: VisualInstance3D) -> Rect2:
	var aabb = object.get_aabb()
	var min_screen = camera.unproject_position(object.global_transform * aabb.position)
	var max_screen = min_screen

	# Manually calculate the corners of the AABB
	for i in range(8):
		var corner = aabb.position + Vector3(
			(i & 1) * aabb.size.x,
			((i >> 1) & 1) * aabb.size.y,
			((i >> 2) & 1) * aabb.size.z
		)
		var screen_pos = camera.unproject_position(object.global_transform * corner)
		
		min_screen.x = min(min_screen.x, screen_pos.x)
		min_screen.y = min(min_screen.y, screen_pos.y)
		max_screen.x = max(max_screen.x, screen_pos.x)
		max_screen.y = max(max_screen.y, screen_pos.y)

	return Rect2(min_screen, max_screen - min_screen)
