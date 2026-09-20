extends Node

var current_day: int=1
var shift_duration: float = 60.0
var time_left: float = 60.0
var is_shift_active: bool = true

var total_coins: int = 0
var daily_earnings: int = 0
var daily_rent: int = 120
var rent_increment: int = 40

var player_speed_level: int = 1
var cupcake_unlocked: bool = false

signal shift_ended(day: int, earned: int, rent: int, survived: bool)
signal stats_updated

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	time_left = shift_duration 
func _process(delta):
	if is_shift_active:
		time_left -= delta
	if time_left <= 0.0:
		end_shift()

func add_money(amount: int):
	daily_earnings += amount
	total_coins += amount
	emit_signal("status_updated")
	
func deduct_penalty(penalty: int):
	daily_earnings = max(0, daily_earnings - penalty)
	emit_signal("status_updated")
	
func end_shift():
	is_shift_active = false
	var survived = total_coins >= daily_rent
	if survived:
		total_coins -= daily_rent
		emit_signal("shift_ended", current_day, daily_earnings, daily_rent, survived)
		
func start_next_day():
	current_day += 1
	daily_rent += rent_increment 
	daily_earnings = 0 
	time_left = shift_duration 
	is_shift_active = true
	emit_signal("status_updated")
	
			
