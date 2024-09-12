extends StaticBody2D

@export var account_data: FediAccountData

signal body_entered(body)

func _process(delta: float) -> void:
	pass


func _on_delivery_area_body_entered(body):
	body_entered.emit(body)
