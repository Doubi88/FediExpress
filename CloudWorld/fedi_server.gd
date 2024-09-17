extends StaticBody2D

class_name FediServer

@onready var cloud_part_icon = preload("res://CloudWorld/cloud_circle_64.png")

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

@export var balls_per_grid_cell = 4

@onready var name_sign: Node2D = $NameSign
@onready var name_label: Label = $NameSign/NameLabel

var pos_changed = true
var size_changed = true

func _process(delta: float):
	name_label.text = '@' + server_data.server_name
	name_sign.position = -(name_label.size / 2.0)
	if pos_changed:
		position = Vector2(position_in_grid) * GridData.cell_size + GridData.origin
		pos_changed = false
	if size_changed:
		redraw_icons()
		size_changed = false

func redraw_icons():
	var icons = icon_parent.get_children()
	for icon in icons:
		icon_parent.remove_child(icon)
		icon.queue_free()
	
	var real_size = Vector2(size_in_grid) * GridData.cell_size
	var new_shape = RectangleShape2D.new()
	new_shape.size = real_size
	collision_shape.shape = new_shape
	
	for grid_y in range(0, size_in_grid.y):
		for grid_x in range(0, size_in_grid.x):
			for i in range(0, balls_per_grid_cell):
				var x = randi_range((grid_x - 0.5) * GridData.cell_size.x, (grid_x + 0.5) * GridData.cell_size.x)
				var y = randi_range((grid_y - 0.5) * GridData.cell_size.y, (grid_y + 0.5) * GridData.cell_size.y)
				var pos = Vector2(x, y)

				var icon = Sprite2D.new()
				icon_parent.add_child(icon)
				icon.texture = cloud_part_icon
				icon.centered = false
				icon.position = (pos - (Vector2(size_in_grid.x * GridData.cell_size.x, size_in_grid.y * GridData.cell_size.y) / 2.0))
