/mob/living/silicon/ai/death(gibbed)

	if(stat == DEAD)
		return

	if(src.eyeobj)
		src.eyeobj.setLoc(get_turf(src))


	stop_malf(0) // Remove AI's malfunction status, that will fix all hacked APCs, disable delta, etc.
	remove_ai_verbs(src)

	for(var/obj/machinery/ai_status_display/O in world)
		O.mode = 2

	if (istype(loc, /obj/item/weapon/aicard))
		var/obj/item/weapon/aicard/card = loc
		card.update_icon()

	. = ..(gibbed,"gives one shrill beep before falling lifeless.")
	set_density(1)
