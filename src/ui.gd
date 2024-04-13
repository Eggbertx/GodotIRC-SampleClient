extends Control

@onready var server_menu: PopupMenu = $VBoxContainer/PanelContainer/MenuBar/Server

# Called when the node enters the scene tree for the first time.
func _ready():
	Menus.set_menu_items(server_menu, Menus.server_items)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float):
	pass

func _on_server_id_pressed(id):
	match id:
		Menus.SERVER_EXIT:
			print("Exiting")
			get_tree().quit()
		_:
			print("unhandled server menu id %d" % id)
