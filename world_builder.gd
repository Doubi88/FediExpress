extends Resource

class_name WorldBuilder

@export var min_servers = 3
@export var max_servers = 10
@export var max_accounts_per_server = 12
@export var server_scene: PackedScene
@export var min_cloud_size: Vector2i = Vector2i(2, 1)
@export var max_cloud_size: Vector2i = Vector2i(5, 3)
@export var world_size: Vector2i = Vector2i(25, 25)

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
	var server_count = randi_range(min(min_servers, keys.size()), min(max_servers, keys.size()))
	for i in range(0, server_count):
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
	if names.size() > 1:
		print(server.server_name, ': ', names.size(), ' ', max_accounts, ' ')
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

func generate_cloud_world(parent: Node, servers: Array[FediServerData]) -> Array[FediServer]:
	var positions: Dictionary = {}
	var result: Array[FediServer] = []
	for fedi_server_data in servers:
		var server: FediServer = server_scene.instantiate()
		parent.add_child(server)
		server.server_data = fedi_server_data
		
		var pos: Vector2i
		var size = Vector2(randi_range(min_cloud_size.x, max_cloud_size.x), randi_range(min_cloud_size.y, max_cloud_size.y))
		while (pos == Vector2i.ZERO) || (!can_place_server_at(pos, size, positions, Vector2i(2, 2))):
			pos = Vector2i(randi_range(GridData.origin.x + size.x, world_size.x - size.x), randi_range(GridData.origin.y + size.y, world_size.y - size.y))
			
		positions[pos] = server
		server.position_in_grid = pos
		server.size_in_grid = size

		result.append(server)
	return result
			

func can_place_server_at(pos: Vector2i, size: Vector2i, occupied: Dictionary, min_distance: Vector2i) -> bool:
	var result: bool = true
	for server: FediServer in occupied.values():
		var rect1 = Rect2i(server.position_in_grid - min_distance, server.size_in_grid + min_distance)
		var rect2 = Rect2i(pos - min_distance, size + min_distance)
		
		if rect1.intersects(rect2):
			result = false
			break
	return result
