class_name IRCOptions extends Node

var servers: Array[ServerOptions] = []

var nick := ""
var username := ""
var real_name := ""

var config := ConfigFile.new()

const OPTIONS_FILE := "user://options.ini"

func read_options() -> Error:
	var err := config.load(OPTIONS_FILE)
	if err != OK:
		return err
	nick = config.get_value("global", "nick", "")
	username = config.get_value("global", "username", "")
	real_name = config.get_value("global", "real_name", "")
	if real_name == "":
		real_name = nick

	servers = []
	var sections = config.get_sections()
	for section in sections:
		if section.begins_with("server-"):
			var server := ServerOptions.new()
			server.host = config.get_value(section, "host", "")
			server.port = config.get_value(section, "port", ServerOptions.DEFAULT_PORT)
			server.ssl = config.get_value(section, "ssl", false)
			server.nick = config.get_value(section, "nick", nick)
			server.username = config.get_value(section, "username", username)
			server.real_name = config.get_value(section, "real_name", real_name)
			server.server_password = config.get_value(section, "server_password", "")
			server.nickserv_password = config.get_value(section, "nickserv_password", "")
			server.channels = config.get_value(section, "channels", [])
			servers.append(server)

	return OK

func write_options() -> Error:
	config.set_value("global", "nick", nick)
	config.set_value("global", "username", username)
	config.set_value("global", "real_name", real_name)

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