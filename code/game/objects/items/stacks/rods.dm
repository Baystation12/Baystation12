/obj/item/stack/material/rods
	name = "rod"
	desc = "Some rods. Can be used for building, or something."
	singular_name = "rod"
	plural_name = "rods"
	icon_state = "rod"
	base_state = "rod"
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

/obj/item/stack/material/rods/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(isWelder(W))
		var/obj/item/weldingtool/WT = W

		if(material.ignition_point)
			to_chat(user, SPAN_WARNING("You can't weld this material into sheets."))
			return TRUE

		if(!can_use(2))
			to_chat(user, SPAN_WARNING("You need at least two rods to do this."))
			return TRUE

		if(WT.remove_fuel(1,user))
			var/obj/item/stack/material/new_item = material.place_sheet(usr.loc)
			new_item.add_to_stacks(usr)
			user.visible_message(
				SPAN_NOTICE("\The [user] welds \the [src] into \a [material.sheet_singular_name]."),
				SPAN_NOTICE("You weld \the [src] into \a [material.sheet_singular_name].")
				)
			var/obj/item/stack/material/rods/R = src
			src = null
			var/replace = (user.get_inactive_hand()==R)
			R.use(2)
			if (!R && replace)
				user.put_in_hands(new_item)
			return TRUE

	return ..()

/obj/item/stack/material/rods/attack_self(mob/user as mob)
	src.add_fingerprint(user)

	if(!istype(user.loc,/turf)) return 0

	place_grille(user, user.loc, src)
