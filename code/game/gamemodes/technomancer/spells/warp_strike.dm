/datum/technomancer/spell/warp_strike
	name = "Warp Strike"
	desc = "Teleports you next to your target, and attacks them with whatever is in your off-hand, spell or object."
	cost = 100
	obj_path = /obj/item/weapon/spell/warp_strike
	ability_icon_state = "tech_warpstrike"
	category = OFFENSIVE_SPELLS

/obj/item/weapon/spell/warp_strike
	name = "warp strike"
	desc = "The answer to the problem of bringing a knife to a gun fight."
	icon_state = "warp_strike"
	cast_methods = CAST_RANGED
	aspect = ASPECT_TELE
	var/datum/effect/effect/system/spark_spread/sparks

/obj/item/weapon/spell/warp_strike/New()
	..()
	sparks = new()
	sparks.set_up(5, 0, src)
	sparks.attach(loc)

/obj/item/weapon/spell/warp_strike/on_ranged_cast(atom/hit_atom, mob/user)
	var/turf/T = get_turf(hit_atom)
	if(T)
		//First, we handle who to teleport to.
		user.setClickCooldown(5)
		var/mob/living/chosen_target = targeting_assist(T,5)		//The person who's about to get attacked.

		if(!chosen_target)
			return 0

		//Now we handle picking a place for the user to teleport to.
		var/list/tele_target_candidates = view(get_turf(chosen_target), 1)
		var/list/valid_tele_targets = list()
		var/turf/tele_target = null
		for(var/turf/checked_turf in tele_target_candidates)
			if(!checked_turf.check_density())
				valid_tele_targets.Add(checked_turf)

		tele_target = pick(valid_tele_targets)

		//Pay for our teleport.
		if(!pay_energy(2000) || !tele_target)
			return 0

		//Teleporting time.
		user.forceMove(tele_target)
		var/new_dir = get_dir(user, chosen_target)
		user.dir = new_dir
		sparks.start()
		adjust_instability(12)

		//Finally, we handle striking the victim with whatever's in the user's offhand.
		var/obj/item/I = user.get_inactive_hand()
		// List of items we don't want used, for balance reasons or to avoid infinite loops.
		var/list/blacklisted_items = list(
			/obj/item/weapon/gun,
			/obj/item/weapon/spell/warp_strike,
			/obj/item/weapon/spell/targeting_matrix
			)
		if(I)

			if(is_path_in_list(I.type, blacklisted_items))
				to_chat(user,"<span class='danger'>You can't use \the [I] while warping!</span>")
				return

			if(istype(I, /obj/item/weapon))
				var/obj/item/weapon/W = I
				W.attack(chosen_target, user)
				W.afterattack(chosen_target, user)
			else
				I.attack(chosen_target, user)
				I.afterattack(chosen_target, user)
		else
			chosen_target.attack_hand(user)

