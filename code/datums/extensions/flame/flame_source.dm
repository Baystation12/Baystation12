/datum/extension/flame_source
	base_type = /datum/extension/flame_source
	var/atom/atom_holder

/datum/extension/flame_source/New(holder)
	..()
	atom_holder = holder

/datum/extension/flame_source/proc/use_flame(atom/atom, mob/living/user, list/click_params)
	/// Allows flame sources (like lit cigs) to light mobs on fire
	if (!atom_holder?.IsFlameSource() || !isliving(atom))
		return FALSE

	var/turf/location = get_turf(user)
	var/mob/living/burn_victim = atom

	if (isturf(location))
		location.hotspot_expose(700)

	if (burn_victim.fire_stacks > 0)
		user.visible_message(
			SPAN_WARNING("\The [user] sets \the [burn_victim] on fire with \a [atom_holder]!"),
			SPAN_WARNING("You set \the [burn_victim] on fire!")
		)
		burn_victim.IgniteMob()
		if (ismob(user))
			var/attacker_message = "Ignited using \a [atom_holder] (lit)"
			var/victim_message = "Was ignited with \a [atom_holder] (lit)"
			var/admin_message = "used \a [atom_holder] (lit) to ignite"
			admin_attack_log(user, burn_victim, attacker_message, victim_message, admin_message)
		else
			admin_victim_log(burn_victim, "was ignited by an <b> UNKNOWN SUBJECT (No longer exists)</b> using \a [atom_holder]")

	if (user.a_intent == I_HELP)
		if (istype(burn_victim.wear_mask, /obj/item/clothing/mask/smokable/cigarette) && user.zone_sel.selecting == BP_MOUTH)
			var/obj/item/clothing/mask/smokable/cigarette/cig = burn_victim.wear_mask
			return cig.use_tool(atom_holder, user)
	/// When we want to extinguish our cigarette on someone, who is not flammable
	else if (istype(atom_holder, /obj/item/clothing/mask/smokable/cigarette))
		var/obj/item/clothing/mask/smokable/cigarette/cig = atom_holder
		var/target_zone = user.zone_sel.selecting
		burn_victim.apply_damage(2, DAMAGE_BURN, target_zone)
		burn_victim.apply_damage(5, DAMAGE_PAIN, target_zone)
		if (target_zone == BP_EYES)
			cig.eyestab(burn_victim, user)
		else
			user.visible_message(
				SPAN_WARNING("\The [user] extinguishes \a [cig] on \the [burn_victim]."),
				SPAN_WARNING("You extinguish \the [cig] on \the [burn_victim].")
			)
			if (ismob(user))
				var/attacker_message = "Extinguished \a (lit) [cig]"
				var/victim_message = "Had \a [cig] extinguished on them"
				var/admin_message = "extinguished \a [cig] on"
				admin_attack_log(user, burn_victim, attacker_message, victim_message, admin_message)
			playsound(burn_victim, cig.hitsound, 50, TRUE, -1)
		cig.extinguish()
		return TRUE
	return FALSE
