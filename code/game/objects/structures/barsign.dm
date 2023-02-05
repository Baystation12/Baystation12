/obj/structure/sign/double/barsign
	desc = "A jumbo-sized LED sign. This one seems to be showing its age."
	icon = 'icons/obj/barsigns.dmi'
	icon_state = "empty"
	appearance_flags = DEFAULT_APPEARANCE_FLAGS
	anchored = TRUE
	req_access = list(access_kitchen)
	var/cult = 0

/obj/structure/sign/double/barsign/proc/get_valid_states(initial=1)
	. = icon_states(icon)
	. -= "on"
	. -= "narsiebistro"
	. -= "empty"
	if(initial)
		. -= "Off"

/obj/structure/sign/double/barsign/examine(mob/user)
	. = ..()
	switch(icon_state)
		if("Off")
			to_chat(user, "It appears to be switched off.")
		if("narsiebistro")
			to_chat(user, "It shows a picture of a large black and red being. Spooky!")
		if("on", "empty")
			to_chat(user, "The lights are on, but there's no picture.")
		if("Mess Hall - SEV Torch")
			to_chat(user, "It appears to be a red haired monk wearing a cheese costume, swinging a hoop around their thighs, holding two torches, inviting you into the mess hall.")
		if("Information Action Ratio")
			to_chat(user, "It's the place to go!")
		if("Three Starboard")
			to_chat(user, "It says 'Three Starboard' alongside a crude rendition of the SEV Torch- who makes this stuff?")
		if("The Clowns Head")
			to_chat(user, "A rather catching portrait of what you can only presume to be the idea of a madman... A Clown Queen...")
		if("The Cranky Goldfish")
			to_chat(user, "A crank-powered fish! Why hadn't you thought of that...")
		if("The Cat Caller")
			to_chat(user, "An adorable neon kitty to brighten up your day.")
		if("The Diplomatic Resolution")
			to_chat(user, "Here's hoping they can talk it out over beer...")
		if("Dragons Hoard")
			to_chat(user, "It says 'DRAGONS HOARD'. What cunning adventurer shall swipe the hoard for themselves?")
		if("Closed")
			to_chat(user, "How unfortunate...")
		if("Free Drinks!")
			to_chat(user, "Yippee!")
		if("We Are Open!")
			to_chat(user, "Come on in!")
		if("The Meta Game")
			to_chat(user, "Big Brain Plays.")
		if("Bless This Mess")
			to_chat(user, "It fills you with a snuggly wuggly sense of warmth and comfort.")
		if("The Redshirt")
			to_chat(user, "Mmm... Donuts...")
		else
			to_chat(user, "It says '[icon_state]'")

/obj/structure/sign/double/barsign/New()
	..()
	icon_state = pick(get_valid_states())


/obj/structure/sign/double/barsign/get_interactions_info()
	. = ..()
	.[CODEX_INTERACTION_ID_CARD] = "<p>Allows changing the sign's display icon, if the ID has access.</p>"
	. -= CODEX_INTERACTION_SCREWDRIVER


/obj/structure/sign/double/barsign/use_tool(obj/item/tool, mob/user, list/click_params)
	// ID Card - Change display
	var/obj/item/card/id/id = tool.GetIdCard()
	if (istype(id))
		var/id_name = GET_ID_NAME(id, tool)
		if (cult)
			to_chat(user, SPAN_WARNING("\The [src] doesn't respond to [id_name]."))
			return TRUE
		if (!check_access(id))
			to_chat(user, SPAN_WARNING("\The [src] refuses [id_name]."))
			return TRUE
		var/sign_type = input(user, "What would you like to change the barsign to?", "[src] Display", icon_state) as null|anything in get_valid_states(FALSE)
		if (!sign_type || sign_type == icon_state || !user.use_sanity_check(src, id))
			return TRUE
		icon_state = sign_type
		user.visible_message(
			SPAN_NOTICE("\The [user] changes \the [src]'s display with \a [tool]."),
			SPAN_NOTICE("You change \the [src]'s display to '[sign_type]' with [id_name].")
		)
		return TRUE

	// Screwdriver - Block removal
	if (isScrewdriver(tool))
		to_chat(user, SPAN_WARNING("\The [src] can't be removed."))
		return TRUE

	return ..()
