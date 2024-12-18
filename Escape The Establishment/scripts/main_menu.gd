extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_mouse_entered() -> void:
	$MeshInstance3D3.scale = Vector3(2, 1, 1)


func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	print(event.as_text())
	if event is InputEventMouseButton:
		event = event as InputEventMouseButton
		if event.get_button_index() == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				print("huh??")


func _on_area_3d_mouse_exited() -> void:
	$MeshInstance3D3.scale = Vector3(1, 1, 1)
