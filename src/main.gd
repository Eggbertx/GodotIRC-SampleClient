extends Node

@onready var irc_mgr:IRCClientManager  = $IRCClientManager

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_ui_server_item_selected(id: int):
	match id:
		Menus.SERVER_EXIT:
			irc_mgr.disconnect_clients()
		_:
			print("unhandled server menu id %d" % id)

func _on_irc_client_manager_unhandled_message_received(client, msg):
	pass # print("%s <- %s" % [client.host, msg])
