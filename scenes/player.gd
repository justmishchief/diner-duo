extends CharacterBody2D

const SPEED = 200.0
var nearby_customer = null
var nearby_station = null
var held_item: String = ""
var money:int = 0
@onready var money_label = get_node("/root/Main/UI/MoneyLabel")

func _physics_process(delta):
	var direction = Vector2.ZERO
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	direction = direction.normalized()
	velocity = direction * SPEED
	move_and_slide()

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		if nearby_station != null:
			nearby_station.cycle_item()
			held_item = nearby_station.get_current_item()
			print("Holding: ", held_item)
		elif nearby_customer != null and held_item != "":
			var pay = nearby_customer.base_pay
			var success = nearby_customer.serve(held_item)
			if success:
				money += pay
				money_label.text = "Money: " + str(money)
				print("Money: ", money)
			held_item = ""
	
func _on_detection_zone_area_entered(area: Area2D) -> void:
	if area.name == "InteractionZone":
		nearby_customer = area.get_parent()
		print("Near customer: ", nearby_customer.archetype_name)
	elif area.name == "Station":
		nearby_station = area
		print("Near station")

func _on_detection_zone_area_exited(area: Area2D) -> void:
	if area.name == "InteractionZone":
		nearby_customer = null
		print("Left customer range")
	elif area.name == "Station":
		nearby_station = null
		print("Left station")
