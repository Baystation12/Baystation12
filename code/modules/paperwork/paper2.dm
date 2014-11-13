/datum/writing
	var/content

/*
 * Paper
 * also scraps of paper
 */

/obj/item/weapon/paperwork/paper
	name = "paper"
	gender = PLURAL
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "paper"
	throwforce = 0
	w_class = 1.0
	throw_range = 1
	throw_speed = 1
	layer = 4
	pressure_resistance = 1
	slot_flags = SLOT_HEAD
	body_parts_covered = HEAD
	attack_verb = list("bapped")
	
	var/list/paper_content = list()

/obj/item/weapon/paperwork/paper/attackby(obj/item/weapon/P as obj, mob/user as mob)
	if(istype(P, /obj/item/weapon/paperwork))
		create_bundle(P, user)
		return
	
	if(istype(P, /obj/item/weapon/pen) || istype(P, /obj/item/toy/crayon))
		if ( istype(P, /obj/item/weapon/pen/robopen) && P:mode == 2 )
			P:RenamePaper(user,src)
		else
			user << browse("<HTML><HEAD><TITLE>[name]</TITLE></HEAD><BODY>[info_links][stamps]</BODY></HTML>", "window=[name]")
		//openhelp(user)
		return
	..()
