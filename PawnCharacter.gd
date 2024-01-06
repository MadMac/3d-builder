extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var moving_target: Vector3

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


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
