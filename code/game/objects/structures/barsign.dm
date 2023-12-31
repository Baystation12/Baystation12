/obj/structure/sign/double/barsign
	desc = "A jumbo-sized LED sign. This one seems to be showing its age."
	icon = 'icons/obj/structures/barsigns.dmi'
	icon_state = "on"
	appearance_flags = DEFAULT_APPEARANCE_FLAGS
	anchored = TRUE
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
		if("The Singulo")
			to_chat(user, "You spin me right 'round, baby right 'round.")
		else
			to_chat(user, "It says '[icon_state]'")

/obj/structure/sign/double/barsign/New()
	..()
	icon_state = pick(get_valid_states())


/obj/structure/sign/double/barsign/use_tool(obj/item/tool, mob/user, list/click_params)
	// ID Card - Change barsign
	var/obj/item/card/id/id = tool.GetIdCard()
	if (istype(id))
		var/id_name = GET_ID_NAME(id, tool)
		if (!check_access(id))
			USE_FEEDBACK_ID_CARD_DENIED(src, id_name)
			return TRUE
		if (cult)
			USE_FEEDBACK_FAILURE("\The [src]'s display can't be changed.")
			return TRUE
		var/input = input(user, "What would you like to change the barsign to?") as null|anything in get_valid_states(FALSE)
		if (!input || input == icon_state || !user.use_sanity_check(src, tool))
			return TRUE
		icon_state = input
		user.visible_message(
			SPAN_NOTICE("\The [user] updates \the [src]'s display with \a [tool]."),
			SPAN_NOTICE("You update \the [src]'s display with [id_name].")
		)
		return TRUE

	return ..()
