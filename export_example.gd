extends Node2D

#Have you unlocked all the power of @export? (Godot 4.3.x)?
#--Making an Elemental Character with @export, @export_group, and @export_flags

#  @export has a LOT of cool stuff you can do with it, that also makes it easy 
#  to add stuff to the editor to see and change. Let's look at a small fragment
#  of that by making an elemental character.
#
#  ***PLEASE NOTE: That the func and variable declarations are out of order in this 
#  example to make it easier to see how the example fits together. Please make 
#  sure to properly order your variable, enum, and func declarations so you don't
#  get a fish thrown at you by someone reading your code.***

#----- Enum Declaration -----#
#define a Named enum for in-game class choices
enum Classes {WARRIOR, ARCHER, MAGE}
#define an enum for elements used later in bit flags, this MUST be in the same order.
enum {WATER, EARTH, FIRE}
#----- Categories -----#
#  @export_category lets you add a category into the inspector in the Godot editor.
#  Notice how Character has its own section? This is handy for grouping exports 
#  that you want to be grouped together and visually distinguishable by category; 
#  In this case, Character will group character related values so we can quickly 
#  go to that section in the editor inspectror panel and see and change values.
@export_category("Character")

#----- Character Class Drop Down -----#
#  You can export an enum to have a choice become a drop down of the values.
#  In this case, we have an in-game class choice for our character stored as a
#  named enum value. 
#  *(Tip: Using typing or inferred typing helps with clarity and readability;
#  in this case we type it to the named enum.)
@export var character_class: Classes = Classes.WARRIOR
#  Now let's make a function to fetch this value and make it human readable for 
#  print()'ing; in a more advanced case you can use get/set to make this even
# 	simpler, but let's save that for another day!
func get_character_class_as_string(character_class_choice: Classes) -> String:
	#let's use a match statement for brevity
	match character_class_choice:
		Classes.WARRIOR:
			return "Warrior"
		Classes.ARCHER:
			return "Archer"
		Classes.MAGE:
			return "Mage"
		_:
			#Put whatever value or logic you want here as this is catching an 
			#if an invalid value is provided; in our case we just need to return 
			#a string for this function.
			return "Invalid Class Value Provided"
#----- Export Flags -----#
#  Now that we havbe a character class for our character, let's add some elements!
#  Note that this section is wading into some lower level stuff with bitwise flags
#  and bitwise operators. They seem scary if you havent used them before/much, 
#  but they give us some neat tools to add to our game dev toolbelt.
#
#  First, we define some bit flags using export_flags, these let us choose what 
#  elements our character can use easily in the editor; this stores the choices 
#  as bit values (which must be powers of 2, as the boolean value needs an on and 
#  an off state. Do note, the lowest allowed value is 1, as 0 bit is reserved 
#  for the 'nothing here' state). Then we initialize a var with a default value, 
#  in this case we use 0 for nothing. 
@export_flags("Water", "Earth", "Fire") var elements: int = 0
#  please note, for ease of example we defined an enum earlier mirroring these
#  values (enum {WATER, EARTH, FIRE}) to eliminate the "magic numbers" when 
#  reading this code. Since we mirrored the values, and enums store as integers, 
#  we can effectively show what each integer index in the bit_flags is.
#
#  Now let's make a basic function that takes an index integer, in this case
#  we pass in the enum element (stored as an integer in the enum), 
#  then we have our function perform a bitwise operation to check the value and 
#  return a boolean if the value in the bit flag is true or false; this IS more 
#  complicated than a simple set of exported booleans, but is techically more 
#  performant and also a useful tool to know as projects grow as you can group 
#  specific values easier. 
#  (You don't need to be an expert in bitwise stuff to use these, and they aren't 
#  as scary as they may seem.)
func has_element(index: int) -> bool:
	# Here we shift the value of 1 to the left by index amount, to match the bit
	# for the element. It doesn't need to make total sense, but doing knowing how
	# to do this allows us to evaluate the values in the bit flags easily.
	return (elements & (1 << index)) != 0
#
#  Finally, let's make a function to set the values in code for when we inevitably
#  need it. This allows us to sety the values in GDScript during run time.
func set_element(index: int, boolValue: bool) -> void:
	if boolValue:
		elements |= (1 << index)  # Set the bit to 1
	else:
		elements &= ~(1 << index)  # Clear the bit (set to 0)

#----- Checking it works -----#
#  Now lets make sure it all works, since we should always perform at least a 
#  cursory check of our code (not getting into unit tests here, but those are swell).
func _ready() -> void: 
	#For the character class we initalized it with the value of Warrior, so lets
	#check it using the helper function we made for it:
	print("Class initialized as: ", get_character_class_as_string(character_class))
	#Great! Now lets start checking the rest.
	#We declared the initial value of elements as 0, so nothing was set to true.
	print("#----------#")
	print("Has water: ", has_element(WATER))
	print("Has Earth: ", has_element(EARTH))
	print("Has Fire: ", has_element(FIRE))
	print("#----------#\n")
	#OK, great! Now lets try setting the value for Earth to true. Remember that 
	#we defined a seperate enum to make the code more readable, so we can use 
	#that for the index here.
	set_element(EARTH, true)
	#Now we check that Earth is set correctly and it didn't jimmy with the other 
	#bits:
	print("#----------#")
	print("Has water after setting Earth: ", has_element(WATER))
	print("Has Earth after setting Earth: ", has_element(EARTH))
	print("Has Fire after setting Earth: ", has_element(FIRE))
	print("#----------#\n")
	#now everything together, we have a character with a class and access to multiple
	#elements. And with a small fraction of the power of @exports, its readable,
	# easy to change in the editor, and also manipulate with code!
	# lets see how it all fits together:
	print("#----------#")
	print("Character Class: ", get_character_class_as_string(character_class))
	print(get_character_class_as_string(character_class) + " elements: ")
	print("  --> Water: ", has_element(WATER))
	print("  --> Earth: ", has_element(EARTH))
	print("  --> Fire: ", has_element(FIRE))
	print("#----------#\n")
	
	print("Great work making it this far!\nYou Rock!\n")
