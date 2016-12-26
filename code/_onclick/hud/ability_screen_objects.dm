/obj/screen/movable/ability_master
	name = "Abilities"
	icon = 'icons/mob/screen_spells.dmi'
	icon_state = "grey_spell_ready"
	var/list/obj/screen/ability/ability_objects = list()
	var/list/obj/screen/ability/spell_objects = list()
	var/showing = 0 // If we're 'open' or not.

	var/open_state = "master_open"		// What the button looks like when it's 'open', showing the other buttons.
	var/closed_state = "master_closed"	// Button when it's 'closed', hiding everything else.

	screen_loc = ui_spell_master // TODO: Rename

	var/mob/my_mob = null // The mob that possesses this hud object.

/obj/screen/movable/ability_master/New(owner)
	if(owner)
		my_mob = owner
		update_abilities(0, owner)
	else
		message_admins("ERROR: ability_master's New() was not given an owner argument.  This is a bug.")
	..()

/obj/screen/movable/ability_master/Destroy()
	. = ..()
	//Get rid of the ability objects.
	remove_all_abilities()
	ability_objects.Cut()

	// After that, remove ourselves from the mob seeing us, so we can qdel cleanly.
	if(my_mob)
		my_mob.ability_master = null
		if(my_mob.client && my_mob.client.screen)
			my_mob.client.screen -= src
		my_mob = null
/*
/obj/screen/movable/ability_master/ResetVars()
	..("ability_objects", args)
	remove_all_abilities()
//	ability_objects = list()
*/
/obj/screen/movable/ability_master/MouseDrop()
	if(showing)
		return

	return ..()

/obj/screen/movable/ability_master/Click()
	if(!ability_objects.len) // If we're empty for some reason.
//		qdel(src)
		return

	toggle_open()

/obj/screen/movable/ability_master/proc/toggle_open(var/forced_state = 0)
	if(showing && (forced_state != 2)) // We are closing the ability master, hide the abilities.
		for(var/obj/screen/ability/O in ability_objects)
			if(my_mob && my_mob.client)
				my_mob.client.screen -= O
//			O.handle_icon_updates = 0
		showing = 0
		overlays.len = 0
		overlays.Add(closed_state)
	else if(forced_state != 1) // We're opening it, show the icons.
		open_ability_master()
		update_abilities(1)
		showing = 1
		overlays.len = 0
		overlays.Add(open_state)
	update_icon()

/obj/screen/movable/ability_master/proc/open_ability_master()
	var/list/screen_loc_xy = splittext(screen_loc,",")

	//Create list of X offsets
	var/list/screen_loc_X = splittext(screen_loc_xy[1],":")
	var/x_position = decode_screen_X(screen_loc_X[1])
	var/x_pix = screen_loc_X[2]

	//Create list of Y offsets
	var/list/screen_loc_Y = splittext(screen_loc_xy[2],":")
	var/y_position = decode_screen_Y(screen_loc_Y[1])
	var/y_pix = screen_loc_Y[2]

	for(var/i = 1; i <= ability_objects.len; i++)
		var/obj/screen/ability/A = ability_objects[i]
		var/xpos = x_position + (x_position < 8 ? 1 : -1)*(i%7)
		var/ypos = y_position + (y_position < 8 ? round(i/7) : -round(i/7))
		A.screen_loc = "[encode_screen_X(xpos)]:[x_pix],[encode_screen_Y(ypos)]:[y_pix]"
		if(my_mob && my_mob.client)
			my_mob.client.screen += A
//			A.handle_icon_updates = 1

/obj/screen/movable/ability_master/proc/update_abilities(forced = 0, mob/user)
	update_icon()
	if(user && user.client)
		if(!(src in user.client.screen))
			user.client.screen += src
	var/i = 1
	for(var/obj/screen/ability/ability in ability_objects)
		ability.update_icon(forced)
		ability.maptext = "[i]" // Slot number
		i++

/obj/screen/movable/ability_master/update_icon()
	if(ability_objects.len)
		invisibility = 0
	else
		invisibility = 101

/obj/screen/movable/ability_master/proc/add_ability(var/name_given)
	if(!name) return
	var/obj/screen/ability/new_button = new /obj/screen/ability
	new_button.ability_master = src
	new_button.name = name_given
	new_button.ability_icon_state = name_given
	new_button.update_icon(1)
	ability_objects.Add(new_button)
	if(my_mob.client)
		toggle_open(2) //forces the icons to refresh on screen

/obj/screen/movable/ability_master/proc/remove_ability(var/obj/screen/ability/ability)
	if(!ability)
		return
	ability_objects.Remove(ability)
	if(istype(ability,/obj/screen/ability/spell))
		spell_objects.Remove(ability)
	qdel(ability)


	if(ability_objects.len)
		toggle_open(showing + 1)
	update_icon()
