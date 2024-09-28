extends Node3D

var nodes_in_area = []
var moving_door = false
const DESIRED_DEGREE = 90
const TIME_TO_OPEN_DOOR = 1 #seconds

func _on_opening_door_area_body_entered(body):
	if not body is player: return
	print("fgbhb")
	#nodes_in_area.append(body)
	#body.interact_pressed.connect(open_door)
	#body.get_node("CharacterUI").display_hack()

func open_door(character):
	print("Jimmy Newtron")
	moving_door = true

func _process(delta):
	$RotatePoint.rotate_y(deg_to_rad(1))
	#$OpeningDoorArea/OpeningDoorCollision.global_rotation = Vector3.ZERO
	print($OpeningDoorArea/OpeningDoorCollision.rotation)
	print($OpeningDoorArea/OpeningDoorCollision.global_rotation)
	print("-----------------")

