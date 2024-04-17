extends ConfirmationDialog

@onready var _channel_list = $PanelContainer/VBoxContainer/TabContainer/Channels/ChannelList
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
		return _port_spinner.value
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

enum DialogMode {
	NEW_SERVER,
	EDIT_SERVER
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func show_dialog(mode: DialogMode):
	match mode:
		DialogMode.NEW_SERVER:
			title = "New server connection"
		DialogMode.EDIT_SERVER:
			title = "Edit server connection"

func fill_values(opts:IRCOptions, profile:IRCProfile):
	pass

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
	remove_btn.text = "-"
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

func get_channels():
	var channels: Array[String] = []
	var channel_children = _channel_list.find_children("*", "LineEdit", true, false)
	for child in channel_children:
		if child.text != "":
			channels.append(child.text)
	return channels

func _on_add_channel_button_button_up():
	_add_channel_row()

func _on_canceled():
	reset_form()
