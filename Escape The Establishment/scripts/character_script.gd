class_name player
extends CharacterBody3D

#region properties

const gravity = 14
@export var SPEED = 5.0
const JUMP_VELOCITY = 5.5
const SENSITIVITY = 0.1
@onready var head = $Head
@onready var fps_camera = $Head/FpsCamera
@onready var tps_camera = $SpringArm3D/TpsCamera
@onready var spring = $SpringArm3D

@onready var camera_mode_is_fps = false
@onready var is_beast = true
signal interact_pressed
@onready var progress_bar = $CharacterUI/ProgressBar

@export var chosen_ability : Ability
@export var ability_on_cooldown = false
@export var can_jump = true
@export var can_move = true

@onready var trap_scene: PackedScene = preload("res://scenes/trap.tscn")

#Translocator
var can_translocate = false
var can_throw_translocator = true
@onready var translocator_scene = preload("res://scenes/translocator.tscn")
var translocator_reference : RigidBody3D

#endregion

enum Ability {
	Runner,#DONE
	Trapper,#WIP - almost done?
	Ninja,
	Translocator, #this is the sombrar type portal
	Pathmaker, #this is the portal like thing you wanted pookie
	Assassin
}

func _ready():
	SPEED = 5
	self.rotation = Vector3.ZERO
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if is_beast != camera_mode_is_fps: switch_pov()
	if is_beast:
		print("aaa")
		$CharacterUI.display_ability(chosen_ability)

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
		handle_abilities()
	if Input.is_action_just_pressed("interact"):
		interact_pressed.emit(self)
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

func handle_abilities():
	if ability_on_cooldown or not is_beast: return
	
	match chosen_ability:
		player.Ability.Runner:
			$BeastAbilityAnimationPlayer.play("runner_ability_timer")
		player.Ability.Trapper:
			$BeastAbilityAnimationPlayer.play("trapper_ability_timer")
		player.Ability.Translocator:
			handle_translocator_ability()
		_:
			pass

func switch_cameras(to_camera, from_camera):
	from_camera.current = false
	to_camera.current = true
	camera_mode_is_fps = not camera_mode_is_fps

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	if Input.is_action_pressed("jump") and is_on_floor() and can_jump:
		velocity.y = JUMP_VELOCITY

	if can_move:
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
	
func getAnimationPlayer() -> AnimationPlayer:
	return $AnimationPlayer

func throw_trap():
	var trap = trap_scene.instantiate()
	trap.setMyMaker(self)
	trap.global_transform.origin = head.global_transform.origin
	get_tree().root.add_child(trap)
	var direction = -head.transform.basis.z.normalized() + Vector3(0, 0.5, 0)
	trap.apply_impulse(direction * 2)

func handle_translocator_ability():
	if can_throw_translocator:
		$BeastAbilityAnimationPlayer.play("translocator_throw_ability_timer")
		translocator_reference = translocator_scene.instantiate()
		get_tree().root.add_child(translocator_reference)
		translocator_reference.global_position = head.global_position
	else:
		$BeastAbilityAnimationPlayer.play("translocator_teleport_ability_timer")
		self.global_position = translocator_reference.global_position
		translocator_reference.queue_free()
