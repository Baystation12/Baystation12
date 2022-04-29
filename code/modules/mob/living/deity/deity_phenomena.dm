/mob/living/deity/var/silenced = FALSE
/mob/living/deity/var/list/phenomenas = list()
/mob/living/deity/var/list/intent_phenomenas = list()
/mob/living/deity/var/static/list/control_types = list("control", "controlshift", "shift")


/mob/living/deity/New()
	..()
	for(var/intent in intents) //Just in case we somehow remove/add a new intent #futureproofing
		populate_intent(intent)
	set_phenomena(add_phenomena(/datum/phenomena/communicate), I_HELP, "shift")
	set_phenomena(add_phenomena(/datum/phenomena/punish), I_HELP, "control")
	set_phenomena(add_phenomena(/datum/phenomena/point), I_HELP, "controlshift")
	set_phenomena(add_phenomena(/datum/phenomena/conversion), I_GRAB, "shift")
	set_phenomena(add_phenomena(/datum/phenomena/forced_conversion), I_GRAB, "control")

/mob/living/deity/proc/silence(amount)
	if(!silenced)
		to_chat(src, SPAN_WARNING("You've been silenced! Your phenomenas are disabled!"))
		var/obj/screen/intent/deity/SD = hud_used.action_intent
		SD.color = "#ff0000"
	silenced += amount
	for(var/phenom in phenomenas) //Also make it so that you don't do cooldowns.
		var/datum/phenomena/P = phenomenas[phenom]
		if(P.refresh_time)
			P.refresh_time += amount

/mob/living/deity/Life()
	. = ..()
	if(. && silenced)
		if(!--silenced)
			to_chat(src, SPAN_NOTICE("You are no longer silenced."))
			var/obj/screen/intent/deity/SD = hud_used.action_intent
			SD.color = null

/mob/living/deity/Destroy()
	for(var/phenom in phenomenas)
		remove_phenomena(phenom)
	return ..()

/mob/living/deity/proc/add_phenomena(type)
	if(!phenomenas)
		phenomenas = list()
	for(var/P in phenomenas)
		if(istype(phenomenas[P], type))
			return
	var/datum/phenomena/P = new type(src)
	phenomenas[P.name] = P
	return P

/mob/living/deity/proc/remove_phenomena_from_intent(intent, modifier, update = TRUE)
	var/list/intent_list = intent_phenomenas[intent]
	intent_list[modifier] = null
	if(update)
		update_phenomena_bindings()

/mob/living/deity/proc/remove_phenomena(to_remove)
	var/datum/phenomena/P = phenomenas[to_remove]
	phenomenas -= to_remove
	for(var/intent in intent_phenomenas)
		var/list/intent_list = intent_phenomenas[intent]
		for(var/mod in intent_list)
			if(intent_list[mod] == P)
				intent_list[mod] = null
	var/obj/screen/intent/deity/SD = hud_used.action_intent
	SD.update_text()
	update_phenomenas()
	update_phenomena_bindings()
	if(selected == to_remove)
		selected = null
	qdel(P)

/mob/living/deity/proc/populate_intent(intent)
	if(!intent_phenomenas[intent])
		intent_phenomenas[intent] = list()
	intent_phenomenas[intent] |= control_types

/mob/living/deity/proc/set_phenomena(datum/phenomena/phenomena, intent, modifiers)
	if(!intent_phenomenas[intent])
		populate_intent(intent)
	var/list/intent_list = intent_phenomenas[intent]
	intent_list[modifiers] = phenomena

/mob/living/deity/proc/get_phenomena(shift = FALSE, control = FALSE)
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
