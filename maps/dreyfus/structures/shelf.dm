/obj/structure/table/shelf
	name = "shelf"
	desc = "Like racks, but taller."
	icon = 'maps/dreyfus/icons/shelf.dmi'
	icon_state = "rack2"
	can_plate = 0
	can_reinforce = 0
	flipped = -1

	material = DEFAULT_TABLE_MATERIAL

/obj/structure/table/shelf/New()
	..()
	verbs -= /obj/structure/table/verb/do_flip
	verbs -= /obj/structure/table/proc/do_put

/obj/structure/table/shelf/initialize()
	auto_align()
	..()

/obj/structure/table/shelf/update_connections()
	return

/obj/structure/table/shelf/update_desc()
	return

/obj/structure/table/shelf/update_icon()
	return

/obj/structure/table/shelf/can_connect()
	return FALSE

/obj/structure/table/shelf/holorack/dismantle(obj/item/weapon/wrench/W, mob/user)
	to_chat(user, "<span class='warning'>You cannot dismantle \the [src].</span>")
	return
