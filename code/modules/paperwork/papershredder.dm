/obj/machinery/papershredder
	name = "paper shredder"
	desc = "For those documents you don't want seen."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "papershredder0"
	density = TRUE
	anchored = TRUE
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_CLIMBABLE
	obj_flags = OBJ_FLAG_ANCHORABLE
	var/max_paper = 10
	var/paperamount = 0

	var/list/shred_amounts = list(
		/obj/item/photo = 1,
		/obj/item/shreddedp = 1,
		/obj/item/paper = 1,
		/obj/item/newspaper = 3,
		/obj/item/card/id = 3,
		/obj/item/paper_bundle = 3,
		/obj/item/sample/print = 1
		)

/obj/machinery/papershredder/attackby(var/obj/item/W, var/mob/user)

	if(istype(W, /obj/item/storage))
		empty_bin(user, W)
		return
	else
		var/paper_result
		for(var/shred_type in shred_amounts)
			if(istype(W, shred_type))
				paper_result = shred_amounts[shred_type]
		if(paper_result)
			if(paperamount == max_paper)
				to_chat(user, "<span class='warning'>\The [src] is full; please empty it before you continue.</span>")
				return
			paperamount += paper_result
			qdel(W)
			playsound(src.loc, 'sound/items/pshred.ogg', 75, 1)
			if(paperamount > max_paper)
				to_chat(user, "<span class='danger'>\The [src] was too full, and shredded paper goes everywhere!</span>")
				for(var/i=(paperamount-max_paper);i>0;i--)
					var/obj/item/shreddedp/SP = get_shredded_paper()
					SP.dropInto(loc)
					SP.throw_at(get_edge_target_turf(src,pick(GLOB.alldirs)),1,5)
				paperamount = max_paper
			update_icon()
			return
	..()
	return

/obj/machinery/papershredder/verb/empty_contents()
	set name = "Empty bin"
	set category = "Object"
	set src in range(1)

	if(usr.stat || usr.restrained() || usr.weakened || usr.paralysis || usr.lying || usr.stunned)
		return

	if(!paperamount)
		to_chat(usr, "<span class='notice'>\The [src] is empty.</span>")
		return

	empty_bin(usr)

/obj/machinery/papershredder/proc/empty_bin(var/mob/living/user, var/obj/item/storage/empty_into)

	if(empty_into) // If the user tries to empty the bin into something

		if(paperamount == 0) // Can't empty what is already empty
			to_chat(user, "<span class='notice'>\The [src] is empty.</span>")
			return

		if(empty_into && !istype(empty_into)) // Make sure we can store paper in the thing
			to_chat(user, "<span class='notice'>You cannot put shredded paper into the [empty_into].</span>")
			return

		// Move papers one by one as they fit; stop when we are empty or can't fit any more
		while(paperamount > 0)

			var/obj/item/shred_temp = get_shredded_paper()

			if(empty_into.can_be_inserted(shred_temp, user, 0))
				empty_into.handle_item_insertion(shred_temp)
			else
				qdel(shred_temp)
				paperamount++
				break

		// Report on how we did
		if(paperamount == 0)
			to_chat(user, "<span class='notice'>You empty \the [src] into \the [empty_into].</span>")
		if(paperamount > 0)
			to_chat(user, "<span class='notice'>\The [empty_into] will not fit any more shredded paper.</span>")

	else // Just dump the paper out on the floor
		while(paperamount > 0)
			get_shredded_paper()

	update_icon()

/obj/machinery/papershredder/proc/get_shredded_paper()
	if(paperamount)
		paperamount--
		return new /obj/item/shreddedp(get_turf(src))

/obj/machinery/papershredder/on_update_icon()
	icon_state = "papershredder[max(0,min(5,Floor(paperamount/2)))]"

/obj/item/shreddedp/attackby(var/obj/item/W as obj, var/mob/user)
	if(istype(W, /obj/item/flame/lighter))
		burnpaper(W, user)
	else
		..()

/obj/item/shreddedp/proc/burnpaper(var/obj/item/flame/lighter/P, var/mob/user)
	if(user.restrained())
		return
	if(!P.lit)
		to_chat(user, "<span class='warning'>\The [P] is not lit.</span>")
		return
	user.visible_message("<span class='warning'>\The [user] holds \the [P] up to \the [src]. It looks like \he's trying to burn it!</span>", \
		"<span class='warning'>You hold \the [P] up to \the [src], burning it slowly.</span>")
	if(!do_after(user,20, src))
		return
	user.visible_message("<span class='danger'>\The [user] burns right through \the [src], turning it to ash. It flutters through the air before settling on the floor in a heap.</span>", \
		"<span class='danger'>You burn right through \the [src], turning it to ash. It flutters through the air before settling on the floor in a heap.</span>")
	FireBurn()

/obj/item/shreddedp/proc/FireBurn()
	new /obj/effect/decal/cleanable/ash(get_turf(src))
	qdel(src)

/obj/item/shreddedp
	name = "shredded paper"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "shredp"
	randpixel = 5
	throwforce = 0
	w_class = ITEM_SIZE_TINY
	throw_range = 3
	throw_speed = 1

/obj/item/shreddedp/New()
	..()
	if(prob(65)) color = pick("#bababa","#7f7f7f")
