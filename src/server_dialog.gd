class_name ServerDialog extends ConfirmationDialog

@onready var _channel_list: VBoxContainer = $PanelContainer/VBoxContainer/TabContainer/Channels/ChannelList
@onready var _server_host_edit: LineEdit = $PanelContainer/VBoxContainer/GridContainer/ServerLineEdit
@onready var _port_spinner: SpinBox = $PanelContainer/VBoxContainer/GridContainer/PortSpinBox
@onready var _ssl_checkbox: CheckBox = $PanelContainer/VBoxContainer/GridContainer/SSLCheckBox
@onready var _nick_edit: LineEdit = $PanelContainer/VBoxContainer/TabContainer/User/NickLineEdit
@onready var _username_edit: LineEdit = $PanelContainer/VBoxContainer/TabContainer/User/UsernameLineEdit
@onready var _realname_edit: LineEdit = $PanelContainer/VBoxContainer/TabContainer/User/RealnameLineEdit

var server_host: String:
	get:
		return _server_host_edit.text
	set(v):
		_server_host_edit.text = v

var port: int:
	get:
		return int(_port_spinner.value)
	set(v):
		_port_spinner.value = v

var use_ssl: bool:
	get:
		return _ssl_checkbox.button_pressed
	set(v):
		_ssl_checkbox.button_pressed = v

var nick: String:
	get:
		return _nick_edit.text
	set(v):
		_nick_edit.text = v

var username: String:
	get:
		return _username_edit.text
	set(v):
		_username_edit.text = v

var real_name: String:
	get:
		return _realname_edit.text
	set(v):
		_realname_edit.text = v



func show_dialog(server: ServerOptions = null):
	if server == null:
		reset_form()
		title = "New Server Connection"
	else:
		fill_values(server)
		title = "Edit Server Connection"
	show()
	grab_focus()

func fill_values(_opts:ServerOptions):
	server_host = _opts.host
	port = _opts.port
	use_ssl = _opts.ssl
	nick = _opts.nick
	username = _opts.username
	real_name = _opts.real_name
	_channel_list.clear_children()
	for channel in _opts.channels:
		_add_channel_row(channel)

func _add_channel_row(channel:String = ""):
	var hbox := HBoxContainer.new()
	hbox.size_flags_horizontal = Control.SIZE_EXPAND|Control.SIZE_FILL
	_channel_list.add_child(hbox)
	var channel_line := LineEdit.new()
	channel_line.placeholder_text = "#channel"
	channel_line.text = channel
	channel_line.size_flags_horizontal = Control.SIZE_EXPAND|Control.SIZE_FILL
	hbox.add_child(channel_line)
	var remove_btn := Button.new()
	remove_btn.text = "Remove"
	hbox.add_child(remove_btn)
	var remove_channel = func():
		_channel_list.remove_child(hbox)
	remove_btn.button_up.connect(remove_channel)

func reset_form():
	server_host = ""
	port = 6667
	use_ssl = false
	nick = ""
	username = ""
	real_name = ""
	var channel_children := _channel_list.get_children()
	for child in channel_children:
		_channel_list.remove_child(child)
		child.queue_free()

func get_channels() -> Array[String]:
	var channels: Array[String] = []
	var channel_children = _channel_list.find_children("*", "LineEdit", true, false)
	for child in channel_children:
		if child.text != "":
			channels.append(child.text)
	return channels

func get_options() -> ServerOptions:
	var opts := ServerOptions.new()
	opts.host = server_host
	opts.port = port
	opts.ssl = use_ssl
	opts.nick = nick
	opts.username = username
	opts.real_name = real_name
	opts.channels = get_channels()
	return opts

func _on_add_channel_button_button_up():
	_add_channel_row()

func _on_canceled():
	reset_form()
