extends CharacterBody2D

signal order_completed(amount: int, mood: String)
signal order_failed(penalty: int)

@export var archetype_name: String = "Regular"
@export var patience_time: float = 15.0
@export var base_pay: int = 40
@export var tip_multiplier: float = 1.0

var current_order: String = ""
var time_left: float
var is_served: bool = false

func _ready():
	time_left = patience_time
	print(archetype_name, " wants: ", current_order, " | Pay: ", base_pay)

func _process(delta):
	if is_served:
		return
	if time_left > 0:
		time_left -= delta
		if time_left <= 0:
			leave_unhappy()

func leave_unhappy():
	is_served = true
	var penalty = 20
	print(archetype_name, " left unhappy! Penalty: -", penalty)
	emit_signal("order_failed", penalty)
	queue_free()

func serve_order():
	if is_served:
		return
	is_served = true
	var ratio = time_left / patience_time
	var mood = "Angry"
	var final_pay = int(base_pay * 0.5)

	if ratio > 0.5:
		mood = "Happy"
		final_pay = int((base_pay + 15) * tip_multiplier)
	elif ratio > 0.2:
		mood = "Neutral"
		final_pay = base_pay

	print("Served ", archetype_name, "! Mood: ", mood, " | Earned: ", final_pay)
	emit_signal("order_completed", final_pay, mood)
	queue_free()
