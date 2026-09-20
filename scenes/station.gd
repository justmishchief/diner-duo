extends Area2D

var available_items = ["Coffee","Sandwich","Salad","Burger"]
var current_index = 0

func get_current_item()->String:
	return available_items[current_index]
	
func cycle_item():
	current_index = (current_index + 1)% available_items.size()
	print("Selected item:",get_current_item())
