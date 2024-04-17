extends Node

@onready var irc_mgr:IRCClientManager  = $IRCClientManager
@onready var ui: UI = $UI

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_ui_server_item_selected(id: int):
	match id:
		Menus.SERVER_EXIT:
			await irc_mgr.disconnect_clients()
			get_tree().quit()
		Menus.SERVER_CONNECT:
			pass
		_:
			print("unhandled server menu id %d" % id)


func _on_ui_message_submitted(msg:String, server:String, channel:String):
	var conn := irc_mgr.get_server_conn(server)
	if conn == null:
		ui.alert("Unable to find server connection")

	if msg.begins_with("/"):
		# user command
		var cmd_args = msg.split(" ", true, 1)
		match cmd_args[0].substr(1).to_lower():
			"join":
				print(cmd_args)
				if cmd_args.size() == 2:
					conn.join_channel(cmd_args[1])
