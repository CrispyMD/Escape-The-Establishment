extends CharacterBody3D

const gravity = 9.8
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var head = $Head

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	if Input.is_action_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.x = clamp(velocity.x, -SPEED, SPEED)
		velocity.z = direction.z * SPEED
		velocity.z = clamp(velocity.z, -SPEED, SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0, 1)
		velocity.z = move_toward(velocity.z, 0, 1)

	move_and_slide()
