class_name player
extends CharacterBody3D

const gravity = 14
const SPEED = 5.0
const JUMP_VELOCITY = 5.5
const SENSITIVITY = 0.1
@onready var head = $Head
@onready var fps_camera = $Head/FpsCamera
@onready var tps_camera = $SpringArm3D/TpsCamera
@onready var spring = $SpringArm3D

var camera_mode_is_fps = false
@export var is_beast = false
const Computer = preload("res://scripts/computer.gd")
signal interact_pressed

func _ready():
	self.rotation = Vector3.ZERO
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if is_beast == camera_mode_is_fps: switch_pov()

func handle_camera_movement(event):
	if camera_mode_is_fps:
		head.rotate_y(deg_to_rad(-event.relative.x * SENSITIVITY))
		fps_camera.rotate_x(deg_to_rad(-event.relative.y * SENSITIVITY))
		fps_camera.rotation.x = clamp(fps_camera.rotation.x, -PI / 2, PI / 2)
	else:
		self.rotate_y(deg_to_rad(-event.relative.x * SENSITIVITY))
		spring.rotate_x(deg_to_rad(-event.relative.y * SENSITIVITY))
		spring.rotation.x = clamp(spring.rotation.x, deg_to_rad(-90), deg_to_rad(30))

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if event is InputEventMouseMotion:
		handle_camera_movement(event)
	if Input.is_action_just_pressed("ability"):
		pass
	if Input.is_action_just_pressed("interact"):
		interact_pressed.emit()
	if Input.is_action_just_pressed("switch_pov"):
		switch_pov()

func switch_pov():
	if camera_mode_is_fps:
		switch_cameras(tps_camera, fps_camera)
		spring.rotation.x = fps_camera.rotation.x
		self.rotation.y = head.rotation.y
		fps_camera.rotation = Vector3.ZERO
		head.rotation = Vector3.ZERO
	else:
		switch_cameras(fps_camera, tps_camera)
		fps_camera.rotation.x = spring.rotation.x
		head.rotation.y = self.rotation.y
		self.rotation = Vector3.ZERO
		spring.rotation = Vector3.ZERO

func switch_cameras(to_camera, from_camera):
	from_camera.current = false
	to_camera.current = true
	camera_mode_is_fps = not camera_mode_is_fps

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction
	if camera_mode_is_fps:
		direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	else:
		direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()
