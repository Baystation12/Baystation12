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
		location.hotspot_expose(700, 5)

/obj/item/flame/match/dropped(mob/user)
	//If dropped, put ourselves out
	//not before lighting up the turf we land on, though.
	if(lit)
		var/turf/location = src.loc
		if(istype(location))
			location.hotspot_expose(700, 5)
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
