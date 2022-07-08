#define PARKOUR_TABLE_STAMINA_LOSS -4
#define PARKOUR_LOWWALL_STAMINA_LOSS -5
#define PARKOUR_RAILING_STAMINA_LOSS -2

#define PARKOUR_DOBITFLAGS DO_TARGET_UNIQUE_ACT | DO_USER_CAN_MOVE

#define PARKOUR_MSGLIST list(SPAN_INFO("USR do amazing flip throw OBJ!"), SPAN_INFO("USR perfectly jump throw OBJ!"))

/obj/structure/table/Bumped(atom/A)
	. = ..()

	if(!ishuman(A))
		return
	var/mob/living/carbon/human/H = A
	if(H.is_parkourmode && istype(H.move_intent, /decl/move_intent/run))
		var/turf/place = get_turf(src.loc)
		if(H.parkourthrought)
			while(locate(/obj/structure/table) in place)
				var/turf/next_place = get_step(place, H.dir)
				if (next_place.density || next_place.turf_is_crowded(H))
					break
				place = next_place

		if(!do_after(H, 8, src, PARKOUR_DOBITFLAGS))
			return
		H.adjust_stamina(PARKOUR_TABLE_STAMINA_LOSS)
		H.do_parkour(place)
		visible_message(replacetext(replacetext(pick(PARKOUR_MSGLIST), "OBJ", src), "USR", H))
		add_fingerprint(H)

/obj/structure/wall_frame/Bumped(atom/A)
	. = ..()

	if(!ishuman(A))
		return
	var/mob/living/carbon/human/H = A

	for(var/obj/structure/S in loc)
		if(istype(S, /obj/structure/window))
			return
		else if(istype(S, /obj/structure/grille))
			return

	if(H.is_parkourmode && istype(H.move_intent, /decl/move_intent/run))
		var/turf/place = H.parkourthrought ? get_step(src.loc, H.dir) : get_turf(src.loc)
		if(!do_after(H, 12, src, PARKOUR_DOBITFLAGS))
			return
		H.adjust_stamina(PARKOUR_LOWWALL_STAMINA_LOSS)
		H.do_parkour(place)
		visible_message(replacetext(replacetext(pick(PARKOUR_MSGLIST), "OBJ", src), "USR", H))
		add_fingerprint(H)

/obj/structure/railing/Bumped(atom/A)
	. = ..()

	if(!ishuman(A))
		return
	var/mob/living/carbon/human/H = A
	var/turf/T = get_step(H, H.dir)
	if (T.density || T.turf_is_crowded(H))
		return

	if(!(H.is_parkourmode && istype(H.move_intent, /decl/move_intent/run) && do_after(H, 5, src, PARKOUR_DOBITFLAGS)))
		return

	H.adjust_stamina(PARKOUR_RAILING_STAMINA_LOSS)
	H.do_parkour(T)
	visible_message(replacetext(replacetext(pick(PARKOUR_MSGLIST), "OBJ", src), "USR", H))
	add_fingerprint(H)
