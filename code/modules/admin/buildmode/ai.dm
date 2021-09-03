/datum/build_mode/ai
	name = "AI Editor"
	icon_state = "buildmode14"
	var/list/selected_mobs = list()
	var/list/overlayed_mobs = list()
	var/copied_faction = null
	var/icon/buildmode_hud = icon('icons/misc/buildmode.dmi')
	var/help_text = {"\
	<span class='notice'>***********************************************************<br>\
		Left Mouse Button on non-mob                  = Deselect all mobs<br>\
		Left Mouse Button on AI mob                   = Select/Deselect mob<br>\
		Left Mouse Button + alt on AI mob             = Toggle hostility on mob<br>\
		Left Mouse Button + shift on AI mob           = Toggle AI (also resets)<br>\
		Left Mouse Button + ctrl on AI mob 	          = Select units without deselecting existing ones<br>\
		Right Mouse Button + shift on any mob         = Copy mob faction<br>\
		Right Mouse Button + ctrl on any mob          = Paste mob faction copied with Left Mouse Button + shift<br>\
		Right Mouse Button on enemy mob               = Command selected mobs to attack mob<br>\
		Right Mouse Button on allied mob              = Command selected mobs to follow mob<br>\
		Right Mouse Button + shift on any mob         = Command selected mobs to follow mob regardless of faction<br>\
		Note: The following also reset the mob's home position:<br>\
		Right Mouse Button on tile                    = Command selected mobs to move to tile (will cancel if enemies are seen)<br>\
		Right Mouse Button + shift on tile            = Command selected mobs to reposition to tile (will not be inturrupted by enemies)<br>\
		Right Mouse Button + alt on obj/turfs         = Command selected mobs to attack obj/turf<br>\
		***********************************************************</span>
"}

/datum/build_mode/ai/Help()
	to_chat(user, SPAN_NOTICE(help_text))

/datum/build_mode/ai/Unselected()
	. = ..()

	for (var/mob/M in selected_mobs)
		deselect_AI_mob(M)

	for (var/mob/living/M in GLOB.living_mob_list_)
		user.remove_client_image(M.ai_status_image)

/datum/build_mode/ai/TimerEvent()
	. = ..()

	for (var/mob/living/M in GLOB.living_mob_list_)
		if (M.ai_status_image)
			user.add_client_image(M.ai_status_image)

/datum/build_mode/ai/OnClick(atom/A, list/pa)
	if(pa["left"])
		if(isliving(A))
			var/mob/living/L = A
			var/datum/ai_holder/AI = L.ai_holder

			if (!AI)
				return

			// Select multiple units
			if(pa["ctrl"])
				if(!isnull(L.get_AI_stance()))
					select_AI_mob(A)
				return


			// Pause/unpause AI
			if(pa["shift"])
				var/stance = L.get_AI_stance()
				if(!isnull(stance)) // Null means there's no AI datum or it has one but is player controlled w/o autopilot on.
					if(stance == STANCE_SLEEP)
						AI.go_wake()
						to_chat(user, SPAN_NOTICE("\The [L]'s AI has been enabled."))
					else
						AI.go_sleep()
						to_chat(user, SPAN_NOTICE("\The [L]'s AI has been disabled."))

					toggle_ai_status(L)
					return
				else
					to_chat(user, SPAN_WARNING("\The [L] is not AI controlled."))
				return

			// Toggle hostility
			if(pa["alt"])
				if(!isnull(L.get_AI_stance()))
					AI.hostile = !AI.hostile
					to_chat(user, SPAN_NOTICE("\The [L] is now [AI.hostile ? "hostile" : "passive"]."))
				else
					to_chat(user, SPAN_WARNING("\The [L] is not AI controlled."))
				return


			// Select/Deselect
			if(!isnull(L.get_AI_stance()))
				deselect_all()
				select_AI_mob(L)
				to_chat(user, SPAN_NOTICE("Selected \the [L]."))
				return
			else
				to_chat(user, SPAN_WARNING("\The [L] is not AI controlled."))
				return
		else //Not living
			deselect_all()


	if(pa["right"])

		if (isliving(A))
			var/mob/living/L = A
			// Copy faction
			if(pa["shift"])
				copied_faction = L.faction
				to_chat(user, SPAN_NOTICE("Copied faction '[copied_faction]'."))
				return

			// Paste faction
			if(pa["ctrl"])
				if(!copied_faction)
					to_chat(user, SPAN_WARNING("LMB+Shift a mob to copy their faction before pasting."))
					return
				else
					L.faction = copied_faction
					to_chat(user, SPAN_NOTICE("Pasted faction '[copied_faction]'."))
					return

		if(istype(A, /atom)) // Force attack.
			if(pa["alt"])
				var/i = 0
				for(var/mob/living/unit in selected_mobs)
					var/datum/ai_holder/AI = unit.ai_holder
					AI.give_target(A)
					i++
				to_chat(user, SPAN_NOTICE("Commanded [i] mob\s to attack \the [A]."))
				var/image/orderimage = image(buildmode_hud,A,"ai_targetorder")
				// orderimage.plane = PLANE_BUILDMODE
				flick_overlay(orderimage, list(user.client), 8, TRUE)
				return

		if(isliving(A)) // Follow or attack.
			var/mob/living/L = A
			var/i = 0 // Attacking mobs.
			var/j = 0 // Following mobs.
			for(var/mob/living/unit in selected_mobs)
				var/datum/ai_holder/AI = unit.ai_holder
				if (!AI)
					return
				if(L.IIsAlly(unit) || !AI.hostile || pa["shift"])
					AI.set_follow(L)
					j++
				else
					AI.give_target(L)
					i++
			var/message = "Commanded "
			if(i)
				message += "[i] mob\s to attack \the [L]"
				if(j)
					message += ", and "
				else
					message += "."
			if(j)
				message += "[j] mob\s to follow \the [L]."
			to_chat(user, SPAN_NOTICE(message))
			var/image/orderimage = image(buildmode_hud,L,"ai_targetorder")
			flick_overlay(orderimage, list(user.client), 8, TRUE)
			return

		var/turf/T = get_turf(A)
		if(isturf(T)) // Move or reposition.
			var/forced = 0
			var/told = 0
			for(var/mob/living/unit in selected_mobs)
				var/datum/ai_holder/AI = unit.ai_holder
				AI.home_turf = T
				if(unit.get_AI_stance() == STANCE_SLEEP)
					unit.forceMove(T)
					forced++
				else
					AI.give_destination(T, 0, pa["shift"]) // If shift is held, the mobs will not stop moving to attack a visible enemy.
					told++
			to_chat(user, SPAN_NOTICE("Commanded [told] mob\s to move to \the [T], and manually placed [forced] of them."))
			var/image/orderimage = image(buildmode_hud,T,"ai_turforder")
			flick_overlay(orderimage, list(user.client), 8, TRUE)
			return

/datum/build_mode/ai/proc/select_AI_mob(mob/living/unit)
	selected_mobs += unit
	user.client.images += unit.selected_image
	GLOB.destroyed_event.register(unit, src, .proc/deselect_AI_mob)

/datum/build_mode/ai/proc/deselect_AI_mob(mob/living/unit)
	selected_mobs -= unit
	user.client.images -= unit.selected_image
	GLOB.destroyed_event.unregister(unit, src)

/datum/build_mode/ai/proc/deselect_all()
	for (var/mob/living/M in selected_mobs)
		deselect_AI_mob(M)

/datum/build_mode/ai/proc/is_selected(mob/living/unit)
	if (unit in selected_mobs)
		return TRUE

	return FALSE

/datum/build_mode/ai/proc/toggle_ai_status(mob/living/unit)

	if (unit.ai_status_image)
		user.remove_client_image(unit.ai_status_image)
		QDEL_NULL(unit.ai_status_image)

	if (unit.has_AI())
		unit.ai_status_image = image('icons/misc/buildmode.dmi', unit, "ai_0")
		user.add_client_image(unit.ai_status_image)
	else
		unit.ai_status_image = image('icons/misc/buildmode.dmi', unit, "ai_1")
		user.add_client_image(unit.ai_status_image)
