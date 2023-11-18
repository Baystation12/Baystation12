/obj/item/holosign_creator
	name = "holographic sign projector"
	desc = "A handy-dandy holographic projector that displays a janitorial sign."
	icon = 'icons/obj/janitor_tools.dmi'
	icon_state = "signmaker"
	item_state = "electronic"
	force = 0
	w_class = ITEM_SIZE_SMALL
	throwforce = 0
	throw_speed = 3
	throw_range = 7
	var/list/signs = list()
	var/max_signs = 10
	var/creation_time = 0 //time to create a holosign in deciseconds.
	var/holosign_type = /obj/structure/holosign
	var/holocreator_busy = FALSE //to prevent placing multiple holo barriers at once

/obj/item/holosign_creator/Destroy()
	for(var/sign in signs)
		qdel(sign)
	signs.Cut()
	. = ..()

/obj/item/holosign_creator/use_after(atom/target, mob/living/user, click_parameters)
	var/turf/T = get_turf(target)
	if (!T) return FALSE
	var/obj/structure/holosign/H = locate(holosign_type) in T
	if (H) return FALSE

	if (!is_blocked_turf(T, TRUE)) //can't put holograms on a tile that has dense stuff
		if (holocreator_busy)
			to_chat(user, SPAN_NOTICE("[src] is busy creating a hologram."))
			return TRUE
		if (length(signs) < max_signs)
			playsound(src.loc, 'sound/machines/click.ogg', 20, 1)
			if(creation_time)
				holocreator_busy = TRUE
				if(!do_after(user, creation_time, target, DO_BOTH_UNIQUE_ACT))
					holocreator_busy = FALSE
					return TRUE
				holocreator_busy = FALSE
				if(length(signs) >= max_signs)
					return TRUE
				if(is_blocked_turf(T, TRUE)) //don't try to sneak dense stuff on our tile during the wait.
					return TRUE
			H = new holosign_type(get_turf(target), src)
			to_chat(user, SPAN_NOTICE("You create \a [H] with [src]."))
		else
			to_chat(user, SPAN_NOTICE("[src] is projecting at max capacity!"))
		return TRUE

/obj/item/holosign_creator/attack_self(mob/user)
	if(length(signs))
		for(var/H in signs)
			qdel(H)
		to_chat(user, SPAN_NOTICE("You clear all active holograms."))
