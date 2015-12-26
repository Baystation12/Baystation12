/obj/item/weapon/storage/box/matches
	name = "matchbox"
	desc = "A small box of matches."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "matchbox"
	item_state = "zippo"
	w_class = 1
	slot_flags = SLOT_BELT
	var/match_type = /obj/item/weapon/flame/match
	var/match_count = 10

/obj/item/weapon/storage/box/matches/New()
	..()
	for(var/i=1; i <= match_count; i++)
		new match_type(src)

/obj/item/weapon/storage/box/matches/attackby(var/obj/item/W, var/mob/user)
	if(istype(W, /obj/item/weapon/flame/match))
		var/obj/item/weapon/flame/match/M = W
		M.light()
		return
	return ..()

///////////
//MATCHES//
///////////
/obj/item/weapon/flame/match
	name = "match"
	desc = "A simple match stick, used for lighting fires."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "match_unlit"
	var/burnt = 0
	var/smoketime = 5
	w_class = 1.0
	slot_flags = SLOT_EARS
	attack_verb = list("burnt", "singed")

/obj/item/weapon/flame/match/light()
	if(burnt || !..())
		return
	lit = 1

/obj/item/weapon/flame/match/process()
	if(..())
		smoketime--
		if(smoketime < 1)
			die()
			return

/obj/item/weapon/flame/match/update_icon()
	item_state = "cigoff"
	if(burnt)
		icon_state = "match_burnt"
	else if(lit)
		icon_state = "match_lit"
		item_state = "cigon"
	else
		icon_state = "match_unlit"

/obj/item/weapon/flame/match/die()
	..()
	burnt = 1
	damtype = "brute"
	name = "burnt match"
	desc = "A match. This one has seen better days."

/obj/item/weapon/flame/match/dropped(mob/user as mob)
	if(lit)
		spawn(0)
			var/turf/location = src.loc
			if(istype(location))
				location.hotspot_expose(700, 5)
			die()
	return ..()