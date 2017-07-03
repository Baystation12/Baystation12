/datum/grab

	var/type_name
	var/state_name
	var/fancy_desc

	var/datum/grab/upgrab						// The grab that this will upgrade to if it upgrades, null means no upgrade
	var/datum/grab/downgrab						// The grab that this will downgrade to if it downgrades, null means break grab on downgrade

	var/datum/time_counter						// For things that need to be timed

	var/stop_move = 0							// Whether or not the grabbed person can move out of the grab
	var/force_stand = 0							// Whether or not the grabbed person is forced to be standing
	var/reverse_facing = 0						// Whether the person being grabbed is facing forwards or backwards.
	var/can_absorb = 0							// Whether this grab state is strong enough to, as a changeling, absorb the person you're grabbing.
	var/shield_assailant = 0					// Whether the person you're grabbing will shield you from bullets.,,
	var/point_blank_mult = 1					// How much the grab increases point blank damage.
	var/same_tile = 0							// If the grabbed person and the grabbing person are on the same tile.
	var/ladder_carry = 0						// If the grabber can carry the grabbed person up or down ladders.
	var/can_throw = 0							// If the grabber can throw the person grabbed.
	var/downgrade_on_action = 0					// If the grab needs to be downgraded when the grabber does stuff.
	var/downgrade_on_move = 0					// If the grab needs to be downgraded when the grabber moves.
	var/force_danger = 0						// If the grab is strong enough to be able to force someone to do something harmful to them.


	var/grab_slowdown = 7

	var/shift = 0

	var/success_up = "You upgrade the grab."
	var/success_down = "You downgrade the grab."

	var/fail_up = "You fail to upgrade the grab."
	var/fail_down = "You fail to downgrade the grab."

	var/upgrab_name
	var/downgrab_name

	var/icon
	var/icon_state

	var/upgrade_cooldown = 40
	var/action_cooldown = 40

	var/can_downgrade_on_resist = 1
	var/list/break_chance_table = list(100)
	var/breakability = 2

/*
	These procs shouldn't be overriden in the children unless you know what you're doing with them; they handle important core functions.
	Even if you do override them, you should likely be using ..() if you want the behaviour to function properly. That is, of course,
	unless you're writing your own custom handling of things.
*/

/datum/grab/proc/refresh_updown()
	if(upgrab_name)
		upgrab = all_grabstates[upgrab_name]

	if(downgrab_name)
		downgrab = all_grabstates[downgrab_name]

// This is for the strings defined as datum variables. It takes them and swaps out keywords for relevent ones from the grab
// object involved.
/datum/grab/proc/string_process(var/obj/item/grab/G, var/to_write, var/obj/item/used_item)
	to_write = replacetext(to_write, "rep_affecting", G.affecting)
	to_write = replacetext(to_write, "rep_assailant", G.assailant)
	if(used_item)
		to_write = replacetext(to_write, "rep_item", used_item)
	return to_write

/datum/grab/proc/upgrade(var/obj/item/grab/G)
	if(!upgrab)
		return

	if (can_upgrade())
		upgrade_effect(G)
		admin_attack_log(G.assailant, G.affecting, "upgraded to [upgrab.state_name]", "was upgraded to [upgrab.state_name]", "upgraded to [upgrab.state_name]")
		return upgrab
	else
		to_chat(G.assailant, "<span class='warning'>[string_process(G, fail_up)]</span>")
		return

/datum/grab/proc/downgrade(var/obj/item/grab/G)
	// Starts the process of letting go if there's no downgrade grab
	if(can_downgrade())
		downgrade_effect(G)
		return downgrab
	else
		to_chat(G.assailant, "<span class='warning'>[string_process(G, fail_down)]</span>")
		return

/datum/grab/proc/let_go(var/obj/item/grab/G)
	let_go_effect(G)
	G.force_drop()

/datum/grab/proc/process(var/obj/item/grab/G)
	var/diff_zone = G.target_change()
	if(diff_zone && G.special_target_functional)
		special_target_change(G, diff_zone)
	else
		special_target_effect(G)

	process_effect(G)

/datum/grab/proc/throw_held(var/obj/item/grab/G)
	var/mob/living/carbon/human/affecting = G.affecting

	if(can_throw)
		animate(affecting, pixel_x = 0, pixel_y = 0, 4, 1)
		qdel(G)
		return affecting
	return null

/datum/grab/proc/hit_with_grab(var/obj/item/grab/G)
	if(downgrade_on_action)
		G.downgrade()
		return

	if(!on_hit_special(G) && G.check_action_cooldown())
		var/reset_action_cooldown = 0
		switch(G.assailant.a_intent)
			if(I_HELP)
				reset_action_cooldown = on_hit_help(G)
			if(I_DISARM)
				reset_action_cooldown = on_hit_disarm(G)
			if(I_GRAB)
				reset_action_cooldown = on_hit_grab(G)
			if(I_HURT)
				reset_action_cooldown = on_hit_harm(G)
		if(reset_action_cooldown)
			G.action_used()
	else
		to_chat(G.assailant, "<span class='warning'>You must wait before you can do that.</span>")

