/*
CONTAINS:
MATCHES
MATCHBOXES
CIGARETTES
CIG PACKET
ZIPPO
*/

///////////
//MATCHES//
///////////
/obj/item/weapon/match
	name = "Match"
	desc = "A simple match stick, used for lighting tobacco"
	icon = 'cigarettes.dmi'
	icon_state = "match_unlit"
	var/lit = 0
	var/smoketime = 5
	w_class = 1.0
	origin_tech = "materials=1"


	process()
		while(src.lit == 1)
			src.smoketime--
			sleep(10)
			if(src.smoketime < 1)
				src.icon_state = "match_burnt"
				src.lit = -1
				processing_objects.Remove(src)
				return


	dropped(mob/user as mob)
		if(src.lit == 1)
			src.lit = -1
			src.damtype = "brute"
			src.icon_state = "match_burnt"
			src.item_state = "cigoff"
			src.name = "Burnt match"
			src.desc = "A match that has been burnt"
		return ..()



//////////////
//MATCHBOXES//
//////////////
/obj/item/weapon/matchbox
	name = "Matchbox"
	desc = "A small box of Almost But Not Quite Plasma Premium Matches."
	icon = 'cigarettes.dmi'
	icon_state = "matchbox"
	item_state = "zippo"
	w_class = 1
	flags = ONBELT | TABLEPASS
	var/matchcount = 10
	w_class = 1.0


	attack_hand(mob/user as mob)
		if(user.r_hand == src || user.l_hand == src)
			if(src.matchcount <= 0)
				user << "\red You're out of matches. Shouldn't have wasted so many..."
				return
			else
				src.matchcount--
				var/obj/item/weapon/match/W = new /obj/item/weapon/match(user)
				if(user.hand)
					user.l_hand = W
				else
					user.r_hand = W
				W.layer = 20
		else
			return ..()
		if(src.matchcount <= 0)
			src.icon_state = "matchbox_empty"
		else if(src.matchcount <= 3)
			src.icon_state = "matchbox_almostempty"
		else if(src.matchcount <= 6)
			src.icon_state = "matchbox_almostfull"
		else
			src.icon_state = "matchbox"
		src.update_icon()
		return


	attackby(obj/item/weapon/match/W as obj, mob/user as mob)
		if(istype(W, /obj/item/weapon/match) && W.lit == 0)
			W.lit = 1
			W.icon_state = "match_lit"
			processing_objects.Add(W)
		W.update_icon()
		return



///////////////////////
//CIGARETTES + CIGARS//
///////////////////////

/obj/item/clothing/mask/cigarette
	name = "Cigarette"
	desc = "A roll of tobacco and nicotine."
	icon_state = "cigoff"
	throw_speed = 0.5
	item_state = "cigoff"
	w_class = 1
	body_parts_covered = null
	var
		lit = 0
		icon_on = "cigon"  //Note - these are in masks.dmi not in cigarette.dmi
		icon_off = "cigoff"
		icon_butt = "cigbutt"
		lastHolder = null
		smoketime = 300
	proc
		light(var/flavor_text = "[usr] lights the [name].")


	attackby(obj/item/weapon/W as obj, mob/user as mob)
		..()
		if(istype(W, /obj/item/weapon/weldingtool)  && W:welding)
			light("\red [user] casually lights the [name] with [W], what a badass.")

		else if(istype(W, /obj/item/weapon/zippo) && (W:lit > 0))
			light("\red With a single flick of their wrist, [user] smoothly lights their [name] with their [W]. Damn they're cool.")

		else if(istype(W, /obj/item/weapon/match) && (W:lit > 0))
			light("\red [user] lights their [name] with their [W]. How poor can you get?")
		return


	light(var/flavor_text = "[usr] lights the [name].")
		if(!src.lit)
			src.lit = 1
			src.damtype = "fire"
			src.icon_state = icon_on
			src.item_state = icon_on
			for(var/mob/O in viewers(usr, null))
				O.show_message(flavor_text, 1)
			processing_objects.Add(src)


	process()
		var/turf/location = get_turf(src)
		src.smoketime--
		if(src.smoketime < 1)
			if (istype(src,/obj/item/clothing/mask/cigarette/cigar))
				var/obj/item/weapon/cigbutt/C = new /obj/item/weapon/cigarbutt
				C.loc = location
			else
				var/obj/item/weapon/cigbutt/C = new /obj/item/weapon/cigbutt
				C.loc = location
			if(ismob(src.loc))
				var/mob/living/M = src.loc
				M << "\red Your [src.name] goes out."
			processing_objects.Remove(src)
			del(src)
			return
		if(location)
			location.hotspot_expose(700, 5)
		return


	dropped(mob/user as mob)
		if(src.lit == 1)
			for(var/mob/O in viewers(user, null))
				O.show_message(text("\red [] calmly drops and treads on the lit [], putting it out instantly.", user,src.name), 1)
			src.lit = -1
			src.damtype = "brute"
			src.icon_state = icon_butt
			src.item_state = icon_off
			src.desc = "A [src.name] butt."
			src.name = "[src.name] butt"
		return ..()



