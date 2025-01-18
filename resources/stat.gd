class_name Stat
extends Resource
## Stat 1.0 [br]
## By GildedBirch

## Emitted when value_total becomes 0
signal value_zero
## Emitted when value, temp, max, or max_bonus gets updated [br]
## Good for updating UI
signal value_changed

## Current value of stat
var value: float = 0.0:
	set(value_in):
		value = clampf(value_in, 0.0, max_total())
		value_changed.emit()
		if value_total() <= 0.0: value_zero.emit()

## Base max value if stat
@export var max_value: float = 1.0:
	set(value_in):
		max_value = max(0.0, value_in)
		if max_total() < value:
			value = max_total()
		else:
			value_changed.emit()

## Bonus to max value of stat
@export var max_bonus: float = 0.0:
	set(value_in):
		max_bonus = max(0.0, value_in)
		if max_total() < value:
			value = max_total()
		else:
			value_changed.emit()

## Temporary increase in stat. Can go over max_total
@export var temp_value: float = 0.0:
	set(value_in):
		temp_value = max(0.0, value_in)
		value_changed.emit()
		if value_total() <= 0.0: value_zero.emit()

## Total of maxium stat with bonus
func max_total() -> float:
	return max_value + max_bonus

## Total of current value with temp
func value_total() -> float:
	return value + temp_value

## Print for debug purposes
func _print_stat():
	print("%s(%s+%s) / %s(%s+%s)" % [value_total(), value, temp_value, max_total(), max_value, max_bonus])
