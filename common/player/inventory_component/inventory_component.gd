class_name InventoryComponent
extends Node

var mineral_counts: Dictionary[Mineral, int]

func add_mineral(mineral: Mineral):
	if mineral_counts.has(mineral):
		mineral_counts[mineral] += 1
	else:
		mineral_counts.set(mineral, 1)
