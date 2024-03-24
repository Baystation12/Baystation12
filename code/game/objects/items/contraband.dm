//Let's get some REAL contraband stuff in here. Because come on, getting brigged for LIPSTICK is no fun.

//Illicit drugs~
/obj/item/storage/pill_bottle/happy
	name = "bottle of Happy pills"
	desc = "Highly illegal drug. When you want to see the rainbow."
	wrapper_color = COLOR_PINK
	startswith = list(/obj/item/reagent_containers/pill/happy = 10)

/obj/item/storage/pill_bottle/zoom
	name = "bottle of Zoom pills"
	desc = "Highly illegal drug. Trade brain for speed."
	wrapper_color = COLOR_BLUE
	startswith = list(/obj/item/reagent_containers/pill/zoom = 10)

/obj/item/storage/pill_bottle/three_eye
	name = "bottle of Three Eye pills"
	desc = "Highly illegal drug. Stimulates rarely used portions of the brain."
	wrapper_color = COLOR_BLUE
	startswith = list(/obj/item/reagent_containers/pill/three_eye = 10)

/obj/item/reagent_containers/glass/beaker/vial/random
	atom_flags = 0
	var/list/random_reagent_list = list(list(/datum/reagent/water = 15) = 1, list(/datum/reagent/space_cleaner = 15) = 1)

/obj/item/reagent_containers/glass/beaker/vial/random/toxin
	random_reagent_list = list(
		list(/datum/reagent/drugs/mindbreaker = 10, /datum/reagent/drugs/hextro = 20) = 3,
		list(/datum/reagent/toxin/carpotoxin = 15)                             = 2,
		list(/datum/reagent/impedrezene = 15)                                  = 2,
		list(/datum/reagent/toxin/zombiepowder = 10)                           = 1)

/obj/item/reagent_containers/glass/beaker/vial/random/New()
	..()
	if(is_open_container())
		atom_flags ^= ATOM_FLAG_OPEN_CONTAINER

	var/list/picked_reagents = pickweight(random_reagent_list)
	for(var/reagent in picked_reagents)
		reagents.add_reagent(reagent, picked_reagents[reagent])

	var/list/names = new
	for(var/datum/reagent/R in reagents.reagent_list)
		names += R.name

	desc = "Contains [english_list(names)]."
	update_icon()

// Powdered drug item

/obj/item/reagent_containers/powder
	name = "chemical powder"
	desc = "A powdered form of... something."
	icon = 'icons/obj/chemical_storage.dmi'
	icon_state = "powder"
	item_state = "powder"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = 5
	w_class = ITEM_SIZE_TINY
	volume = 50

/obj/item/reagent_containers/powder/examine(mob/user)
	. = ..()
	if(reagents)
		to_chat(user, SPAN_NOTICE("There's about [reagents.total_volume] unit\s here."))

/obj/item/reagent_containers/powder/Initialize()
	..()
	get_appearance()

/obj/item/reagent_containers/powder/proc/get_appearance()
	/// Color based on dominant reagent.
	if (length(reagents.reagent_list) > 0)
		color = reagents.get_color()

// Proc to shove them up your nose

/obj/item/reagent_containers/powder/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(istype(W, /obj/item/glass_extra/straw) || istype(W, /obj/item/paper/cig) || istype(W, /obj/item/spacecash))
		if(!user.check_has_mouth()) // We dont want dionae or adherents doing lines of cocaine. Probably.
			to_chat(SPAN_WARNING("Without a nose, you seem unable to snort from \the [src]."))
			return TRUE

		user.visible_message(
			SPAN_WARNING("\The [user] starts to snort some of \the [src] with \a [W]!"),
			SPAN_NOTICE("You start to snort some of \the [src] with \the [W]!")
		)
		playsound(loc, 'sound/effects/snort.ogg', 50, 1)
		if (!do_after(user, 2 SECONDS, src, DO_PUBLIC_UNIQUE))
			return TRUE

		user.visible_message(
			SPAN_WARNING("\The [user] snorts some of \the [src] with \a [W]!"),
			SPAN_NOTICE("You snort \the [src] with \the [W]!")
		)
		playsound(loc, 'sound/effects/snort.ogg', 50, 1)

		if(reagents)
			reagents.trans_to_mob(user, amount_per_transfer_from_this, CHEM_BLOOD)

		if(!reagents.total_volume)
			qdel(src)
		return TRUE
	return ..()
