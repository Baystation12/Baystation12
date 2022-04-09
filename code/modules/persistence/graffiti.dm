/obj/effect/decal/writing
	name = "graffiti"
	icon_state = "writing1"
	icon = 'icons/effects/writing.dmi'
	desc = "It looks like someone has scratched something here."
	gender = PLURAL
	blend_mode = BLEND_MULTIPLY
	color = "#000000"
	alpha = 120
	anchored = TRUE

	var/message
	var/graffiti_age = 0
	var/author = "unknown"

/obj/effect/decal/writing/New(var/newloc, var/_age, var/_message, var/_author)
	..(newloc)
	if(!isnull(_age))
		graffiti_age = _age
	message = _message
	if(!isnull(author))
		author = _author

/obj/effect/decal/writing/Initialize()
	var/list/random_icon_states = icon_states(icon)
	for(var/obj/effect/decal/writing/W in loc)
		random_icon_states.Remove(W.icon_state)
	if(random_icon_states.len)
		icon_state = pick(random_icon_states)
	SSpersistence.track_value(src, /datum/persistent/graffiti)
	. = ..()

/obj/effect/decal/writing/Destroy()
	SSpersistence.forget_value(src, /datum/persistent/graffiti)
	. = ..()

/obj/effect/decal/writing/examine(mob/user)
	. = ..(user)
	to_chat(user,  "It reads \"[message]\".")

/obj/effect/decal/writing/attackby(var/obj/item/thing, var/mob/user)
	if(isWelder(thing))
		var/obj/item/weldingtool/welder = thing
		if(welder.isOn() && welder.remove_fuel(0,user) && do_after(user, 5, src) && !QDELETED(src))
			playsound(src.loc, 'sound/items/Welder2.ogg', 50, 1)
			user.visible_message("<span class='notice'>\The [user] clears away some graffiti.</span>")
			qdel(src)
	else if(thing.sharp)

		if(jobban_isbanned(user, "Graffiti"))
			to_chat(user, SPAN_WARNING("You are banned from leaving persistent information across rounds."))
			return

		var/_message = sanitize(input("Enter an additional message to engrave.", "Graffiti") as null|text, trim = TRUE)
		if(_message && loc && user && !user.incapacitated() && user.Adjacent(loc) && thing.loc == user)
			user.visible_message("<span class='warning'>\The [user] begins carving something into \the [loc].</span>")
			if(do_after(user, max(20, length(_message)), src) && loc)
				user.visible_message("<span class='danger'>\The [user] carves some graffiti into \the [loc].</span>")
				message = "[message] [_message]"
				author = user.ckey
				if(lowertext(message) == "elbereth")
					to_chat(user, "<span class='notice'>You feel much safer.</span>")
	else
		. = ..()
