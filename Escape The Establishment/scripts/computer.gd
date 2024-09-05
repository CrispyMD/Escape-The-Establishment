extends StaticBody3D

func _on_hack_areas_body_entered(body):
	if not body is player: return
	body.get_node("AbilityUI").visible = true
	body.get_node("AbilityUI").display_hack()
	#body.get_node("AbilityUI").display_ability("s")


func _on_hack_areas_body_exited(body):
	if not body is player: return
	body.get_node("AbilityUI").visible = false

func player_is_hacking_computer():
	pass
