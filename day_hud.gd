extends CanvasLayer
@onready var clock_label = $ClockLabel
@onready var day_label = $DayLabel

func _process(_delta):
	if GameManager.is_shift_active:
		var mins = int(GameManager.time_left) / 60
		var secs = int(GameManager.time_left) % 60
		clock_label.text = "Shift Time: %02d:%02d" % [mins, secs]
		day_label.text = "Day " + str(GameManager.current_day) + " (Rent: $" + str(GameManager.daily_rent) + ")"
	else:
		clock_label.text = "Shift Over!"
