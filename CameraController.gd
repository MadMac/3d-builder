extends Camera3D

var MOVEMENT_SCROLL_SPEED = 0.05;
var isRightButtonDown: bool = false;
var oldCursorPosition: Vector2;

var cameraTween
var cameraZoon

var MAX_ZOOM: int = 30
var MIN_ZOOM: int = 10
var ZOOM_INCREMENT: int = 2

var mouseCursor = load("res://icons8-cursor-24.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_custom_mouse_cursor(mouseCursor)
	cameraZoon = position.y


func _input(event):
	if event is InputEventMouseButton && event.button_index == 2:
		if isRightButtonDown && !event.pressed:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			Input.warp_mouse(oldCursorPosition)
		if !isRightButtonDown && event.pressed:
			oldCursorPosition = event.position
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		isRightButtonDown = event.pressed;
		
		
	if event is InputEventMouseMotion && isRightButtonDown:
		position.x += event.relative.x * MOVEMENT_SCROLL_SPEED;
		position.z += event.relative.y * MOVEMENT_SCROLL_SPEED;
		
	# Mouse scroll zoom
	
	if event.is_action_pressed("scroll_in"):
		cameraZoon = max(cameraZoon-ZOOM_INCREMENT, MIN_ZOOM)
		ZoomTween(cameraZoon)
	
	if event.is_action_pressed("scroll_out"):
		cameraZoon = min(cameraZoon+ZOOM_INCREMENT, MAX_ZOOM)
		ZoomTween(cameraZoon)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func ZoomTween(zoom: int) -> void:
	if cameraTween: 
		cameraTween.kill()
	
	cameraTween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	cameraTween.tween_property(self, "position:y", zoom, 1)
