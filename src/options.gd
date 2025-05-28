class_name IRCOptions extends Node

var servers: Array[ServerOptions] = []

var default_nick := ""
var default_username := ""
var default_real_name := ""

var maximized:bool = ProjectSettings.get_setting("display/window/size/mode", Window.MODE_MAXIMIZED) == Window.MODE_MAXIMIZED
var window_width:int = ProjectSettings.get_setting("display/window/size/viewport_width", 800)
var window_height:int = ProjectSettings.get_setting("display/window/size/viewport_height", 600)


var config := ConfigFile.new()

const OPTIONS_FILE := "user://options.ini"

func read_options() -> Error:
	var err := config.load(OPTIONS_FILE)
	if err != OK:
		return err
	maximized = config.get_value("global", "maximized", true)
	if maximized:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	else:
		window_width = config.get_value("global", "window_width", 800)
		window_height = config.get_value("global", "window_height", 600)
		DisplayServer.window_set_size(Vector2i(window_width, window_height))


	default_nick = config.get_value("global", "nick", "")
	default_username = config.get_value("global", "username", "")
	default_real_name = config.get_value("global", "real_name", "")
	if default_real_name == "":
		default_real_name = default_nick

	servers = []
	var sections = config.get_sections()
	for section in sections:
		if section.begins_with("server-"):
			var server := ServerOptions.new()
			server.host = config.get_value(section, "host", "")
			server.port = config.get_value(section, "port", ServerOptions.DEFAULT_PORT)
			server.ssl = config.get_value(section, "ssl", false)
			server.nick = config.get_value(section, "nick", default_nick)
			server.username = config.get_value(section, "username", default_username)
			server.real_name = config.get_value(section, "real_name", default_real_name)
			server.server_password = config.get_value(section, "server_password", "")
			server.nickserv_password = config.get_value(section, "nickserv_password", "")
			server.channels = config.get_value(section, "channels", [])
			servers.append(server)

	return OK

func write_options() -> Error:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_MAXIMIZED:
		maximized = true
	else:
		maximized = false
		var window_size := DisplayServer.window_get_size()
		window_width = window_size.x
		window_height = window_size.y
	config.set_value("global", "maximized", maximized)
	config.set_value("global", "window_width", window_width)
	config.set_value("global", "window_height", window_height)

	config.set_value("global", "nick", default_nick)
	config.set_value("global", "username", default_username)
	config.set_value("global", "real_name", default_real_name)

	for i in range(servers.size()):
		var server := servers[i]
		var section := "server-" + str(i)
		config.set_value(section, "host", server.host)
		config.set_value(section, "port", server.port)
		config.set_value(section, "ssl", server.ssl)
		config.set_value(section, "nick", server.nick)
		config.set_value(section, "username", server.username)
		config.set_value(section, "real_name", server.real_name)
		config.set_value(section, "server_password", server.server_password)
		config.set_value(section, "nickserv_password", server.nickserv_password)
		config.set_value(section, "channels", server.channels)

	return config.save(OPTIONS_FILE)

func has_server(host: String, port:int = 6667) -> bool:
	for server in servers:
		if server.host == host and (server.port == port or server.port == 0 or port == 0):
			return true
	return false

func has_channel(host: String, channel: String) -> bool:
	for server in servers:
		if server.host == host:
			for chan in server.channels:
				if chan == channel:
					return true
	return false
