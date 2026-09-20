extends CharacterBody2D

const SPEED = 200.0
var nearby_customer = null

func _physics_process(_delta):
	var direction = Vector2.ZERO
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	direction = direction.normalized()
	velocity = direction * SPEED
	move_and_slide()

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		if nearby_customer != null:
			nearby_customer.serve_order()

func _on_detection_zone_area_entered(area: Area2D) -> void:
	if area.name == "InteractionZone":
		nearby_customer = area.get_parent()

func _on_detection_zone_area_exited(area: Area2D) -> void:
	if area.name == "InteractionZone":
		nearby_customer = null
