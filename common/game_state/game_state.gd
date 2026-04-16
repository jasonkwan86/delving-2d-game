extends Node

var gem_count: int = 0
var has_speed_boost: bool = false
var has_double_jump: bool = false
var shop_unlocked: bool = false

const SHOP_UNLOCK_THRESHOLD: int = 5
const SPEED_BOOST_COST: int = 5
const DOUBLE_JUMP_COST: int = 8

signal gems_changed(new_amount: int)
signal upgrades_changed()
signal shop_just_unlocked()
signal gem_pickup_message(text: String)

func add_gems(amount: int) -> void:
	gem_count += amount
	gems_changed.emit(gem_count)

	if not shop_unlocked:
		var remaining: int = SHOP_UNLOCK_THRESHOLD - gem_count
		if remaining <= 0:
			shop_unlocked = true
			gem_pickup_message.emit("Shop unlocked! Press E to buy upgrades.")
			shop_just_unlocked.emit()
		else:
			gem_pickup_message.emit("%d gem%s till shop access" % [remaining, "" if remaining == 1 else "s"])

func can_afford(cost: int) -> bool:
	return gem_count >= cost

func buy_speed_boost() -> bool:
	if has_speed_boost or gem_count < SPEED_BOOST_COST:
		return false
	gem_count -= SPEED_BOOST_COST
	has_speed_boost = true
	gems_changed.emit(gem_count)
	upgrades_changed.emit()
	return true

func buy_double_jump() -> bool:
	if has_double_jump or gem_count < DOUBLE_JUMP_COST:
		return false
	gem_count -= DOUBLE_JUMP_COST
	has_double_jump = true
	gems_changed.emit(gem_count)
	upgrades_changed.emit()
	return true
