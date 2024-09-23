extends Node2D

#Have you unlocked all the power of @export? (Godot 4.3.x)?
#--Making an Elemental Character with @export, @export_group, and @export_flags
# This is ONLY THE CODE, see the example for more info about the how and why.

enum Classes {WARRIOR, ARCHER, MAGE}
enum {WATER, EARTH, FIRE}

@export_category("Character")
@export var character_class: Classes = Classes.WARRIOR
@export_flags("Water", "Earth", "Fire") var elements: int = 0

func get_character_class_as_string(character_class_choice: Classes) -> String:

	match character_class_choice:
		Classes.WARRIOR:
			return "Warrior"
		Classes.ARCHER:
			return "Archer"
		Classes.MAGE:
			return "Mage"
		_:
			return "Invalid Class Value Provided"

func has_element(index: int) -> bool:
	return (elements & (1 << index)) != 0

func set_element(index: int, boolValue: bool) -> void:
	if boolValue:
		elements |= (1 << index)
	else:
		elements &= ~(1 << index)

func print_character_info() -> void:
	print("""
		Class initialized as: {class}
		
		{class} can currently use these elements:
			|--> Water: {water}
			|--> Earth: {earth}
			`--> Fire: {fire}
	""".format({
		"class": get_character_class_as_string(character_class), 
		"water": has_element(WATER),
		"earth": has_element(EARTH),
		"fire": has_element(FIRE)
		}))

func _ready() -> void: 
	print_character_info()
