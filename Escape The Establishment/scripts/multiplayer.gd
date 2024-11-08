extends Node3D
#
#@onready var main_menu = $CanvasLayer/MainMenu
#@onready var address_entry = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/AddressEntry
#
#const Character = preload("res://scenes/character.tscn")
#const PORT = 9999
#var enet_peer = ENetMultiplayerPeer.new()
#
#
#func _on_host_pressed():
	#main_menu.hide()
	#
	#enet_peer.create_server(PORT)
	#multiplayer.multiplayer_peer = enet_peer
	#multiplayer.peer_connected.connect(add_player)
	#multiplayer.peer_disconnected.connect(remove_player)
	#
	#add_player(multiplayer.get_unique_id())
#
#
#func add_player(peer_id):
	#print("rnjk")
	#var character = Character.instantiate()
	#character.name = str(peer_id)
	#add_child(character)
	#character.position = Vector3(-12,2,4)
	##if character.is_multiplayer_authority():
		##character.health_changed.connect(update_health_bar)
#
#func remove_player(peer_id):
	#var character = get_node_or_null(str(peer_id))
	#if character:
		#character.queue_free()
#
#
#func _on_join_pressed():
	#main_menu.hide()
	#print("skibidi")
	#enet_peer.create_client(address_entry.text, PORT)
	#multiplayer.multiplayer_peer = enet_peer
