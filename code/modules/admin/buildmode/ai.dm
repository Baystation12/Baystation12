/datum/build_mode/ai
	name = "AI Editor"
	icon_state = "buildmode14"
	var/list/selected_mobs = list()
	var/list/overlayed_mobs = list()
	var/copied_faction = null
	var/icon/buildmode_hud = icon('icons/misc/buildmode.dmi')
	var/help_text = {"\
	<span class='notice'>***********************************************************<br>\
		Left Mouse Button drag box + ctrl             = Select only mobs in box<br>\
		Left Mouse Button drag box + ctrl + shift     = Select additional mobs in area<br>\
		Left Mouse Button on non-mob                  = Deselect all mobs<br>\
		Left Mouse Button on AI mob                   = Select/Deselect mob<br>\
		Left Mouse Button + alt on AI mob             = Toggle hostility on mob<br>\
		Left Mouse Button + shift on AI mob           = Toggle AI (also resets)<br>\
		Left Mouse Button + ctrl on AI mob 	          = Copy mob faction<br>\
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

			// Pause/unpause AI
			if(pa["shift"])
				var/stance = L.get_AI_stance()
				if(!isnull(stance)) // Null means there's no AI datum or it has one but is player controlled w/o autopilot on.
					var/datum/ai_holder/AI = L.ai_holder
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
					var/datum/ai_holder/AI = L.ai_holder
					AI.hostile = !AI.hostile
					to_chat(user, SPAN_NOTICE("\The [L] is now [AI.hostile ? "hostile" : "passive"]."))
				else
					to_chat(user, SPAN_WARNING("\The [L] is not AI controlled."))
				return

			// Copy faction
			if(pa["ctrl"])
				copied_faction = L.faction
				to_chat(user, SPAN_NOTICE("Copied faction '[copied_faction]'."))
				return

			// Select/Deselect
			if(!isnull(L.get_AI_stance()))
				if(L in selected_mobs)
					deselect_AI_mob(L)
					to_chat(user, SPAN_NOTICE("Deselected \the [L]."))
				else
					select_AI_mob(L)
					to_chat(user, SPAN_NOTICE("Selected \the [L]."))
				return
			else
				to_chat(user, SPAN_WARNING("\The [L] is not AI controlled."))
				return
		else //Not living
			for(var/mob/living/unit in selected_mobs)
				deselect_AI_mob(unit)


	if(pa["right"])
		// Paste faction
		if(pa["ctrl"] && isliving(A))
			if(!copied_faction)
				to_chat(user, SPAN_WARNING("LMB+Shift a mob to copy their faction before pasting."))
				return
			else
				var/mob/living/L = A
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

/datum/build_mode/ai/proc/deselect_AI_mob(mob/living/unit)
	selected_mobs -= unit
	user.client.images -= unit.selected_image

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

/proc/build_drag(var/client/user, buildmode, var/atom/fromatom, var/atom/toatom, var/atom/fromloc, var/atom/toloc, var/fromcontrol, var/tocontrol, params)
	if (!istype(buildmode, /datum/build_mode/ai))
		return

	var/datum/build_mode/ai/holder = buildmode
	for(var/datum/build_mode/ai/H)
		if(H.user == user)
			holder = H
			break
	if(!holder) return
	var/list/pa = params2list(params)
	if (pa["ctrl"])
		//Holding shift prevents the deselection of existing
		if(!pa["shift"])
			for(var/mob/living/unit in holder.selected_mobs)
				holder.deselect_AI_mob(unit)

		var/turf/c1 = get_turf(fromatom)
		var/turf/c2 = get_turf(toatom)
		if(!c1 || !c2)
			return //Dragged outside window or something

		var/low_x = min(c1.x,c2.x)
		var/low_y = min(c1.y,c2.y)
		var/hi_x = max(c1.x,c2.x)
		var/hi_y = max(c1.y,c2.y)
		var/z = c1.z //Eh

		var/i = 0
		for(var/mob/living/L in GLOB.living_mob_list_)
			if(L.z != z || L.client)
				continue
			if(L.x >= low_x && L.x <= hi_x && L.y >= low_y && L.y <= hi_y)
				if (L.ai_holder)
					holder.select_AI_mob(L)
				i++

		to_chat(user, SPAN_NOTICE("Band-selected [i] mobs."))
	return
