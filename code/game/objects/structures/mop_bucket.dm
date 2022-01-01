/obj/structure/mopbucket
	name = "mop bucket"
	desc = "Fill it with water, but don't forget a mop!"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "mopbucket"
	density = TRUE
	w_class = ITEM_SIZE_NORMAL
	atom_flags = ATOM_FLAG_CLIMBABLE | ATOM_FLAG_OPEN_CONTAINER
	var/amount_per_transfer_from_this = 5	//shit I dunno, adding this so syringes stop runtime erroring. --NeoFite


/obj/structure/mopbucket/New()
	create_reagents(180)
	..()

/obj/structure/mopbucket/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		to_chat(user, "[src] [icon2html(src, user)] contains [reagents.total_volume] unit\s of water!")

/obj/structure/mopbucket/use_item(obj/item/I, mob/user)
	if(istype(I, /obj/item/mop))
		if(reagents.total_volume < 1)
			to_chat(user, "<span class='warning'>\The [src] is out of water!</span>")
		else
			reagents.trans_to_obj(I, 5)
			to_chat(user, "<span class='notice'>You wet \the [I] in \the [src].</span>")
			playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
