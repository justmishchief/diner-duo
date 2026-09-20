extends Node2D

@export var customer_scene: PackedScene
@export var money_label: Label

var menu = {
	"Coffee": 40,
	"Tea": 25,
	"Beer": 35,
	"Burger": 80,
	"Croissant": 50
}

var archetypes = {
	"Regular": {"patience": 15.0, "tip_mult": 1.0},
	"Rusher": {"patience": 8.0, "tip_mult": 1.2},
	"Picky": {"patience": 20.0, "tip_mult": 1.5},
	"BigSpender": {"patience": 15.0, "tip_mult": 2.0}
}

var total_coins: int = 0

func _ready():
	GameManager.stats_updated.connect(update_money_ui)
	update_money_ui()

func update_money_ui():
	if money_label:
		money_label.text = "Money: " + str(total_coins)

func spawn_customer():
	if not GameManager.is_shift_active:
		return
	if GameManager.cupcake_unlocked and not menu.has("Max's Cupcake"):
		menu["Max's Cupcake"]= 120
		
	var archetype_keys = archetypes.keys()
	var chosen = archetype_keys[randi() % archetype_keys.size()]
	var data = archetypes[chosen]

	var menu_items = menu.keys()
	var chosen_item = menu_items[randi() % menu_items.size()]

	var customer = customer_scene.instantiate()
	customer.archetype_name = chosen
	customer.patience_time = data["patience"]
	customer.current_order = chosen_item
	customer.base_pay = menu[chosen_item]
	customer.tip_multiplier = data["tip_mult"]
	customer.position = Vector2(150, 0)

	customer.order_completed.connect(_on_customer_order_completed)
	customer.order_failed.connect(_on_customer_order_failed)

	add_child(customer)

func _on_customer_order_completed(amount: int, _mood: String):
	GameManager.add_money(amount)
func _on_customer_order_failed(penalty: int):
	GameManager.deduct_penalty(penalty)

func _on_timer_timeout():
	spawn_customer()
