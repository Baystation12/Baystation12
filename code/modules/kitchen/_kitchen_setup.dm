/*
	This system is designed to move away from the 'magical microwave' way of cooking.  Instead of putting everything into
	a microwave and turning it on, you place different food items into a 'container' (like a frying pan), heat it up,
	then take it out when done.

	Instead of half a billion different subtypes for food, there will only be one for each 'class' of food, e.g. one for cakes,
	one for pies, one for pizza, etc etc.  When finish() is called on the container, a new 'finished' food is instantiated, and
	all of the contents of the container are placed inside.  The new finished food then runs New(), which runs a proc to
	change the name, desc, reagents, and a few other variables, depending on the contents of the food, changing, say, just a cake
	to 'banana-lime cake'.

	METHOD_BOILING: pot + stove
	METHOD_FRYING: frying pan + stove
	METHOD_BAKING: cake tin or baking tray + oven
	METHOD_SLICING, METHOD_DICING: use a kitchen knife.

*/

#define METHOD_SLICING "slice"
#define METHOD_DICING  "dice"
#define METHOD_FRYING  "fry"
#define METHOD_BOILING "boil"
#define METHOD_BAKING  "bake"
#define METHOD_MIXING  "mix"

var/list/food_transitions = list()
var/list/ignore_transition_types = list(
	/datum/food_transition,
	/datum/food_transition/boiled,
	/datum/food_transition/fried,
	/datum/food_transition/baked,
	/datum/food_transition/grown,
	/datum/food_transition/diced,
	/datum/food_transition/mixed
	)

proc/populate_food_transitions()
	food_transitions = list()
	for(var/transition_type in (typesof(/datum/food_transition)-ignore_transition_types))
		var/datum/food_transition/T = new transition_type
		if(isnull(T.cooking_method))
			continue
		if(!islist(food_transitions[T.cooking_method]))
			food_transitions[T.cooking_method] = list()
		food_transitions[T.cooking_method] |= T

proc/get_food_transition(var/obj/item/I, var/method, var/cooking_time, var/datum/reagents/input_reagents, var/obj/item/container)
	if(!islist(food_transitions) || !food_transitions.len)
		populate_food_transitions()
	var/list/transitions = food_transitions[method]
	if(!islist(transitions) || !transitions.len)
		return null
	var/datum/food_transition/high_priority
	for(var/datum/food_transition/F in transitions)
		if(cooking_time >= F.cooking_time && F.matches_input_type(I, container) && F.check_for_reagents(input_reagents))
			if(!high_priority || high_priority.priority < F.priority)
				high_priority = F
	return high_priority

/datum/admins/proc/debug_food_transitions()
	set category = "Debug"
	set name = "Show Recipe List"
	set desc = "List all recipes."

	if(!check_rights(R_SPAWN)) return
	usr << "Not implemented yet, sry."