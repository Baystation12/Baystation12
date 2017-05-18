/mob/living/deity
	var/list/phenomenas = list()
	var/list/intent_phenomenas = list()


/mob/living/deity/New()
	..()
	for(var/intent in intents) //Just in case we somehow remove/add a new intent #futureproofing
		populate_intent(intent)
	set_phenomena(add_phenomena(/datum/phenomena/communicate), I_HELP, "shift")
	set_phenomena(add_phenomena(/datum/phenomena/punish), I_HELP, "control")
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

/mob/living/deity/proc/remove_phenomena_from_intent(var/datum/phenomena/to_remove)
	for(var/intent in intent_phenomenas)
		var/list/intent_list = intent_phenomenas[intent]
		for(var/modifier in intent_list)
			if(intent_list[modifier] == to_remove)
				intent_list[modifier] = null
				break

/mob/living/deity/proc/remove_phenomena(var/datum/phenomena/to_remove)
	phenomenas[to_remove.name] = null
	phenomenas -= to_remove.name
	remove_phenomena_from_intent(to_remove)
	qdel(to_remove)

/mob/living/deity/proc/populate_intent(var/intent)
	if(!intent_phenomenas[intent])
		intent_phenomenas[intent] = list()
	intent_phenomenas[intent] |= list("shift", "control", "controlshift")

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

/mob/living/deity/verb/configure_phenomenas()
	set name = "Configure Phenomena"
	set category = "Godhood"

	var/dat = "<h3>Phenomena Configuration</h3><br><br>"
	for(var/intent in intents)
		dat += "<b>[capitalize(intent)]</b><br>"
		var/list/intent_list = intent_phenomenas[intent]
		if(!intent_list)
			continue
		dat += "<table border='1' style='width:100%;border-collapse:collapse;'><tr><th>Modifier</th><th>Linked Phenomena</th></tr>"
		for(var/modifier in intent_list)
			var/datum/phenomena/P = intent_list[modifier]
			dat += "<tr><td><A href='?src=\ref[src];intent=[intent];modifier=[modifier]'>[modifier]</a></td><td>[P ? "[P.name] ([P.cost] Power)" : "None"]</td>"
		dat += "</table><br><br>"
	show_browser(src, dat, "window=phenomena")