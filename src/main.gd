extends Node

@onready var irc_mgr:IRCClientManager  = $IRCClientManager
@onready var ui: UI = $UI
var options := IRCOptions.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	var err := options.read_options()
	if err == ERR_FILE_NOT_FOUND:
		print("Options file not found, showing server dialog")
		ui.server_dialog.show_dialog()
		pass
	if err != OK:
		print("Error reading options: %s" % error_string(err))
		return

	if options.servers.size() == 0:
		print("No servers found in options")
		return

	for server in options.servers:
		print("Adding server %s:%d, SSL: %s" % [server.host, server.port, server.ssl])
		irc_mgr.add_server(server)


func _on_ui_server_item_selected(id: int):
	match id:
		Menus.SERVER_LIST:
			ui.alert("Server list not implemented yet", "Error")
		Menus.SERVER_CONNECT:
			ui.server_dialog.show_dialog()
		Menus.SERVER_DISCONNECT:
			ui.alert("Server disconnect not implemented yet", "Error")
		Menus.SERVER_EXIT:
			await irc_mgr.disconnect_clients()
			get_tree().quit()
		_:
			ui.alert("unhandled server menu id %d" % id, "Error")


func _on_ui_message_submitted(msg:String, server:String, _channel:String):
	var conn := irc_mgr.get_server_conn(server)
	if conn == null:
		ui.alert("Unable to find server connection", "Error")

	if msg.begins_with("/"):
		# user command
		var cmd_args = msg.split(" ", true, 1)
		match cmd_args[0].substr(1).to_lower():
			"join":
				print(cmd_args)
				if cmd_args.size() == 2:
					conn.join_channel(cmd_args[1])
			_:
				ui.alert("Unknown command %s" % cmd_args[0], "Error")


func _on_ui_server_connection_added(server: ServerOptions) -> void:
	if options.has_server(server.host):
		ui.alert("Server already exists", "Error")
		return
	options.servers.append(server)
	var err_str := await irc_mgr.add_server(server)
	if err_str != "":
		ui.alert("Error adding server %s:%d: %s" % [server.host, server.port, err_str], "Error")
		return
	var err := options.write_options()
	if err != OK:
		ui.alert("Error writing options: %s" % error_string(err), "Error")
		return
	ui.server_dialog.visible = false
	print("Added server %s:%d" % [server.host, server.port])