//	else
//		qdel(src)

/obj/screen/movable/ability_master/proc/remove_all_abilities()
	for(var/obj/screen/ability/A in ability_objects)
		remove_ability(A)

/obj/screen/movable/ability_master/proc/get_ability_by_name(name_to_search)
	for(var/obj/screen/ability/A in ability_objects)
		if(A.name == name_to_search)
			return A
	return null

/obj/screen/movable/ability_master/proc/get_ability_by_proc_ref(proc_ref)
	for(var/obj/screen/ability/verb_based/V in ability_objects)
		if(V.verb_to_call == proc_ref)
			return V
	return null

/obj/screen/movable/ability_master/proc/get_ability_by_instance(var/obj/instance/)
	for(var/obj/screen/ability/obj_based/O in ability_objects)
		if(O.object == instance)
			return O
	return null

/obj/screen/movable/ability_master/proc/get_ability_by_spell(var/spell/s)
	for(var/screen in spell_objects)
		var/obj/screen/ability/spell/S = screen
		if(S.spell == s)
			return S
	return null

/mob/Login()
	..()
	if(ability_master)
		ability_master.update_abilities(1, src)
		ability_master.toggle_open(1)

/mob/New()
	..()
	ability_master = new /obj/screen/movable/ability_master(src)

///////////ACTUAL ABILITIES////////////
//This is what you click to do things//
///////////////////////////////////////
/obj/screen/ability
	icon = 'icons/mob/screen_spells.dmi'
	icon_state = "grey_spell_base"
	maptext_x = 3
	var/background_base_state = "grey"
	var/ability_icon_state = null
	var/obj/screen/movable/ability_master/ability_master

/obj/screen/ability/Destroy()
	if(ability_master)
		ability_master.ability_objects -= src
		if(ability_master.my_mob && ability_master.my_mob.client)
			ability_master.my_mob.client.screen -= src
	if(ability_master && !ability_master.ability_objects.len)
		ability_master.update_icon()
//		qdel(ability_master)
	ability_master = null
	..()

/obj/screen/ability/update_icon()
	overlays.Cut()
	icon_state = "[background_base_state]_spell_base"

	overlays += ability_icon_state

/obj/screen/ability/Click()
	if(!usr)
		return

	activate()

// Makes the ability be triggered.  The subclasses of this are responsible for carrying it out in whatever way it needs to.
/obj/screen/ability/proc/activate()
	to_world("[src] had activate() called.")
	return

// This checks if the ability can be used.
/obj/screen/ability/proc/can_activate()
	return 1

/client/verb/activate_ability(var/slot as num)
	set name = ".activate_ability"
//	set hidden = 1
	if(!mob)
		return // Paranoid.
	if(isnull(slot) || !isnum(slot))
		to_chat(src,"<span class='warning'>.activate_ability requires a number as input, corrisponding to the slot you wish to use.</span>")
		return // Bad input.
	if(!mob.ability_master)
		return // No abilities.
	if(slot > mob.ability_master.ability_objects.len || slot <= 0)
		return // Out of bounds.
	var/obj/screen/ability/A = mob.ability_master.ability_objects[slot]
	A.activate()

//////////Verb Abilities//////////
//Buttons to trigger verbs/procs//
//////////////////////////////////

/obj/screen/ability/verb_based
	var/verb_to_call = null
	var/object_used = null
	var/arguments_to_use = list()

/obj/screen/ability/verb_based/activate()
	if(object_used && verb_to_call)
		call(object_used,verb_to_call)(arguments_to_use)

/obj/screen/movable/ability_master/proc/add_verb_ability(var/object_given, var/verb_given, var/name_given, var/ability_icon_given, var/arguments)
	if(!object_given)
		message_admins("ERROR: add_verb_ability() was not given an object in its arguments.")
	if(!verb_given)
		message_admins("ERROR: add_verb_ability() was not given a verb/proc in its arguments.")
	if(get_ability_by_proc_ref(verb_given))
		return // Duplicate
	var/obj/screen/ability/verb_based/A = new /obj/screen/ability/verb_based()
	A.ability_master = src
	A.object_used = object_given
	A.verb_to_call = verb_given
	A.ability_icon_state = ability_icon_given
	A.name = name_given
	if(arguments)
		A.arguments_to_use = arguments
	ability_objects.Add(A)
	if(my_mob.client)
		toggle_open(2) //forces the icons to refresh on screen

//Changeling Abilities
/obj/screen/ability/verb_based/changeling
	icon_state = "ling_spell_base"
	background_base_state = "ling"

