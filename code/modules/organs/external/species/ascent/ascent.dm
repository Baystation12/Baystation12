/obj/item/organ/external/groin/insectoid/mantid
	name = "central support limb"
	action_button_name = "Weave Razorweb"
	var/list/existing_webs = list()
	var/list/max_webs = 4
	var/web_weave_time = 20 SECONDS
	var/cooldown

/obj/item/organ/external/groin/insectoid/mantid/gyne
	max_webs = 8
	web_weave_time = 10 SECONDS

/obj/item/organ/external/groin/insectoid/mantid/Destroy()
	for(var/obj/effect/razorweb/web in existing_webs)
		web.owner = null
	existing_webs.Cut()
	. = ..()
	
/obj/item/organ/external/groin/insectoid/mantid/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = "weave-web-[cooldown ? "off" : "on"]"
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

		if(length(existing_webs) >= max_webs)
			to_chat(owner, SPAN_WARNING("You cannot maintain more than [max_webs] razorweb\s."))
			return

		playsound(user, 'sound/effects/razorweb_hiss.ogg', 70)
		owner.visible_message(SPAN_WARNING("\The [owner] separates their jaws and begins to weave a web of crystalline filaments..."))
		cooldown = TRUE
		refresh_action_button()
		addtimer(CALLBACK(src, .proc/reset_cooldown), web_weave_time)
		if(do_after(owner, web_weave_time) && length(existing_webs) < max_webs)
			playsound(user, 'sound/effects/razorweb.ogg', 70, 0)
			owner.visible_message(SPAN_DANGER("\The [owner] completes a razorweb!"))
			var/obj/effect/razorweb/web = new(owner.loc)
			existing_webs += web
			web.owner = owner

/obj/item/organ/external/groin/insectoid/mantid/proc/reset_cooldown()
	cooldown = FALSE
	refresh_action_button()

/obj/item/organ/external/head/insectoid/mantid
	name = "crested head"
	action_button_name = "Spit Razorweb"
	var/cooldown_time = 2.5 MINUTES
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
