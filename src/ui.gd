extends Control

signal server_item_selected(id: int)

@onready var server_menu: PopupMenu = $VBoxContainer/PanelContainer/MenuBar/Server
@onready var server_tree: Tree = $VBoxContainer/HSplitContainer/ServerTree
@onready var chat_text: TextEdit = $VBoxContainer/HSplitContainer/VBoxContainer/ChatText

var tree_root: TreeItem = null

# Dictionary -> Dictionary -> Array[String], host -> channel -> messages
var server_logs: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	Menus.set_menu_items(server_menu, Menus.server_items)
	tree_root = server_tree.create_item()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float):
	pass


func _get_server_item(host:String) -> TreeItem:
	var children := tree_root.get_children()
	for child in children:
		if child.get_text(0) == host:
			return child
	return null

func _on_server_id_pressed(id:int):
	server_item_selected.emit(id)

func create_log_if_not_exists(host: String, channel: String):
	if not server_logs.has(host):
		server_logs[host] = {}
	
	if not server_logs[host].has(channel):
		server_logs[host][channel] = []

func add_log_msg(host: String, channel: String, msg: String):
	create_log_if_not_exists(host, channel)
	server_logs[host][channel].append(msg)

func set_active_log(host: String, channel: String = host):
	create_log_if_not_exists(host, channel)
	var text =  "\n".join(server_logs[host][channel])
	chat_text.text = text
	

func _on_irc_client_manager_client_connected(client:IRCClient):
	create_log_if_not_exists(client.host, client.host)
	if not server_logs.has(client.host):
		server_logs[client.host] = {
			client.host: []
		}
	if _get_server_item(client.host) == null:
		var server_child = server_tree.create_item(tree_root)
		server_child.set_text(0, client.host)
		server_tree.create_item(server_child).set_text(0, "#channel")

func _on_server_tree_item_selected():
	var selected := server_tree.get_selected()
	var selected_parent := selected.get_parent()
	var is_server := selected_parent == tree_root

	var selected_channel = selected.get_text(0)
	var selected_server = selected_channel if is_server else selected_parent.get_text(0)

	print("Switching to %s -> %s" % [selected_server, selected_channel])
	set_active_log(selected_server, selected_channel)


func _on_irc_client_manager_unhandled_message_received(client, msg):
	create_log_if_not_exists(client.host, client.host)
	# server_logs[client.host][client.host].append(msg)


func _on_irc_client_manager_server_message_received(client, msg_type, msg):
	create_log_if_not_exists(client.host, client.host)
	add_log_msg(client.host, client.host, msg)

