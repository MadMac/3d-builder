extends RigidBody3D

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
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start_building():
	current_status = BuildingStatus.INPROGRESS

func complete_building():
	current_status = BuildingStatus.COMPLETE
