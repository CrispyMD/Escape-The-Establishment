extends Node3D

var nodes_in_area = []
var moving_door = false
const DESIRED_DEGREE = 90
const TIME_TO_OPEN_DOOR = 1 #seconds
@onready var animation_player = $OpenDoorAnimationPlayer
@onready var rotate_point = $RotatePoint

func _on_opening_door_area_body_entered(body):
	if not body is player: return
	nodes_in_area.append(body)
	body.interact_pressed.connect(open_door)
	body.get_node("CharacterUI").display_open_door()

func _on_opening_door_area_body_exited(body):
	if not body is player: return
	if body.interact_pressed.is_connected(open_door):
		body.interact_pressed.disconnect(open_door)
	body.get_node("CharacterUI").undisplay_open_door()

func open_door(character):
	if animation_player.is_playing(): return
	
	if rotate_point.rotation.y == 0: animation_player.play("rotate_door")
	else: animation_player.play_backwards("rotate_door")
