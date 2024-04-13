extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_ui_server_item_selected(id: int):
	match id:
		Menus.SERVER_EXIT:
			print("Exiting")
			get_tree().quit()
		_:
			print("unhandled server menu id %d" % id)


