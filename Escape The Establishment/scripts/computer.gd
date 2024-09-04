extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_hack_areas_body_entered(body):
	body.get_node("AbilityUI").visible = true
	body.get_node("AbilityUI").display_hack()
	#body.get_node("AbilityUI").display_ability("s")


func _on_hack_areas_body_exited(body):
	body.get_node("AbilityUI").visible = false
