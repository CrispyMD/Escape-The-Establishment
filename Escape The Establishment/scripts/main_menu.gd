extends Node3D
@export var light_offset: Vector3 = Vector3(0, 1, 0) # Optional offset for the light

var camera: Camera3D
var spotlight: SpotLight3D

var debug_line: ImmediateMesh = ImmediateMesh.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

	var debug_instance = MeshInstance3D.new()
	debug_instance.mesh = debug_line
	debug_instance.material_override = StandardMaterial3D.new()
	debug_instance.material_override.albedo_color = Color.RED
	add_child(debug_instance)
	camera = $Camera3D
	spotlight = $SpotLight3D

func draw_debug_line(from: Vector3, to: Vector3):
	debug_line.clear_surfaces()
	debug_line.surface_begin(Mesh.PRIMITIVE_LINES)
	debug_line.surface_add_vertex(from)
	debug_line.surface_add_vertex(to)
	debug_line.surface_end()

func _physics_process(delta: float) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	
	var from = camera.project_ray_origin(mouse_pos)
	
	var to = from + camera.project_ray_normal(mouse_pos) * 1000  # Extend the ray far into the world

	draw_debug_line(from, to)
	 # Set up the raycast parameters
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to

	# Perform the raycast
	var space_state = get_world_3d().direct_space_state
	var result = space_state.intersect_ray(ray_query)
	
	print(result)
	#print(result["position"])
	if result:
		spotlight.position.x = result["position"].x
		spotlight.position.y = result["position"].y

func _on_area_3d_mouse_entered() -> void:
	#$MeshInstance3D3/SpotLight3D.visible = true
	pass
	#$MeshInstance3D3.scale = Vector3(2, 1, 1)


func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	print(event.as_text())
	if event is InputEventMouseButton:
		event = event as InputEventMouseButton
		if event.get_button_index() == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				print("huh??")


func _on_area_3d_mouse_exited() -> void:
	#$MeshInstance3D3/SpotLight3D.visible = false
	pass
	#$MeshInstance3D3.scale = Vector3(1, 1, 1)
