//For anything that can light stuff on fire
/obj/item/flame
	waterproof = FALSE
	var/lit = 0

/obj/item/flame/use_after(obj/O, mob/living/user, click_parameters)
	if(lit && istype(O))
		O.HandleObjectHeating(src, user, 700)
		return TRUE

/obj/item/flame/proc/extinguish(mob/user, no_message)
	lit = 0
	damtype = DAMAGE_BRUTE
	STOP_PROCESSING(SSobj, src)

/obj/item/flame/water_act(depth)
	..()
	if(!waterproof && lit)
		if(submerged(depth))
			extinguish(no_message = TRUE)


/obj/item/flame/IsFlameSource()
	return lit


///////////
//MATCHES//
///////////
/obj/item/flame/match
	name = "match"
	pluralname = "matche"
	desc = "A simple match stick, used for lighting fine smokables."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "match_unlit"
	var/burnt = 0
	var/smoketime = 5
	w_class = ITEM_SIZE_TINY
	origin_tech = list(TECH_MATERIAL = 1)
	slot_flags = SLOT_EARS
	attack_verb = list("burnt", "singed")

/obj/item/flame/match/Process()
	if(isliving(loc))
		var/mob/living/M = loc
		M.IgniteMob()
	var/turf/location = get_turf(src)
	smoketime--
	if(submerged() || smoketime < 1)
		extinguish()
		return
	if(location)
		location.hotspot_expose(700)

/obj/item/flame/match/dropped(mob/user)
	//If dropped, put ourselves out
	//not before lighting up the turf we land on, though.
	if(lit)
		var/turf/location = src.loc
		if(istype(location))
			location.hotspot_expose(700)
		extinguish()
	return ..()

/obj/item/flame/match/extinguish(mob/user, no_message)
	. = ..()
	name = "burnt match"
	desc = "A match. This one has seen better days."
	burnt = 1
	update_icon()

/obj/item/flame/match/on_update_icon()
	..()
	if(burnt)
		icon_state = "match_burnt"
		item_state = "cigoff"

/obj/item/flame/match/use_before(mob/living/fiery, mob/living/carbon/user)
	. = FALSE
	if (!istype(fiery))
		return FALSE

	if (lit)
		var/turf/location = get_turf(user)
		var/mob/living/burn = fiery
		if(isliving(fiery) && burn.fire_stacks > 0)
			user.visible_message(
				SPAN_WARNING("\The [user] sets \the [fiery] on fire with \a [src]!"),
				SPAN_WARNING("You set \the [fiery] on fire!")
			)
			fiery.IgniteMob()
			/// admin logs
			if(ismob(user))
				var/attacker_message = "Ignited using \a [src] (lit)"
				var/victim_message = "Was ignited with \a [src] (lit)"
				var/admin_message = "used \a [src] (lit) to ignite"
				admin_attack_log(user, fiery, attacker_message, victim_message, admin_message)
			else
				admin_victim_log(fiery, "was ignited by an <b> UNKNOWN SUBJECT (No longer exists)</b> using \a [src]")
		if(isturf(location))
			location.hotspot_expose(700)
	return
