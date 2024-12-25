extends RigidBody3D

#region properties

var whoPlacedMe: player = null
var activated: bool = false
var whoDidIcatch: player = null

#endregion

func _ready():
	$AnimationPlayer.play("lifetime")

func fatherIsThatNotYou(body) -> bool:
	#checks if the body is the same as who made trap
	#basically returns true if player should be trapped by thingy
	if whoPlacedMe == null: #if no one placed, everyone is trapped.
		return true
	if not body is player: #if body is not a player we dont care.
		return false
	if whoPlacedMe == body: #if body is who placed the trap we dont care.
		return false
	if whoPlacedMe.is_beast == body.is_beast: #see if players are on same team (beast or not), if they are we dont care.
		return false
	return true

func _on_trap_area_body_entered(body: Node3D) -> void:
	if not body is player: return
	if fatherIsThatNotYou(body):
		$AnimationPlayer.stop()
		$AnimationPlayer.play("trap_activated")
		whoDidIcatch = body
		activated = true
		body.getAnimationPlayer().play("trapped")

func setMyMaker(body: player):
	if not body is player: return
	whoPlacedMe = body

func uwu():
	print("a")

func _on_body_entered(body: Node) -> void:
	if not sleeping:
		sleeping = true