////////////
// CIGARS //
////////////
/obj/item/clothing/mask/cigarette/cigar
	name = "Premium Cigar"
	desc = "A brown roll of tobacco and... well, you're not quite sure. This thing's huge!"
	icon_state = "cigaroff"
	icon_on = "cigaron"
	icon_off = "cigaroff"
	icon_butt = "cigarbutt"
	throw_speed = 0.5
	item_state = "cigaroff"
	smoketime = 1500

/obj/item/clothing/mask/cigarette/cigar/cohiba
	name = "Cohiba Cigar"
	desc = "There's little more you could want from a cigar."
	icon_state = "cigar2off"
	icon_on = "cigar2on"
	icon_off = "cigar2off"
	icon_butt = "cigarbutt"

/obj/item/clothing/mask/cigarette/cigar/havanian
	name = "Premium Havanian Cigar"
	desc = "A cigar fit for only the best for the best."
	icon_state = "cigar2off"
	icon_on = "cigar2on"
	icon_off = "cigar2off"
	icon_butt = "cigarbutt"
	smoketime = 7200

/obj/item/weapon/cigbutt
	name = "Cigarette butt"
	desc = "A manky old cigarette butt."
	icon = 'cigarettes.dmi'
	icon_state = "cigbutt"
	w_class = 1
	throwforce = 1

/obj/item/weapon/cigarbutt
	name = "Cigar butt"
	desc = "A manky old cigar butt."
	icon = 'cigarettes.dmi'
	icon_state = "cigarbutt"
	w_class = 1
	throwforce = 1


/obj/item/clothing/mask/cigarette/cigar/havanian/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/match) && (W:lit > 0))
		user << "\red The [src] straight out REFUSES to be lit by such uncivilized means."
	else
		..()


////////////
//CIG PACK//
////////////
/obj/item/weapon/cigpacket
	name = "Cigarette packet"
	desc = "The most popular brand of Space Cigarettes, sponsors of the Space Olympics."
	icon = 'cigarettes.dmi'
	icon_state = "cigpacket"
	item_state = "cigpacket"
	w_class = 1
	throwforce = 2
	flags = ONBELT | TABLEPASS
	var
		cigcount = 6


	update_icon()
		src.icon_state = text("cigpacket[]", src.cigcount)
		src.desc = text("There are [] cigs\s left!", src.cigcount)
		return


	attack_hand(mob/user as mob)
		if(user.r_hand == src || user.l_hand == src)
			if(src.cigcount == 0)
				user << "\red You're out of cigs, shit! How you gonna get through the rest of the day..."
				return
			else
				src.cigcount--
				var/obj/item/clothing/mask/cigarette/W = new /obj/item/clothing/mask/cigarette(user)
				if(user.hand)
					user.l_hand = W
				else
					user.r_hand = W
				W.layer = 20
		else
			return ..()
		src.update_icon()
		return



/////////
//ZIPPO//
/////////
/obj/item/weapon/zippo
	name = "Zippo lighter"
	desc = "The detective's zippo."
	icon = 'items.dmi'
	icon_state = "zippo"
	item_state = "zippo"
	w_class = 1
	throwforce = 4
	flags = ONBELT | TABLEPASS | CONDUCT
	var
		lit = 0


	attack_self(mob/user)
		if(user.r_hand == src || user.l_hand == src)
			if(!src.lit)
				src.lit = 1
				src.icon_state = "zippoon"
				src.item_state = "zippoon"
				for(var/mob/O in viewers(user, null))
					O.show_message(text("\red Without even breaking stride, [] flips open and lights the [] in one smooth movement.", user, src), 1)

				user.total_luminosity += 2
				processing_objects.Add(src)
			else
				src.lit = 0
				src.icon_state = "zippo"
				src.item_state = "zippo"
				for(var/mob/O in viewers(user, null))
					O.show_message(text("\red You hear a quiet click, as [] shuts off the [] without even looking what they're doing. Wow.", user, src), 1)

				user.total_luminosity -= 2
				processing_objects.Remove(src)
		else
			return ..()
		return


	attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
		if(!istype(M, /mob))
			return

		if(istype(M.wear_mask,/obj/item/clothing/mask/cigarette) && user.zone_sel.selecting == "mouth" && src.lit)
			if(M == user)
				M.wear_mask:light("\red With a single flick of their wrist, [user] smoothly lights their [M.wear_mask.name] with their [src.name]. Damn they're cool.")
			else
				M.wear_mask:light("\red [user] whips the [src.name] out and holds it for [M]. Their arm is as steady as the unflickering flame they light the [M.wear_mask.name] with.")
		else
			..()


	process()
		var/turf/location = get_turf(src)
		if(location)
			location.hotspot_expose(700, 5)
		return


	pickup(mob/user)
		if(lit)
			src.sd_SetLuminosity(0)
			user.total_luminosity += 2
		return


	dropped(mob/user)
		if(lit)
			user.total_luminosity -= 2
			src.sd_SetLuminosity(2)
		return