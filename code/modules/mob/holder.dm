//Helper object for picking dionaea (and other creatures) up.
/obj/item/weapon/holder
	name = "holder"
	desc = "You shouldn't ever see this."
	icon = 'icons/obj/objects.dmi'
	slot_flags = SLOT_HEAD
	sprite_sheets = list("Vox" = 'icons/mob/species/vox/head.dmi')
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_holder.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_holder.dmi',
		)

/obj/item/weapon/holder/New()
	..()
	processing_objects.Add(src)

/obj/item/weapon/holder/Destroy()
	processing_objects.Remove(src)
	..()

/obj/item/weapon/holder/process()

	if(istype(loc,/turf) || !(contents.len))

		for(var/mob/M in contents)

			var/atom/movable/mob_container
			mob_container = M
			mob_container.forceMove(get_turf(src))
			M.reset_view()

		qdel(src)

/obj/item/weapon/holder/attackby(obj/item/weapon/W as obj, mob/user as mob)
	for(var/mob/M in src.contents)
		M.attackby(W,user)

//Mob procs and vars for scooping up
/mob/living/var/holder_type

/mob/living/proc/get_scooped(var/mob/living/carbon/grabber)
	if(!holder_type || buckled || pinned.len)
		return

	var/obj/item/weapon/holder/H = new holder_type(loc)
	src.loc = H
	H.name = loc.name
	H.attack_hand(grabber)

	grabber << "You scoop up [src]."
	src << "[grabber] scoops you up."
	grabber.status_flags |= PASSEMOTES
	return H

//Mob specific holders.
/obj/item/weapon/holder/diona
	name = "diona nymph"
	desc = "It's a tiny plant critter."
	icon_state = "nymph"
	origin_tech = list(TECH_MAGNET = 3, TECH_BIO = 5)
	slot_flags = SLOT_HEAD | SLOT_OCLOTHING

/obj/item/weapon/holder/drone
	name = "maintenance drone"
	desc = "It's a small maintenance robot."
	icon_state = "drone"
	origin_tech = list(TECH_MAGNET = 3, TECH_ENGINERING = 5)

/obj/item/weapon/holder/cat
	name = "cat"
	desc = "It's a cat. Meow."
	icon_state = "cat"
	origin_tech = null

/obj/item/weapon/holder/mouse
	name = "mouse"
	desc = "It's a small rodent."
	icon_state = "mouse_gray"
	origin_tech = null
	w_class = 1

/obj/item/weapon/holder/mouse/gray
	icon_state = "mouse_gray"

/obj/item/weapon/holder/mouse/white
	icon_state = "mouse_white"

/obj/item/weapon/holder/mouse/brown
	icon_state = "mouse_brown"

/obj/item/weapon/holder/borer
	name = "cortical borer"
	desc = "It's a slimy brain slug. Gross."
	icon_state = "borer"
	origin_tech = list(TECH_BIO = 6)

/obj/item/weapon/holder/monkey
	name = "monkey"
	desc = "It's a monkey. Ook."
	icon_state = "monkey"

/obj/item/weapon/holder/monkey/farwa
	name = "farwa"
	desc = "It's a farwa."
	icon_state = "farwa"

/obj/item/weapon/holder/monkey/stok
	name = "stok"
	desc = "It's a stok. stok."
	icon_state = "stok"

/obj/item/weapon/holder/monkey/neaera
	name = "neaera"
	desc = "It's a neaera."
	icon_state = "neaera"

/obj/item/weapon/holder/pai
	name = "pAI"
	desc = "It's a little robot."
	icon_state = "pai"
