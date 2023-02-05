/obj/item/stack/material/rods
	name = "rod"
	desc = "Some rods. Can be used for building, or something."
	singular_name = "rod"
	plural_name = "rods"
	icon_state = "rod"
	plural_icon_state = "rod-mult"
	max_icon_state = "rod-max"
	w_class = ITEM_SIZE_LARGE
	attack_cooldown = 21
	melee_accuracy_bonus = -20
	throw_speed = 5
	throw_range = 20
	max_amount = 100
	base_parry_chance = 15
	attack_verb = list("hit", "bludgeoned", "whacked")
	lock_picking_level = 3
	matter_multiplier = 0.5
	material_flags = USE_MATERIAL_COLOR
	stacktype = /obj/item/stack/material/rods
	default_type = MATERIAL_STEEL

/obj/item/stack/material/rods/ten
	amount = 10

/obj/item/stack/material/rods/fifty
	amount = 50

/obj/item/stack/material/rods/cyborg
	name = "metal rod synthesizer"
	desc = "A device that makes metal rods."
	gender = NEUTER
	matter = null
	uses_charge = 1
	charge_costs = list(500)

/obj/item/stack/material/rods/Initialize()
	. = ..()
	update_icon()
	throwforce = round(0.25*material.get_edge_damage())
	force = round(0.5*material.get_blunt_damage())


/obj/item/stack/material/rods/get_interactions_info()
	. = ..()
	.[CODEX_INTERACTION_WELDER] = "<p>Shapes the rods back into sheets. Requires 2 rods and 5 units of fuel.</p>"


/obj/item/stack/material/rods/use_tool(obj/item/tool, mob/user, list/click_params)
	// Welding Tool - Form into sheets
	if (isWelder(tool))
		if (!can_use(2))
			to_chat(user, SPAN_WARNING("You need at least two [plural_name] to reshape them into sheets."))
			return TRUE
		var/obj/item/weldingtool/welder = tool
		if (!welder.can_use(5, user, "to reshape \the [src] into sheets."))
			return TRUE
		use(2)
		welder.remove_fuel(5, user)
		var/obj/item/stack/material/new_stack = new(get_turf(src), 1, get_material_name())
		new_stack.add_to_stacks(user)
		user.visible_message(
			SPAN_NOTICE("\The [user] shapes some of \the [src] into sheets with \a [tool]."),
			SPAN_NOTICE("You shape some of \the [src] into sheets with \the [tool]."),
			SPAN_ITALIC("You hear welding.")
		)
		return TRUE

	return ..()


/obj/item/stack/material/rods/attack_self(mob/user as mob)
	src.add_fingerprint(user)

	if(!istype(user.loc,/turf)) return 0

	place_grille(user, user.loc, src)
