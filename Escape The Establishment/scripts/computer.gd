extends StaticBody3D

var nodes_in_hack_area = []
@onready var hacking_timer = $HackingTimer
var computer_is_hacked = false
@onready var skill_check_timer = $SkillCheckTimer
@onready var start_needle_rotation_timer = $StartNeedleRotationTimer
var time_for_full_roation_of_needle = 1 #in seconds
var needle_is_rotating = false

func _on_hack_areas_body_entered(body):
	if not body is player: return
	nodes_in_hack_area.push_front(body)
	body.interact_pressed.connect(hack_computer)
	
	body.get_node("CharacterUI").display_hack()

func _on_hack_areas_body_exited(body):
	if not body is player: return
	nodes_in_hack_area.erase(body)
	body.interact_pressed.disconnect(hack_computer)
	body.get_node("CharacterUI").undisplay_all()

func hack_computer(character):
	character.interact_pressed.disconnect(hack_computer)
	character.interact_pressed.connect(skillcheck_pressed)
	hacking_timer.start()
	skill_check_timer.start()


func _process(delta):
	if hacking_timer.time_left == 0 or computer_is_hacked:
		return
	handle_progress_bar()
	if needle_is_rotating: handle_skillcheck(delta)


func handle_skillcheck(delta):
	for node in nodes_in_hack_area:
		#if not node is player: continue <-- not needed now since only players are added to array
		node.get_node("CharacterUI").increase_needle_rotation(delta)

func skillcheck_pressed(character):
	var success_zone = character.get_node("CharacterUI").get_success_zone_degree()
	var needle_rotation = character.get_node("CharacterUI").get_needle_rotation()
	var offset = abs(success_zone - needle_rotation)
	if offset <= 45:
		print("succeeded")
	else:
		$ComputerFailSprite.visible = true
		print("faoieled >:(")
	character.get_node("CharacterUI").undisplay_skillcheck()
	needle_is_rotating = false

func handle_progress_bar():
	for node in nodes_in_hack_area:
		#if not node is player: continue
		node.get_node("CharacterUI").undisplay_hack()
		var progress_bar = node.get_node("CharacterUI/ProgressBar")
		var progress_panel = progress_bar.get_node("Panel")
		node.get_node("CharacterUI").set_progress_percent(1 - hacking_timer.time_left / hacking_timer.wait_time)

func _on_hacking_timer_timeout():
	computer_is_hacked = true
	print("yay")

func _on_skill_check_timer_timeout():
	hacking_timer.paused = true
	start_needle_rotation_timer.start()
	for node in nodes_in_hack_area:
		#if not node is player: continue
		node.get_node("CharacterUI").display_skillcheck()

func _on_start_needle_rotation_timer_timeout():
	needle_is_rotating = true