/datum/grab/proc/adjust_position(var/obj/item/grab/G)
	var/mob/living/carbon/human/affecting = G.affecting
	var/mob/living/carbon/human/assailant = G.assailant
	var/adir = get_dir(assailant, affecting)

	if(same_tile)
		affecting.forceMove(assailant.loc)
		adir = assailant.dir
		affecting.set_dir(assailant.dir)

	switch(adir)
		if(NORTH)
			animate(affecting, pixel_x = 0, pixel_y =-shift, 5, 1, LINEAR_EASING)
			G.draw_affecting_under()
		if(SOUTH)
			animate(affecting, pixel_x = 0, pixel_y = shift, 5, 1, LINEAR_EASING)
			G.draw_affecting_over()
		if(WEST)
			animate(affecting, pixel_x = shift, pixel_y = 0, 5, 1, LINEAR_EASING)
			G.draw_affecting_under()
		if(EAST)
			animate(affecting, pixel_x =-shift, pixel_y = 0, 5, 1, LINEAR_EASING)
			G.draw_affecting_under()

	affecting.reset_plane_and_layer()

/datum/grab/proc/reset_position(var/obj/item/grab/G)
	var/mob/living/carbon/human/affecting = G.affecting

	if(!affecting.buckled)
		animate(affecting, pixel_x = 0, pixel_y = 0, 4, 1, LINEAR_EASING)
	affecting.reset_plane_and_layer()

// This is called whenever the assailant moves.
/datum/grab/proc/assailant_moved(var/obj/item/grab/G)
	adjust_position(G)
	moved_effect(G)
	if(downgrade_on_move)
		G.downgrade()

/*
	Override these procs to set how the grab state will work. Some of them are best
	overriden in the parent of the grab set (for example, the behaviour for on_hit_intent(var/obj/item/grab/G)
	procs is determined in /datum/grab/normal and then inherited by each intent).
*/

// What happens when you upgrade from one grab state to the next.
/datum/grab/proc/upgrade_effect(var/obj/item/grab/G)

// Conditions to see if upgrading is possible
/datum/grab/proc/can_upgrade(var/obj/item/grab/G)
	return 1

// What happens when you downgrade from one grab state to the next.
/datum/grab/proc/downgrade_effect(var/obj/item/grab/G)

// Conditions to see if downgrading is possible
/datum/grab/proc/can_downgrade(var/obj/item/grab/G)
	return 1

// What happens when you let go of someone by either dropping the grab
// or by downgrading from the lowest grab state.
/datum/grab/proc/let_go_effect(var/obj/item/grab/G)

// What happens each tic when process is called.
/datum/grab/proc/process_effect(var/obj/item/grab/G)

// Handles special targeting like eyes and mouth being covered.
/datum/grab/proc/special_target_effect(var/obj/item/grab/G)

// Handles when they change targeted areas and something is supposed to happen.
/datum/grab/proc/special_target_change(var/obj/item/grab/G, var/diff_zone)

// Checks if the special target works on the grabbed humanoid.
/datum/grab/proc/check_special_target(var/obj/item/grab/G)

// What happens when you hit the grabbed person with the grab on help intent.
/datum/grab/proc/on_hit_help(var/obj/item/grab/G)
	return 1

// What happens when you hit the grabbed person with the grab on disarm intent.
/datum/grab/proc/on_hit_disarm(var/obj/item/grab/G)
	return 1

// What happens when you hit the grabbed person with the grab on grab intent.
/datum/grab/proc/on_hit_grab(var/obj/item/grab/G)
	return 1

// What happens when you hit the grabbed person with the grab on harm intent.
/datum/grab/proc/on_hit_harm(var/obj/item/grab/G)
	return 1

// What happens when you hit the grabbed person with the grab and you want it
// to do some special snowflake action based on some other factor such as
// intent.
/datum/grab/proc/on_hit_special(var/obj/item/grab/G)

/datum/grab/proc/item_attack(var/obj/item/grab/G, var/obj/item)

/datum/grab/proc/resolve_item_attack(var/obj/item/grab/G, var/mob/living/carbon/human/user, var/obj/item/I, var/target_zone)
	return 0

/datum/grab/proc/handle_resist(var/obj/item/grab/G)
	var/mob/living/carbon/human/affecting = G.affecting
	var/mob/living/carbon/human/assailant = G.assailant

	var/break_strength = breakability + size_difference(affecting, assailant)

	if(affecting.lying)
		break_strength--

	if(break_strength < 1)
		to_chat(G.assailant, "<span class='warning'>You try to break free but feel that unless something changes, you'll never escape!</span>")
		return

	var/break_chance = break_chance_table[Clamp(break_strength, 1, break_chance_table.len)]
	if(prob(break_chance))
		if(can_downgrade_on_resist && !prob((break_chance+100)/2))
			affecting.visible_message("<span class='warning'>[affecting] has loosened [assailant]'s grip!</span>")
			G.downgrade()
			return
		else
			affecting.visible_message("<span class='warning'>[affecting] has broken free of [assailant]'s grip!</span>")
			let_go(G)

/datum/grab/proc/size_difference(mob/A, mob/B)
	return mob_size_difference(A.mob_size, B.mob_size)

/datum/grab/proc/moved_effect(var/obj/item/grab/G)

/client/proc/Process_Grab()
	//if we are being grabbed
	if(isliving(mob))
		var/mob/living/L = mob
		if(!L.canmove && L.grabbed_by.len)
			L.resist() //shortcut for resisting grabs
