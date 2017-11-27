// Make a vampire, add initial powers.
/mob/proc/make_vampire()
	if (!mind)
		return

	if (!mind.vampire)
		mind.vampire = new /datum/vampire()

	// No powers to thralls. Ew.
	if (mind.vampire.status & VAMP_ISTHRALL)
		return

	mind.vampire.blood_usable += 30

	verbs += new/datum/game_mode/vampire/verb/vampire_help

	for (var/datum/power/vampire/P in vampirepowers)
		if (!P.blood_cost)
			if (!(P in mind.vampire.purchased_powers))
				mind.vampire.add_power(mind, P, 0)

	return 1

// Checks the vampire's bloodlevel and unlocks new powers based on that.
/mob/proc/check_vampire_upgrade()
	if (!mind.vampire)
		return

	var/datum/vampire/vampire = mind.vampire

	for (var/datum/power/vampire/P in vampirepowers)
		if (P.blood_cost <= vampire.blood_total)
			if (!(P in vampire.purchased_powers))
				vampire.add_power(mind, P, 1)

	if (!(vampire.status & VAMP_FULLPOWER) && vampire.blood_total >= 650)
		vampire.status |= VAMP_FULLPOWER
		to_chat(src, "<span class='notice'>You've gained full power. Some abilities now have bonus functionality, or work faster.</span>")

// Runs the checks for whether or not we can use a power.
/mob/proc/vampire_power(var/required_blood = 0, var/max_stat = 0, var/ignore_holder = 0, var/disrupt_healing = 1, var/required_vampire_blood = 0)
	if (!mind)
		return

	if (!ishuman(src))
		return

	var/datum/vampire/vampire = mind.vampire
	if (!vampire)
		log_debug("[src] has a vampire power but is not a vampire.")
		return

	if (vampire.holder && !ignore_holder)
		to_chat(src, "<span class='warning'>You cannot use this power while walking through the Veil.</span>")
		return

	if (stat > max_stat)
		to_chat(src, "<span class='warning'>You are incapacitated.</span>")
		return

	if (required_blood > vampire.blood_usable)
		to_chat(src, "<span class='warning'>You do not have enough usable blood. [required_blood] needed.</span>")
		return

	if ((vampire.status & VAMP_HEALING) && disrupt_healing)
		vampire.status &= ~VAMP_HEALING

	return vampire

// Checks whether or not the target can be affected by a vampire's abilities.
/mob/proc/vampire_can_affect_target(var/mob/living/carbon/human/T, var/notify = 1, var/account_loyalty_implant = 0)
	if (!T || !istype(T))
		return 0

	// How did you even get here?
	if (!mind.vampire)
		return 0

	if ((mind.vampire.status & VAMP_FULLPOWER) && !(T.mind.vampire && (T.mind.vampire.status & VAMP_FULLPOWER)))
		return 1

	if (T.mind)
		if (T.mind.assigned_role == "Chaplain")
			if (notify)
				to_chat(src, "<span class='warning'>Your connection with the Veil is not strong enough to affect a man as devout as them.</span>")
			return 0
		else if (T.mind.vampire)
			if (notify)
				to_chat(src, "<span class='warning'>You lack the power required to affect another creature of the Veil.</span>")
			return 0

	if (isipc(T))
		if (notify)
			to_chat(src, "<span class='warning'>You lack the power interact with mechanical constructs.</span>")
		return 0

	if (account_loyalty_implant)
		for (var/obj/item/weapon/implant/loyalty/I in T)
			if (I.implanted)
				if (notify)
					to_chat(src, "<span class='warning'>You feel that [T]'s mind is unreachable due to forced loyalty.</span>")
				return 0

	return 1

// Plays the vampire phase in animation.
/mob/proc/vampire_phase_in(var/turf/T = null)
	if (!T)
		return

	anim(T, src, 'icons/mob/mob.dmi', , "bloodify_in", , dir)

// Plays the vampire phase out animation.
/mob/proc/vampire_phase_out(var/turf/T = null)
	if (!T)
		return

	anim(T, src, 'icons/mob/mob.dmi', , "bloodify_out", , dir)

// Make a vampire thrall
/mob/proc/vampire_make_thrall()

	if (!mind)
		return

	var/datum/vampire/thrall/thrall = new()

	mind.vampire = thrall

