extends RigidBody3D

var geometry3d: MeshInstance3D
var material: BaseMaterial3D
var build_blocked: bool = false
var default_material
@export var allowed_material: BaseMaterial3D
@export var denied_material: BaseMaterial3D

## IDEAS
# Building process here

enum BuildingStatus {
	NONE,
 	INPROGRESS,
 	COMPLETE
}

var current_status: BuildingStatus = BuildingStatus.NONE

# Called when the node enters the scene tree for the first time.
func _ready():
	geometry3d = get_node("MeshInstance3D")
	default_material = geometry3d.get_active_material(0)
	geometry3d.material_override = allowed_material
	contact_monitor = true
	max_contacts_reported = 1
	body_entered.connect(on_collision)
	body_exited.connect(on_leave_collision)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_status == BuildingStatus.NONE:
		if get_contact_count() != 0 && build_blocked == false:
			print("BUILD_BLOCKED")
			build_blocked = true
			geometry3d.material_override = denied_material

		if get_contact_count() == 0 && build_blocked == true:
			build_blocked = false
			geometry3d.material_override = allowed_material

func start_building():
	current_status = BuildingStatus.INPROGRESS
	geometry3d.material_override = default_material
	position.y += 2
	enable_physics()

func complete_building():
	current_status = BuildingStatus.COMPLETE
	
func can_build():
	return get_contact_count() == 0

func enable_physics():
	axis_lock_linear_x = false
	axis_lock_linear_y = false
	axis_lock_linear_z = false
	set_collision_layer_value(1, true)
	set_collision_mask_value(1, true)

func on_collision(body):
	# TODO: Change material to something red?
	print("Collision: ", body)

func on_leave_collision(body):
	print("Leave Collision: ", body)

