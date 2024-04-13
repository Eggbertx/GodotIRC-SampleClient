extends Node

class_name Menus

static var server_items: Array[Dictionary] = [
	{"type": "text", "text": "Server List..."},
	{"type": "separator"},
	{"type": "text", "text": "Connect to server (test)"},
	{"type": "text", "text": "Disconnect from server"},
	{"type": "separator"},
	{"type": "text", "text": "Exit"}
]

enum {
	SERVER_LIST,
	SERVER_SEPARATOR1,
	SERVER_CONNECT_TEST,
	SERVER_DISCONNECT,
	SERVER_SEPARATOR2,
	SERVER_EXIT
}

static func set_menu_items(menu: PopupMenu, items: Array[Dictionary]):
	var id := 0
	for item in items:
		var item_id = item["id"] if item.has("id") else id
		if not item.has("type"):
			item["type"] = "text"
		match item["type"]:
			"separator":
				menu.add_separator(item["text"] if item.has("text") else "", item_id)
			"checkbox":
				menu.add_check_item(item["text"], item_id)
			_:
				menu.add_item(item["text"], item_id)
		if item.has("tooltip"):
			menu.set_item_tooltip(item_id, item["tooltip"])
		if item.has("accelerator"):
			menu.set_item_accelerator(item_id, item["accelerator"])
		id += 1
