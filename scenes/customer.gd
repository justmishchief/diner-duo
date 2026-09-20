extends CharacterBody2D

@export var archetype_name: String = "Regular"
@export var patience_time: float = 15.0
@export var base_pay: int = 10

var current_order: String = ""
var time_left: float
var is_served: bool = false

func _ready():
	time_left = patience_time
	generate_order()

func generate_order():
	var possible_orders = ["Coffee", "Sandwich", "Salad", "Burger"]
	current_order = possible_orders[randi() % possible_orders.size()]
	print(archetype_name, " ordered: ", current_order)

func _process(delta):
	if time_left > 0:
		time_left -= delta
		if time_left <= 0:
			leave_unhappy()

func leave_unhappy():
	print(archetype_name, " left unhappy!")
	queue_free()

func serve(item_given: String)->bool:
	if is_served:
		return false
	if item_given == current_order:
		print(archetype_name, " served! Earned: ", base_pay)
		is_served = true
		queue_free()
		return true
	else:
		print("Wrong item! Customer wanted: ", current_order)
		return false
