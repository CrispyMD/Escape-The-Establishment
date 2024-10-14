extends Node3D

@onready var animation_player = $OpenDoorAnimationPlayer
@onready var rotate_point = $RotatePoint

var nodes_in_area = []
var player_using_door = null #keeps a player
var should_handle_progress_bar = false
var door_is_opened = false

func _on_opening_door_area_body_entered(body):
	if not body is player: return
	nodes_in_area.append(body)
	body.interact_pressed.connect(open_door)
	display_open_close(body)

func _on_opening_door_area_body_exited(body):
	if not body is player: return
	if body == player_using_door:
		player_using_door = null
		if should_handle_progress_bar: animation_player.stop()
		should_handle_progress_bar = false
	if body.interact_pressed.is_connected(open_door):
		body.interact_pressed.disconnect(open_door)
	
	body.get_node("CharacterUI").undisplay_progress_bar()
	body.get_node("CharacterUI").undisplay_interact()

func open_door(character):
	if animation_player.is_playing(): return
	player_using_door = character
	should_handle_progress_bar = true
	
	if door_is_opened:
		animation_player.play("close_door")
		return
	elif character.is_beast:
		animation_player.play("beast_open_door")
	else:
		animation_player.play("survivor_open_door")
	character.get_node("CharacterUI").undisplay_interact()
	character.get_node("CharacterUI").display_progress_bar()
	character.get_node("CharacterUI").set_progress_percent(0)

func stop_handling_progress_bar():
	player_using_door.get_node("CharacterUI").undisplay_interact()
	player_using_door.get_node("CharacterUI").undisplay_progress_bar()
	for areanodes in nodes_in_area:
		if areanodes is not player: pass
		areanodes.get_node("CharacterUI").display_close_door()
	player_using_door = null
	should_handle_progress_bar = false

func handle_progress_bar():
	if player_using_door == null: return
	
	var percent = animation_player.current_animation_position / 1.5
	if player_using_door.is_beast:
		percent *= 1.5
	player_using_door.get_node("CharacterUI").set_progress_percent(percent)

func _process(delta):
	if should_handle_progress_bar:
		handle_progress_bar()

func set_door_is_opened(state: bool):
	door_is_opened = state

func reset_player_using_door():
	player_using_door = null
	
func display_open_close(body):
	if door_is_opened: body.get_node("CharacterUI").display_close_door()
	else: body.get_node("CharacterUI").display_open_door()
