class_name Global
extends Node

signal battery_collected

func emit_battery_collected():
	emit_signal("battery_collected")