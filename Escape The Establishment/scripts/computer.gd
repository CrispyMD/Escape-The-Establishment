extends StaticBody3D

var nodes_in_hack_area = []
@onready var hack_handler = $hack_handler
var how_done := 0.0

func _on_hack_areas_body_entered(body):
	nodes_in_hack_area.push_front(body)
	if not body is player: return
	body.interact_pressed.connect(hack_computer)
	
	body.get_node("CharacterUI").display_hack()
	#body.get_node("AbilityUI").display_ability("s")


func _on_hack_areas_body_exited(body):
	nodes_in_hack_area.erase(body)
	if not body is player: return
	body.interact_pressed.disconnect(hack_computer)
	body.get_node("CharacterUI").undisplay_all()

func hack_computer():
	print("ein li moah")
	