/obj/screen/movable/ability_master/proc/add_ling_ability(var/object_given, var/verb_given, var/name_given, var/ability_icon_given, var/arguments)
	if(!object_given)
		message_admins("ERROR: add_ling_ability() was not given an object in its arguments.")
	if(!verb_given)
		message_admins("ERROR: add_ling_ability() was not given a verb/proc in its arguments.")
	if(get_ability_by_proc_ref(verb_given))
		return // Duplicate
	var/obj/screen/ability/verb_based/changeling/A = new /obj/screen/ability/verb_based/changeling()
	A.ability_master = src
	A.object_used = object_given
	A.verb_to_call = verb_given
	A.ability_icon_state = ability_icon_given
	A.name = name_given
	if(arguments)
		A.arguments_to_use = arguments
	ability_objects.Add(A)
	if(my_mob.client)
		toggle_open(2) //forces the icons to refresh on screen


/////////Obj Abilities////////
//Buttons to trigger objects//
//////////////////////////////

/obj/screen/ability/obj_based
	var/obj/object = null

/obj/screen/ability/obj_based/activate()
	if(object)
		object.Click()

// Technomancer
/obj/screen/ability/obj_based/technomancer
	icon_state = "wiz_spell_base"
	background_base_state = "wiz"

/obj/screen/movable/ability_master/proc/add_technomancer_ability(var/obj/object_given, var/ability_icon_given)
	if(!object_given)
		message_admins("ERROR: add_technomancer_ability() was not given an object in its arguments.")
	if(get_ability_by_instance(object_given))
		return // Duplicate
	var/obj/screen/ability/obj_based/technomancer/A = new /obj/screen/ability/obj_based/technomancer()
	A.ability_master = src
	A.object = object_given
	A.ability_icon_state = ability_icon_given
	A.name = object_given.name
	ability_objects.Add(A)
	if(my_mob.client)
		toggle_open(2) //forces the icons to refresh on screen

// Wizard
/obj/screen/ability/spell
	var/spell/spell
	var/spell_base
	var/last_charge = 0
	var/icon/last_charged_icon

/obj/screen/ability/spell/Destroy()
	if(spell)
		spell.connected_button = null
		spell = null
	return ..()

/obj/screen/movable/ability_master/proc/add_spell(var/spell/spell)
	if(!spell) return

	if(spell.spell_flags & NO_BUTTON) //no button to add if we don't get one
		return

	if(get_ability_by_spell(spell))
		return

	var/obj/screen/ability/spell/A = new()
	A.ability_master = src
	A.spell = spell
	A.name = spell.name

	if(!spell.override_base) //if it's not set, we do basic checks
		if(spell.spell_flags & CONSTRUCT_CHECK)
			A.spell_base = "const" //construct spells
		else
			A.spell_base = "wiz" //wizard spells
	else
		A.spell_base = spell.override_base
	A.update_charge(1)
	spell_objects.Add(A)
	ability_objects.Add(A)
	if(my_mob.client)
		toggle_open(2) //forces the icons to refresh on screen

/mob/Life()
	..()
	if(ability_master)
		ability_master.update_spells(0)

/obj/screen/movable/ability_master/proc/update_spells(var/forced = 0)
	for(var/obj/screen/ability/spell/spell in spell_objects)
		spell.update_charge(forced)

/obj/screen/ability/spell/proc/update_charge(var/forced_update = 0)
	if(!spell)
		qdel(src)
		return

	if(last_charge == spell.charge_counter && !forced_update)
		return //nothing to see here

	overlays -= spell.hud_state

	if(spell.charge_type == Sp_RECHARGE || spell.charge_type == Sp_CHARGES)
		if(spell.charge_counter < spell.charge_max)
			icon_state = "[spell_base]_spell_base"
			if(spell.charge_counter > 0)
				var/icon/partial_charge = icon(src.icon, "[spell_base]_spell_ready")
				partial_charge.Crop(1, 1, partial_charge.Width(), round(partial_charge.Height() * spell.charge_counter / spell.charge_max))
				overlays += partial_charge
				if(last_charged_icon)
					overlays -= last_charged_icon
				last_charged_icon = partial_charge
			else if(last_charged_icon)
				overlays -= last_charged_icon
				last_charged_icon = null
		else
			icon_state = "[spell_base]_spell_ready"
			if(last_charged_icon)
				overlays -= last_charged_icon
	else
		icon_state = "[spell_base]_spell_ready"

	overlays += spell.hud_state

	last_charge = spell.charge_counter

	overlays -= "silence"
	if(spell.silenced)
		overlays += "silence"

/obj/screen/ability/spell/update_icon(var/forced = 0)
	update_charge(forced)
	return

/obj/screen/ability/spell/activate()
	spell.perform(usr)

/obj/screen/movable/ability_master/proc/silence_spells(var/amount)
	for(var/obj/screen/ability/spell/spell in spell_objects)
		spell.spell.silenced = amount
		spell.spell.process()
		spell.update_charge(1)