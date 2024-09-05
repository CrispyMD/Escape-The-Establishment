extends StaticBody3D

var nodes_in_hack_area = []
@onready var hacking_timer = $HackingTimer
var computer_is_hacked = false

func _on_hack_areas_body_entered(body):
	nodes_in_hack_area.push_front(body)
	if not body is player: return
	body.interact_pressed.connect(hack_computer)
	
	body.get_node("CharacterUI").display_hack()

func _on_hack_areas_body_exited(body):
	nodes_in_hack_area.erase(body)
	if not body is player: return
	body.interact_pressed.disconnect(hack_computer)
	body.get_node("CharacterUI").undisplay_all()

func hack_computer():
	hacking_timer.start()

func _process(delta):
	#print(hacking_timer.time_left)
	if hacking_timer.time_left == 0 or computer_is_hacked:
		return
	for node in nodes_in_hack_area:
		if not node is player: return
		var progress_bar = node.get_node("CharacterUI/ProgressBar")
		var progress_panel = progress_bar.get_node("Panel")
		node.get_node("CharacterUI").set_progress_percent(1 - hacking_timer.time_left / hacking_timer.wait_time)
		#progress_panel.size.x -= delta * progress_bar.size.x / hacking_timer.wait_time


func _on_hacking_timer_timeout():
	print("yay")
