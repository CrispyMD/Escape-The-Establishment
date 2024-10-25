extends StaticBody3D

var nodes_in_hack_area = []
var player_hacking_computer = []
@onready var hacking_timer = $HackingTimer
var computer_is_hacked = false
@onready var skill_check_timer = $SkillCheckTimer
@onready var start_needle_rotation_timer = $StartNeedleRotationTimer
var time_for_full_roation_of_needle = 1 #in seconds
var needle_is_rotating = false
@onready var red_screen = $RedScreen
@onready var computer_fail_sprite = $ComputerFailSprite
var NEEDLE_SPEED = 2 * PI #needle will rotate at 1sec with 2pi
@onready var undisplay_skillcheck_failed_timer = $UndisplaySkillcheckFailedTimer

func _on_hack_areas_body_entered(body):
	if not body is player or computer_is_hacked: return
	if body.is_beast: return
	nodes_in_hack_area.push_front(body)
	body.interact_pressed.connect(hack_computer)
	
	body.get_node("CharacterUI").display_hack()

func _on_hack_areas_body_exited(body):
	if not body is player: return
	nodes_in_hack_area.erase(body)
	player_hacking_computer.erase(body)
	
	
	if nodes_in_hack_area.is_empty():
		hacking_timer.paused = true
		skill_check_timer.paused = true
	
	if body.interact_pressed.is_connected(hack_computer):
		body.interact_pressed.disconnect(hack_computer)
	elif body.interact_pressed.is_connected(skillcheck_pressed):
		body.interact_pressed.disconnect(skillcheck_pressed)
	body.get_node("CharacterUI").undisplay_interact()
	body.get_node("CharacterUI").undisplay_progress_bar()

func hack_computer(character):
	if needle_is_rotating: skillcheck_failed()
	
	character.interact_pressed.disconnect(hack_computer)
	character.interact_pressed.connect(skillcheck_pressed)
	character.get_node("CharacterUI").display_progress_bar()
	
	hacking_timer.paused = false
	skill_check_timer.paused = false
	player_hacking_computer.append(character)
	
	if skill_check_timer.time_left == 0: skill_check_timer.start()
	if hacking_timer.time_left == 0: hacking_timer.start()

func _process(delta):
	if hacking_timer.time_left == 0 or computer_is_hacked:
		return
	handle_progress_bar()
	if needle_is_rotating: handle_skillcheck(delta)

func handle_skillcheck(delta):
	for node in nodes_in_hack_area:
		node.get_node("CharacterUI").increase_needle_rotation(NEEDLE_SPEED * delta)
		if abs(node.get_node("CharacterUI/SkillCheck/Needle").rotation - 2 * PI) <= 0.0001:
			skillcheck_failed()

func skillcheck_pressed(character):
	if not needle_is_rotating: return
	var success_zone = character.get_node("CharacterUI").get_success_zone_degree()
	var needle_rotation = character.get_node("CharacterUI").get_needle_rotation()
	var offset = abs(success_zone - needle_rotation)
	if offset <= 45:
		hacking_timer.paused = false
		print("succeeded")
	else:
		skillcheck_failed()
	
	character.get_node("CharacterUI").undisplay_skillcheck()
	needle_is_rotating = false

func handle_progress_bar():
	if hacking_timer.paused or computer_is_hacked or hacking_timer.time_left == 0: return
	
	for node in player_hacking_computer:
		node.get_node("CharacterUI").undisplay_interact()
		node.get_node("CharacterUI").set_progress_percent(1 - hacking_timer.time_left / hacking_timer.wait_time)

func _on_hacking_timer_timeout():
	computer_is_hacked = true
	print("yay")
	$GreenScreen.show()
	for hack_area in $HackAreas.get_children():
		hack_area.disabled = true
	for node in player_hacking_computer:
		node.get_node("CharacterUI").undisplay_progress_bar()

func _on_skill_check_timer_timeout():
	hacking_timer.paused = true
	start_needle_rotation_timer.start()
	for node in nodes_in_hack_area:
		node.get_node("CharacterUI").display_skillcheck()

func _on_start_needle_rotation_timer_timeout():
	needle_is_rotating = true

func skillcheck_failed():
	needle_is_rotating = false
	for node in nodes_in_hack_area:
		node.get_node("CharacterUI").undisplay_progress_bar()
	display_computer_as_failed()
	undisplay_skillcheck_failed_timer.start()
	print("faoieled >:(")

func _on_undisplay_skillcheck_failed_timer_timeout():
	red_screen.visible = false
	computer_fail_sprite.visible = false

func display_computer_as_failed():
	red_screen.show()
	computer_fail_sprite.visible = true
	
func set_computer_is_hacked(state: bool):
	computer_is_hacked = state
