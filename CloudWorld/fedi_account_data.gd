extends Resource

class_name FediAccountData

@export var account_name: String
@export var fedi_server: FediServerData

func get_full_name() -> String:
	return account_name + '@' + fedi_server.server_name
