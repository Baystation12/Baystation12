// SIERRA TODO: usesound с Paradise (или подобные)

//
//        DRILL
//

/obj/item/wrench/power
	name = "hand drill"
	desc = "A simple powered hand drill. It's fitted with a bolt bit."
	icon = 'packs/infinity/icons/obj/items.dmi'
	icon_state = "drill_bolt"
	item_state = "drill"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	force = 8.0
	throwforce = 8.0
	throw_speed = 2
	throw_range = 3
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 3)
	matter = list(DEFAULT_WALL_MATERIAL = 5000, "silver" = 2000)
	center_of_mass = "x=17;y=16"
	attack_verb = list("drilled", "screwed", "jabbed")

/obj/item/wrench/power/attack_self(mob/user)
	playsound(get_turf(user), 'packs/infinity/sound/items/change_drill.ogg', 50, 1)

	var/obj/item/screwdriver/power/s_drill = new /obj/item/screwdriver/power

	to_chat(user, "<span class='notice'>You attach the screw driver bit to [src].</span>")
	qdel(src)

	user.put_in_active_hand(s_drill)

/obj/item/wrench/power/Initialize()
	. = ..()
	icon_state = "drill_bolt"
	color = "#ffffff"


/obj/item/screwdriver/power
	name = "hand drill"
	desc = "A simple powered hand drill. It's fitted with a screw bit."
	icon = 'packs/infinity/icons/obj/items.dmi'
	icon_state = "drill_screw"
	item_state = "drill"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	force = 8
	throwforce = 8
	throw_speed = 2
	throw_range = 3
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 3)
	matter = list(DEFAULT_WALL_MATERIAL = 5000, "silver" = 2000)
	center_of_mass = "x=16;y=7"
	attack_verb = list("drilled", "screwed", "jabbed","whacked")
	hitsound = 'packs/infinity/sound/items/drill_hit.ogg'

/obj/item/screwdriver/power/attack_self(mob/user)
	playsound(get_turf(user), 'packs/infinity/sound/items/change_drill.ogg', 50, 1)
	var/obj/item/wrench/power/b_drill = new /obj/item/wrench/power
	to_chat(user, "<span class='notice'>You attach the bolt driver bit to [src].</span>")
	qdel(src)
	user.put_in_active_hand(b_drill)

/obj/item/screwdriver/power/Initialize()
	. = ..()
	icon_state = "drill_screw"
	color = "#ffffff"


//
//        JAWS OF LIFE
//

/obj/item/wirecutters/power
	name = "jaws of life"
	desc = "A set of jaws of life, compressed through the magic of science. It's fitted with a cutting head."
	icon = 'packs/infinity/icons/obj/items.dmi'
	icon_state = "jaws_cutter"
	item_state = "jawsoflife"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	force = 15.0
	throwforce = 10.0
	throw_speed = 2.0
	throw_range = 2.0
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 3)
	matter = list(DEFAULT_WALL_MATERIAL = 5000, "silver" = 2000)
	center_of_mass = "x=18;y=10"
	attack_verb = list("pinched", "nipped")
	sharp = 1
	edge = 1

/obj/item/wirecutters/power/attack_self(mob/user)
	playsound(get_turf(user), 'packs/infinity/sound/items/change_jaws.ogg', 50, 1)
	var/obj/item/crowbar/power/pryjaws = new /obj/item/crowbar/power
	to_chat(user, "<span class='notice'>You attach the pry jaws to [src].</span>")
	qdel(src)
	user.put_in_active_hand(pryjaws)

/obj/item/wirecutters/power/Initialize()
	. = ..()
	icon_state = "jaws_cutter"
	color = "#ffffff"


/obj/item/crowbar/power
	name = "jaws of life"
	desc = "A set of jaws of life, compressed through the magic of science. It's fitted with a prying head."
	icon = 'packs/infinity/icons/obj/items.dmi'
	icon_state = "jaws_pry"
	item_state = "jawsoflife"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	force = 15.0
	throwforce = 10.0
	throw_speed = 2.0
	throw_range = 2.0
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 3)
	matter = list(DEFAULT_WALL_MATERIAL = 5000, "silver" = 2000)
	center_of_mass = "x=18;y=10"
	attack_verb = list("attacked", "bashed", "battered", "bludgeoned", "whacked")

/obj/item/crowbar/power/attack_self(mob/user)
	playsound(get_turf(user), 'packs/infinity/sound/items/change_jaws.ogg', 50, 1)
	var/obj/item/wirecutters/power/cutjaws = new /obj/item/wirecutters/power
	to_chat(user, "<span class='notice'>You attach the cutting jaws to [src].</span>")
	qdel(src)
	user.put_in_active_hand(cutjaws)

/obj/item/crowbar/power/Initialize()
	. = ..()
	icon_state = "jaws_pry"
	color = "#ffffff"
