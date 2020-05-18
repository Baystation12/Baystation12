/*A god form basically is a combination of a sprite sheet choice and a gameplay choice.
Each plays slightly different and has different challenges/benefits
*/

/datum/god_form
	var/name = "Form"
	var/info = "This is a form your being can take."
	var/desc = "This is the mob's description given."
	var/faction = MOB_FACTION_NEUTRAL //For stuff like mobs and shit
	var/god_icon_state = "nar-sie" //What you look like
	var/pylon_icon_state //What image shows up when appearing in a pylon
	var/mob/living/deity/linked_god = null
	var/starting_power_min = 10
	var/starting_regeneration = 1
	var/list/buildables = list() //Both a list of var changes and a list of buildables.
	var/list/icon_states = list()
	var/list/items

/datum/god_form/New(var/mob/living/deity/D)
	..()
	D.icon_state = god_icon_state
	D.desc = desc
	D.power_min = starting_power_min
	D.power_per_regen = starting_regeneration
	linked_god = D
	if(items && items.len)
		var/list/complete_items = list()
		for(var/l in items)
			var/datum/deity_item/di = new l()
			complete_items[di.name] = di
		D.set_items(complete_items)
		items.Cut()

/datum/god_form/proc/sync_structure(var/obj/O)
	var/list/svars = buildables[O.type]
	if(!svars)
		return
	for(var/V in svars)
		O.vars[V] = svars[V]

/datum/god_form/proc/take_charge(var/mob/living/user, var/charge)
	return 1

/datum/god_form/Destroy()
	if(linked_god)
		linked_god.form = null
		linked_god = null
	return ..()