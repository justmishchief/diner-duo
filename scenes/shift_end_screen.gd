extends Control

@onready var title_label = $Panel/TitleLabel
@onready var info_label = $Panel/InfoLabel
@onready var speed_btn = $Panel/SpeedUpgradeBtn
@onready var cupcake_btn = $Panel/CupcakeBtn
@onready var continue_btn = $Panel/ContinueBtn

func _ready():
	visible = false
	GameManager.shift_ended.connect(_on_shift_ended)
	speed_btn.pressed.connect(_on_speed_upgrade)
	cupcake_btn.pressed.connect(_on_cupcake_unlock)
	continue_btn.pressed.connect(_on_continue)

func _on_shift_ended(day: int, earned: int, rent: int, survived: bool):
	visible = true
	get_tree().paused = true
	
	if survived:
		title_label.text = "Day " + str(day) + " Complete!"
		info_label.text = "Earned Today: $" + str(earned) + "\nRent Paid: -$" + str(rent) + "\nRemaining Savings: $" + str(GameManager.total_coins)
		continue_btn.text = "Start Next Shift"
	else:
		title_label.text = "EVICTED! (Game Over)"
		info_label.text = "You couldn't afford rent of $" + str(rent) + "!\nShort by: $" + str(rent - GameManager.total_coins)
		continue_btn.text = "Restart Day"

func _on_speed_upgrade():
	var cost = GameManager.player_speed_level * 60
	if GameManager.total_coins >= cost:
		GameManager.total_coins -= cost
		GameManager.player_speed_level += 1
		speed_btn.text = "Shoes Lvl " + str(GameManager.player_speed_level) + " ($" + str(GameManager.player_speed_level * 60) + ")"
		info_label.text = "Savings: $" + str(GameManager.total_coins)
		GameManager.emit_signal("stats_updated")

func _on_cupcake_unlock():
	var cost = 150
	if GameManager.total_coins >= cost and not GameManager.cupcake_unlocked:
		GameManager.total_coins -= cost
		GameManager.cupcake_unlocked = true
		cupcake_btn.disabled = true
		cupcake_btn.text = "Cupcakes Active! (Earns $120)"
		info_label.text = "Savings: $" + str(GameManager.total_coins)
		GameManager.emit_signal("stats_updated")

func _on_continue():
	if GameManager.total_coins < GameManager.daily_rent and not GameManager.is_shift_active:
		# Restart day logic
		GameManager.total_coins = 0
		GameManager.daily_earnings = 0
		GameManager.time_left = GameManager.shift_duration
		GameManager.is_shift_active = true
	else:
		GameManager.start_next_day()
		
	visible = false
	get_tree().paused = false
