//For anything that can light stuff on fire
/obj/item/weapon/flame
	waterproof = FALSE
	var/lit = 0

/obj/item/weapon/flame/afterattack(var/obj/O, var/mob/user, proximity)
	..()
	if(proximity && lit && istype(O))
		O.HandleObjectHeating(src, user, 700)

/obj/item/weapon/flame/proc/extinguish(var/mob/user, var/no_message)
	lit = 0
	damtype = "brute"
	STOP_PROCESSING(SSobj, src)

/obj/item/weapon/flame/water_act(var/depth)
	..()
	if(!waterproof && lit)
		if(submerged(depth))
			extinguish(no_message = TRUE)

/proc/isflamesource(var/atom/A)
	if(!istype(A))
		return FALSE
	if(isWelder(A))
		var/obj/item/weapon/weldingtool/WT = A
		return (WT.isOn())
	else if(istype(A, /obj/item/weapon/flame))
		var/obj/item/weapon/flame/F = A
		return (F.lit)
	else if(istype(A, /obj/item/clothing/mask/smokable) && !istype(A, /obj/item/clothing/mask/smokable/pipe))
		var/obj/item/clothing/mask/smokable/S = A
		return (S.lit)
	else if(istype(A, /obj/item/device/assembly/igniter))
		return TRUE
	return FALSE

///////////
//MATCHES//
///////////
/obj/item/weapon/flame/match
	name = "match"
	desc = "A simple match stick, used for lighting fine smokables."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "match_unlit"
	var/burnt = 0
	var/smoketime = 5
	w_class = ITEM_SIZE_TINY
	origin_tech = list(TECH_MATERIAL = 1)
	slot_flags = SLOT_EARS
	attack_verb = list("burnt", "singed")

/obj/item/weapon/flame/match/Process()
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

/obj/item/weapon/flame/match/dropped(var/mob/user)
	//If dropped, put ourselves out
	//not before lighting up the turf we land on, though.
	if(lit)
		var/turf/location = src.loc
		if(istype(location))
			location.hotspot_expose(700, 5)
		extinguish()
	return ..()

/obj/item/weapon/flame/match/extinguish(var/mob/user, var/no_message)
	. = ..()
	name = "burnt match"
	desc = "A match. This one has seen better days."
	burnt = 1
	update_icon()

/obj/item/weapon/flame/match/on_update_icon()
	..()
	if(burnt)
		icon_state = "match_burnt"
		item_state = "cigoff"