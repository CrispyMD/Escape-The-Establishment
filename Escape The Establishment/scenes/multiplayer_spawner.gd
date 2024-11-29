extends MultiplayerSpawner

@export var characterScene : PackedScene
var players = {} #dict

func _ready():
	spawn_function = spawnPlayer
	if is_multiplayer_authority():
		spawn(1)
		multiplayer.peer_connected.connect(spawn)
		multiplayer.peer_disconnected.connect(removePlayer)


func spawnPlayer(data):
	var character = characterScene.instantiate()
	character.set_multiplayer_authority(data)
	players[data] = character
	return character

func removePlayer(data):
	players[data].queue_free()
	players.erase(data)
