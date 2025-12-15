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
	var/create_sound = 'sound/machines/click.ogg'

/obj/item/holosign_creator/Destroy()
	for(var/sign in signs)
		qdel(sign)
	signs.Cut()
	. = ..()

/obj/item/holosign_creator/proc/create_holosign(atom/target, mob/living/user, click_parameters)
	var/turf/target_turf = get_turf(target)
	if (!target_turf) return FALSE
	var/obj/structure/holosign/holosign = locate(holosign_type) in target_turf
	if (holosign) return FALSE

	if (!is_blocked_turf(target_turf, TRUE))
		if (holocreator_busy)
			to_chat(user, SPAN_NOTICE("[src] is busy creating a hologram."))
			return TRUE
		if (length(signs) < max_signs)
			playsound(src.loc, create_sound, 20, 1)
			if(creation_time)
				holocreator_busy = TRUE
				if(!do_after(user, creation_time, target, DO_BOTH_UNIQUE_ACT))
					holocreator_busy = FALSE
					return TRUE
				holocreator_busy = FALSE
				if(length(signs) >= max_signs)
					return TRUE
				if(is_blocked_turf(target_turf, TRUE))
					return TRUE
			holosign = new holosign_type(get_turf(target), src)
			to_chat(user, SPAN_NOTICE("You create \a [holosign] with [src]."))
		else
			to_chat(user, SPAN_NOTICE("[src] is projecting at max capacity!"))
		return TRUE

/obj/item/holosign_creator/use_after(atom/target, mob/living/user, click_parameters)
	create_holosign(target, user, click_parameters)

/obj/item/holosign_creator/attack_self(mob/user)
	if(length(signs))
		for(var/holosign in signs)
			qdel(holosign)
		to_chat(user, SPAN_NOTICE("You clear all active holograms."))

/obj/item/holosign_creator/stellascope
	name = "stellascope"
	desc = "An antique and delicate looking instrument used to study the stars."
	icon = 'icons/obj/toy.dmi'
	icon_state = "stellascope"
	max_signs = 1
	creation_time = 5
	holosign_type = /obj/structure/holosign/constellation
	create_sound = 'sound/effects/jingle.ogg'
