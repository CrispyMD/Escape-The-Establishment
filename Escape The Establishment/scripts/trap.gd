extends RigidBody3D

var whoPlacedMe: player = null
var activated: bool = false
var whoDidIcatch: player = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("lifetime")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

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
	print("a")
	if fatherIsThatNotYou(body):
		print("b")
		$AnimationPlayer.stop()
		$AnimationPlayer.play("trap_activated")
		#body.get_node("CharacterUI").set_status_effect("trapped", 2.0)
		whoDidIcatch = body
		activated = true
		body.getAnimationPlayer().play("trapped")
		print("c")
		
	
func setMyMaker(body: player):
	if not body is player: return
	whoPlacedMe = body

func uwu():
	print("a")


func _on_body_entered(body: Node) -> void:
	if not sleeping:
		sleeping = true
