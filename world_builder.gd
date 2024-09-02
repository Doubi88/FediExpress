extends Resource

class_name WorldBuilder

@export var max_servers = 10
@export var max_accounts_per_server = 5

func read_accounts_file() -> PackedStringArray:
	var file = FileAccess.open("res://data/account_names.txt", FileAccess.READ)
	var content = file.get_as_text()
	return content.split("\n", false)

func create_world() -> Array[FediServer]:
	var account_names = read_accounts_file()
	var server_dict = parse_accounts(account_names)
	
	var keys = server_dict.keys()
	keys.shuffle()
	
	var servers: Array[FediServer] = []
	var max = randi_range(1, min(max_servers, keys.size()))
	for i in range(0, max):
		var server_name = keys[i]
		var server = FediServer.new()
		server.server_name = server_name
		server.accounts = create_accounts(server, server_dict[server_name])
		
		servers.append(server)
	return servers

func create_accounts(server: FediServer, account_names: Array) -> Array[FediAccount]:
	var result: Array[FediAccount] = []
	var names = account_names.duplicate()
	names.shuffle()
	var max = randi_range(1, min(max_accounts_per_server, names.size()))
	for i in range(0, max):
		var account_name = names[i]
		var account = FediAccount.new()
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
