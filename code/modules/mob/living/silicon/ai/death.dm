/mob/living/silicon/ai/death(gibbed)

	if(stat == DEAD)
		return

	if (src.custom_sprite == 1)//check for custom AI sprite, defaulting to blue screen if no.
		icon_state = "[ckey]-ai-crash"
	else
		icon_state = "ai-crash"

	if(src.eyeobj)
		src.eyeobj.setLoc(get_turf(src))

	remove_ai_verbs(src)

	for(var/obj/machinery/ai_status_display/O in world)
		spawn( 0 )
		O.mode = 2
		if (istype(loc, /obj/item/device/aicard))
			var/obj/item/device/aicard/card = loc
			card.update_icon()

	return ..(gibbed,"gives one shrill beep before falling lifeless.")
