extends Resource

class_name WorldBuilder

@export var max_servers = 10
@export var max_accounts_per_server = 5

func read_accounts_file() -> PackedStringArray:
	var file = FileAccess.open("res://data/account_names.txt", FileAccess.READ)
	var content = file.get_as_text()
	return content.split("\n", false)

func create_world_data() -> Array[FediServerData]:
	var account_names = read_accounts_file()
	var server_dict = parse_accounts(account_names)
	
	var keys = server_dict.keys()
	keys.shuffle()
	
	var servers: Array[FediServerData] = []
	var max = randi_range(3, min(max_servers, keys.size()))
	for i in range(0, max):
		var server_name = keys[i]
		var server = FediServerData.new()
		server.server_name = server_name
		server.accounts = create_accounts(server, server_dict[server_name])
		
		servers.append(server)
	return servers

func create_accounts(server: FediServerData, account_names: Array) -> Array[FediAccountData]:
	var result: Array[FediAccountData] = []
	var names = account_names.duplicate()
	names.shuffle()
	var max_accounts = randi_range(1, min(max_accounts_per_server, names.size()))
	for i in range(0, max_accounts):
		var account_name = names[i]
		var account = FediAccountData.new()
		account.account_name = account_name
		account.fedi_server = server
		result.append(account)
		
	return result;

func parse_accounts(account_names: Array[String]) -> Dictionary:
	var accounts: Dictionary = {};
	
	for acc_name in account_names:
		var split_name = acc_name.split("@", false)
		var user_name = split_name[0]
		var server_name = split_name[1]
		
		if not accounts.has(server_name):
			accounts[server_name] = []
		
		accounts[server_name].append(user_name)
	return accounts

func generate_cloud_world(parent: Node, servers: Array[FediServerData], preloaded_server_scene: PackedScene, preloaded_cloud_icon: Texture) -> Array[FediServer]:
	var positions: Dictionary = {}
	var result: Array[FediServer] = []
	for fedi_server_data in servers:
		var server: FediServer = preloaded_server_scene.instantiate()
		parent.add_child(server)
		server.server_data = fedi_server_data
		
		result.append(server)
		
		var pos: Vector2i
		var size = Vector2(randi_range(1, 5), 1)#randi_range(1, 3))
		while (pos == null) || (!can_place_server_at(pos, size, positions)):
			pos = Vector2i(randi_range(0, 25), randi_range(0, 25))
			
		positions[pos] = server
		server.position_in_grid = pos
		server.size_in_grid = size
	return result
			

func can_place_server_at(pos: Vector2i, size: Vector2i, occupied: Dictionary) -> bool:
	return !(occupied.has(pos)) && !occupied.has(pos + Vector2i.LEFT) && !occupied.has(pos + Vector2i.RIGHT) && \
			!occupied.has(pos - Vector2i.UP) && !occupied.has(pos + Vector2i.DOWN)
