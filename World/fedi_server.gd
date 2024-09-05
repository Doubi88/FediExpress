extends StaticBody2D

class_name FediServer

@onready var cloud_part_icon = preload("res://World/cloud_circle.png")

@onready var collision_shape = $CollisionShape2D
@onready var icon_parent = $IconParent

@export var server_data: FediServerData
@export var position_in_grid: Vector2i:
	set(value):
		position_in_grid = value
		pos_changed = true
	get:
		return position_in_grid

@export var size_in_grid: Vector2i:
	set(value):
		size_in_grid = value
		size_changed = true
	get:
		return size_in_grid

@onready var name_label = $NameLabel

var pos_changed = true
var size_changed = true

func _process(delta: float):
	name_label.text = '@' + server_data.server_name + " pos: (" + String.num(position_in_grid.x) + ", " + String.num(position_in_grid.y) + ") size: (" + String.num(size_in_grid.x) + ", " + String.num(size_in_grid.y) + ")"
	if pos_changed:
		position = Vector2(position_in_grid) * GridData.cell_size + GridData.origin
		pos_changed = false
	if size_changed:
		redraw_icons()
		size_changed = false

func redraw_icons():
	for icon in icon_parent.get_children():
		icon_parent.remove_child(icon)
		icon.queue_free()
	
	var real_size = Vector2(size_in_grid) * GridData.cell_size
	(collision_shape.shape as RectangleShape2D).size = real_size

	var start_pos = Vector2i(-floor(size_in_grid.x / 2.0), -floor(size_in_grid.y / 2.0))
	for x in range(start_pos.x, size_in_grid.x + start_pos.x):
		for y in range (start_pos.y, size_in_grid.y + start_pos.y):
			var pos = Vector2i(x, y)
			var icon = Sprite2D.new()
			icon_parent.add_child(icon)
			icon.texture = cloud_part_icon
			icon.centered = false
			icon.position = Vector2(pos) * GridData.cell_size
