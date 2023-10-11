/obj/decal/writing
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

/obj/decal/writing/New(newloc, _age, _message, _author)
	..(newloc)
	if(!isnull(_age))
		graffiti_age = _age
	message = _message
	if(!isnull(author))
		author = _author

/obj/decal/writing/Initialize()
	var/list/random_icon_states = icon_states(icon)
	for(var/obj/decal/writing/W in loc)
		random_icon_states.Remove(W.icon_state)
	if(length(random_icon_states))
		icon_state = pick(random_icon_states)
	SSpersistence.track_value(src, /datum/persistent/graffiti)
	. = ..()

/obj/decal/writing/Destroy()
	SSpersistence.forget_value(src, /datum/persistent/graffiti)
	. = ..()

/obj/decal/writing/examine(mob/user)
	. = ..(user)
	to_chat(user,  "It reads \"[message]\".")


/obj/decal/writing/use_tool(obj/item/tool, mob/user, list/click_params)
	// Sharp Item - Engrave additional message
	if (is_sharp(tool))
		var/turf/target = get_turf(src)
		target.try_graffiti(user, tool)
		return TRUE

	// Welding Torch - Remove decal
	if (isWelder(tool))
		var/obj/item/weldingtool/welder = tool
		if (!welder.can_use(1, user, "to remove \the [src]."))
			return TRUE
		playsound(src, 'sound/items/Welder2.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] starts burning away \the [src] with \a [tool]."),
			SPAN_NOTICE("You start burning away \the [src] with \the [tool].")
		)
		if (!user.do_skilled(1 SECOND, SKILL_CONSTRUCTION, src, do_flags = DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool) || !welder.can_use(1, user, "to remove \the [src]"))
			return TRUE
		user.visible_message(
			SPAN_NOTICE("\The [user] clears away \the [src] with \a [tool]."),
			SPAN_NOTICE("You clear away \the [src] with \the [tool].")
		)
		playsound(src, 'sound/items/Welder2.ogg', 50, TRUE)
		qdel(src)
		return TRUE

	return ..()
