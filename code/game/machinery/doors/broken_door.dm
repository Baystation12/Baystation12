/obj/structure/broken_door
	name = "broken airlock"
	desc = "An airlock that's been completely and forcefully broken open. There's barely anything left to salvage."
	icon = 'icons/obj/doors/station/door.dmi'
	icon_state = "open"
	anchored = TRUE
	obj_flags = OBJ_FLAG_NOFALL


/obj/structure/broken_door/get_interactions_info()
	. = ..()
	.[CODEX_INTERACTION_WELDER] = "<p>Dismantles \the [initial(name)]. Costs 1 unit of fuel and provides 1 sheet of steel.</p>"


/obj/structure/broken_door/use_tool(obj/item/tool, mob/living/user, list/click_params)
	if (isWelder(tool))
		var/obj/item/weldingtool/welder = tool
		if (!welder.can_use(1, user, "to deconstruct \the [src]"))
			return TRUE
		user.visible_message(
			SPAN_NOTICE("\The [user] starts welding \the [src] with \a [tool]."),
			SPAN_NOTICE("You start welding \the [src] with \the [tool]."),
			SPAN_ITALIC("You hear welding.")
		)
		add_fingerprint(user, FALSE, tool)
		playsound(src, 'sound/items/Welder.ogg', 50, TRUE)
		if (!user.do_skilled(SKILL_CONSTRUCTION, 2 SECONDS, src, do_flags = DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
			return TRUE
		if (!welder.remove_fuel(1, user))
			return TRUE
		var/obj/item/stack/material/steel/materials = new (loc, 1)
		transfer_fingerprints_to(materials)
		user.visible_message(
			SPAN_NOTICE("\The [user] dismantles \the [src] with \a [tool]."),
			SPAN_NOTICE("You dismantle \the [src] with \the [tool]."),
			SPAN_ITALIC("You hear welding.")
		)
		qdel_self()
		return TRUE

	return ..()
