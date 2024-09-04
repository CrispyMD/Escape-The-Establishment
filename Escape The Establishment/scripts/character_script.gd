extends CharacterBody3D

const gravity = 14
const SPEED = 5.0
const JUMP_VELOCITY = 5.5
const SENSITIVITY = 0.1
@onready var head = $Head
#FIRST PERSON
#@onready var camera = $Head/Camera3D
@onready var spring = $SpringArm3D
@onready var camera = $SpringArm3D/Camera3D



func _ready():
	self.rotation = Vector3.ZERO
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED



func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	elif event is InputEventMouseMotion:
		self.rotate_y(deg_to_rad(-event.relative.x * SENSITIVITY))
		spring.rotate_x(deg_to_rad(-event.relative.y * SENSITIVITY))
		spring.rotation.x = clamp(spring.rotation.x, deg_to_rad(-90), deg_to_rad(30))
	#FIRST PERSON
	#elif event is InputEventMouseMotion:
		#head.rotate_y(-event.relative.x * SENSITIVITY)
		#camera.rotate_x(-event.relative.y * SENSITIVITY)
		#camera.rotation.x = clamp(camera.rotation.x, -PI / 2, PI / 2)



func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	if Input.is_action_just_pressed("ability"):
		pass
	move_and_slide()
