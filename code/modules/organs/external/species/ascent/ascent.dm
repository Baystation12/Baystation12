/obj/item/organ/external/groin/insectoid/mantid
	name = "central support limb"
	action_button_name = "Weave Razorweb"

	var/web_charges =     10
	var/max_web_charges = 10
	var/web_weave_time =  10 SECONDS
	var/web_charge_time = 30 SECONDS
	var/next_recharge =   0
	var/cooldown

/obj/item/organ/external/groin/insectoid/mantid/Process()
	. = ..()
	if(world.time > next_recharge && web_charges < max_web_charges)
		web_charges++
		next_recharge = world.time + web_charge_time
		refresh_action_button()

/obj/item/organ/external/groin/insectoid/mantid/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = "weave-web-[(web_charges && !cooldown) ? "on" : "off"]"
		if(action.button) action.button.UpdateIcon()

/obj/item/organ/external/groin/insectoid/mantid/attack_self(var/mob/user)
	. = ..()
	if(. && !cooldown)

		if(!isturf(owner.loc))
			to_chat(owner, SPAN_WARNING("You cannot use this ability in this location."))
			return

		if(locate(/obj/effect/razorweb) in owner.loc)
			to_chat(owner, SPAN_WARNING("There is already a razorweb here."))
			return

		playsound(user, 'sound/effects/razorweb_hiss.ogg', 70)
		owner.visible_message(SPAN_WARNING("\The [owner] separates their jaws and begins to weave a web of crystalline filaments..."))
		cooldown = TRUE
		refresh_action_button()
		addtimer(CALLBACK(src, .proc/reset_cooldown), web_weave_time)
		if(do_after(owner, web_weave_time) && web_charges)
			playsound(user, 'sound/effects/razorweb.ogg', 70, 0)
			owner.visible_message(SPAN_DANGER("\The [owner] completes a razorweb!"))
			web_charges--
			new /obj/effect/razorweb(owner.loc)

/obj/item/organ/external/groin/insectoid/mantid/proc/reset_cooldown()
	cooldown = FALSE
	refresh_action_button()

/obj/item/organ/external/head/insectoid/mantid
	name = "crested head"
	action_button_name = "Spit Razorweb"
	var/cooldown_time = 1 MINUTE
	var/cooldown

/obj/item/organ/external/head/insectoid/mantid/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = "shot-web-[cooldown ? "off" : "on"]"
		if(action.button) action.button.UpdateIcon()

/obj/item/organ/external/head/insectoid/mantid/attack_self(var/mob/user)
	. = ..()
	if(.)

		if(cooldown)
			to_chat(owner, SPAN_WARNING("Your filament channel hasn't refilled yet!"))
			return

		var/obj/item/razorweb/web = new(get_turf(owner))
		if(owner.put_in_hands(web))
			playsound(user, 'sound/effects/razorweb.ogg', 100)
			to_chat(owner, SPAN_WARNING("You spit up a wad of razorweb, ready to throw!"))
			owner.throw_mode_on()
			cooldown = TRUE
			refresh_action_button()
			addtimer(CALLBACK(src, .proc/reset_cooldown), cooldown_time)
		else
			qdel(web)

/obj/item/organ/external/head/insectoid/mantid/proc/reset_cooldown()
	cooldown = FALSE
	refresh_action_button()
