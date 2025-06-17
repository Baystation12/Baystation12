/obj/item/flatpack
	abstract_type = /obj/item/flatpack
	w_class = ITEM_SIZE_NORMAL
	var/deploy_time = 2 SECONDS
	var/deploy_sound = 'sound/items/Deconstruct.ogg'
	var/deploy_path


/obj/item/flatpack/use_after(atom/target, mob/living/user, click_parameters)
	if (!deploy_path)
		return
	if (loc != user)
		return
	var/turf/T = get_turf(target)
	if (!user.TurfAdjacent(T))
		return
	if (isspaceturf(T) || isopenspace(T))
		to_chat(user, SPAN_WARNING("You cannot use \the [src] in open space."))
		return TRUE
	var/obstruction = T.get_obstruction()
	if (obstruction)
		to_chat(user, SPAN_WARNING("\The [english_list(obstruction)] is blocking that spot."))
		return TRUE
	user.visible_message(
		SPAN_ITALIC("\The [user] starts assembling \an [src]."),
		SPAN_ITALIC("You start assembling \the [src]."),
		SPAN_ITALIC("You can hear rustling of planks and sheets."),
		range = 5
	)
	if (!do_after(user, deploy_time, target, DO_PUBLIC_UNIQUE) || QDELETED(src))
		return TRUE
	obstruction = T.get_obstruction()
	if (obstruction)
		to_chat(user, SPAN_WARNING("\The [english_list(obstruction)] is blocking that spot."))
		return TRUE
	user.visible_message(
		SPAN_ITALIC("\The [user] finishes assembling \an [src]."),
		SPAN_NOTICE("You assemble \the [src]."),
		range = 5
	)
	playsound(src, deploy_sound, 50, TRUE)
	var/obj/R = new deploy_path(T)
	transfer_fingerprints_to(R)
	R.add_fingerprint(user)
	copy_health(src, R)
	qdel(src)
	return TRUE
