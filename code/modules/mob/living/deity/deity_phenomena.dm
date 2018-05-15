/mob/living/deity
	var/list/phenomenas = list()
	var/list/intent_phenomenas = list()
	var/static/list/control_types = list("control", "controlshift", "shift")


/mob/living/deity/New()
	..()
	for(var/intent in intents) //Just in case we somehow remove/add a new intent #futureproofing
		populate_intent(intent)
	set_phenomena(add_phenomena(/datum/phenomena/communicate), I_HELP, "shift")
	set_phenomena(add_phenomena(/datum/phenomena/punish), I_HELP, "control")
	set_phenomena(add_phenomena(/datum/phenomena/point), I_HELP, "controlshift")
	set_phenomena(add_phenomena(/datum/phenomena/conversion), I_GRAB, "shift")
	set_phenomena(add_phenomena(/datum/phenomena/forced_conversion), I_GRAB, "control")

/mob/living/deity/Destroy()
	for(var/phenom in phenomenas)
		remove_phenomena(phenom)
	return ..()

/mob/living/deity/proc/add_phenomena(var/type)
	if(!phenomenas)
		phenomenas = list()
	for(var/P in phenomenas)
		if(istype(phenomenas[P], type))
			return
	var/datum/phenomena/P = new type(src)
	phenomenas[P.name] = P
	return P

/mob/living/deity/proc/remove_phenomena_from_intent(var/intent, var/modifier, var/update = 1)
	var/list/intent_list = intent_phenomenas[intent]
	intent_list[modifier] = null
	if(update)
		update_phenomena_bindings()

/mob/living/deity/proc/remove_phenomena(var/datum/phenomena/to_remove)
	phenomenas[to_remove.name] = null
	phenomenas -= to_remove.name
	for(var/intent in intent_phenomenas)
		var/list/intent_list = intent_phenomenas[intent]
		for(var/mod in intent_list)
			if(intent_list[mod] == to_remove)
				intent_list[mod] = null
	qdel(to_remove)

/mob/living/deity/proc/populate_intent(var/intent)
	if(!intent_phenomenas[intent])
		intent_phenomenas[intent] = list()
	intent_phenomenas[intent] |= control_types

/mob/living/deity/proc/set_phenomena(var/datum/phenomena/phenomena, var/intent, var/modifiers)
	if(!intent_phenomenas[intent])
		populate_intent(intent)
	var/list/intent_list = intent_phenomenas[intent]
	intent_list[modifiers] = phenomena

/mob/living/deity/proc/get_phenomena(var/shift = 0, var/control = 0)
	var/list/intent_list = intent_phenomenas[a_intent]
	if(intent_list)
		var/type = ""
		if(shift)
			type = "shift"
		if(control)
			type = "control[type]"
		if(intent_list[type])
			return intent_list[type]
	return null