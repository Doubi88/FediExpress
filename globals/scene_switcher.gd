extends Node

var cloud_world_packed = preload("res://CloudWorld/cloud_world.tscn")
var server_world_packed = preload("res://TopDownWorld/server_world.tscn")
var splash_screen_packed = preload("res://UI/splash_screen/splash.tscn")

var cloud_world: CloudWorld
var current_server_world: ServerWorld

var current_server: FediServerData

signal resetting_game()

func go_to_cloud_world():
	if cloud_world == null:
		cloud_world = cloud_world_packed.instantiate()
	if current_server_world != null:
		current_server_world.get_parent().remove_child(current_server_world)
		current_server_world.queue_free()
		current_server_world = null
		current_server = null
	get_tree().root.add_child(cloud_world)

func go_to_server_world(data: FediServerData):
	if current_server_world == null:
		current_server = data
		current_server_world = preload("res://TopDownWorld/server_world.tscn").instantiate()
		current_server_world.server_data = data
		cloud_world.add_sibling(current_server_world)
		get_tree().root.remove_child(cloud_world)
		
func restart():
	resetting_game.emit()
	if current_server_world != null:
		current_server_world.get_parent().remove_child(current_server_world)
		current_server_world.queue_free()
		current_server = null
	if cloud_world != null:
		if cloud_world.is_inside_tree():
			cloud_world.get_parent().remove_child(cloud_world)
		cloud_world.queue_free()
		cloud_world = null
	var splash = splash_screen_packed.instantiate()
	get_tree().root.add_child(splash)
	get_tree().paused = false
	GlobalServerData.reset()
	
