extends Node2D

@export var customer_scene: PackedScene

var archetypes = {
	"Regular": {"patience": 15.0, "pay": 10},
	"Rusher": {"patience": 8.0, "pay": 10},
	"Picky": {"patience": 20.0, "pay": 20},
	"BigSpender": {"patience": 15.0, "pay": 40}
}

func spawn_customer():
	var archetype_keys = archetypes.keys()
	var chosen = archetype_keys[randi() % archetype_keys.size()]
	var data = archetypes[chosen]
	
	var customer = customer_scene.instantiate()
	customer.archetype_name = chosen
	customer.patience_time = data["patience"]
	customer.base_pay = data["pay"]
	customer.position = Vector2(150, 0)
	
	add_child(customer)

func _on_timer_timeout():
	spawn_customer()