/mob/proc/vampire_check_frenzy(var/force_frenzy = 0)
	if (!mind || !mind.vampire)
		return

	var/datum/vampire/vampire = mind.vampire

	// Thralls don't frenzy.
	if (vampire.status & VAMP_ISTHRALL)
		return

/*
 * Misc info:
 * 100 points ~= 3.5 minutes.
 * Average duration should be around 4 minutes of frenzy.
 * Trigger at 120 points or higher.
 */

	if (vampire.status & VAMP_FRENZIED)
		if (vampire.frenzy < 10)
			vampire_stop_frenzy()
	else
		var/next_alert = 0
		var/message = ""

		switch (vampire.frenzy)
			if (0)
				return
			if (1 to 20)
				// Pass function would be amazing here.
				next_alert = 0
				message = ""
			if (21 to 40)
				next_alert = 600
				message = "<span class='warning'>You feel the power of the Veil bubbling in your veins.</span>"
			if (41 to 60)
				next_alert = 500
				message = "<span class='warning'>The corruption within your blood is seeking to take over, you can feel it.</span>"
			if (61 to 80)
				next_alert = 400
				message = "<span class='danger'>Your rage is growing ever greater. You are having to actively resist it.</span>"
			if (81 to 120)
				next_alert = 300
				message = "<span class='danger'>The corruption of the Veil is about to take over. You have little time left.</span>"
			else
				vampire_start_frenzy(force_frenzy)

		if (next_alert && message)
			if (!vampire.last_frenzy_message || vampire.last_frenzy_message + next_alert < world.time)
				to_chat(usr, message)
				vampire.last_frenzy_message = world.time

	// Remove one point per every life() tick.
	if (vampire.frenzy > 0)
		vampire.frenzy--

/mob/proc/vampire_start_frenzy(var/force_frenzy = 0)
	var/datum/vampire/vampire = mind.vampire

	if (vampire.status & VAMP_FRENZIED)
		return

	var/probablity = force_frenzy ? 100 : vampire.frenzy * 0.5

	if (prob(probablity))
		vampire.status |= VAMP_FRENZIED
		visible_message("<span class='danger'>A dark aura manifests itself around [src.name], their eyes turning red and their composure changing to be more beast-like.</span>", "<span class='danger'>You can resist no longer. The power of the Veil takes control over your mind: you are unable to speak or think. In people, you see nothing but prey to be feasted upon. You are reduced to an animal.</span>")

		mutations.Add(HULK)
		update_mutations()

		sight |= SEE_MOBS

		verbs += /mob/living/carbon/human/proc/grapple

/mob/proc/vampire_stop_frenzy(var/force_stop = 0)
	var/datum/vampire/vampire = mind.vampire

	if (!(vampire.status & VAMP_FRENZIED))
		return

	if (prob(force_stop ? 100 : vampire.blood_usable))
		vampire.status &= ~VAMP_FRENZIED

		mutations.Remove(HULK)
		update_mutations()

		sight &= ~SEE_MOBS

		visible_message("<span class='danger'>[src.name]'s eyes no longer glow with violent rage, their form reverting to resemble that of a normal human's.</span>", "<span class='danger'>The beast within you retreats. You gain control over your body once more.</span>")

		verbs -= /mob/living/carbon/human/proc/grapple

// Removes all vampire powers.
/mob/proc/remove_vampire_powers()
	if (!mind || !mind.vampire)
		return

	for (var/datum/power/vampire/P in mind.vampire.purchased_powers)
		if (P.isVerb)
			verbs -= P.verbpath

	if (mind.vampire.status & VAMP_FRENZIED)
		vampire_stop_frenzy(1)

/mob/proc/handle_vampire()
	// Apply frenzy while in the chapel.
	if (istype(get_area(loc), /area/chapel))
		mind.vampire.frenzy += 3

	if (mind.vampire.blood_usable < 10)
		mind.vampire.frenzy += 2

	vampire_check_frenzy()

	return

/mob/living/carbon/human/proc/finish_vamp_timeout(vamp_flags = 0)
	if (!mind || !mind.vampire)
		return FALSE

	if (vamp_flags && !(mind.vampire.status & vamp_flags))
		return FALSE

	return TRUE
