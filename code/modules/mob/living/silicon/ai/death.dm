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

	var/callshuttle = 0
	for(var/obj/machinery/computer/communications/commconsole in world)
		if(commconsole.z == 2)
			continue
		if(istype(commconsole.loc,/turf))
			break
		callshuttle++

	for(var/obj/item/weapon/circuitboard/communications/commboard in world)
		if(commboard.z == 2)
			continue
		if(istype(commboard.loc,/turf) || istype(commboard.loc,/obj/item/weapon/storage))
			break
		callshuttle++

	for(var/mob/living/silicon/ai/shuttlecaller in player_list)
		if(shuttlecaller.z == 2)
			continue
		if(!shuttlecaller.stat && shuttlecaller.client && istype(shuttlecaller.loc,/turf))
			break
		callshuttle++

	if(ticker.mode.name == "revolution")
		callshuttle = 0

	if(callshuttle == 3) //if all three conditions are met
		emergency_shuttle.call_evac()
		log_game("All the AIs, comm consoles and boards are destroyed. Shuttle called.")
		message_admins("All the AIs, comm consoles and boards are destroyed. Shuttle called.", 1)

	for(var/obj/machinery/ai_status_display/O in world)
		spawn( 0 )
		O.mode = 2
		if (istype(loc, /obj/item/device/aicard))
			var/obj/item/device/aicard/card = loc
			card.update_icon()

	return ..(gibbed,"gives one shrill beep before falling lifeless.")
