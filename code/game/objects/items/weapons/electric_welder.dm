/obj/item/weldingtool/electric
	name = "arc welder"
	desc = "A man-portable arc welding tool."
	icon_state = "welder_arc"
	welding_resource = "stored charge"
	tank = null
	waterproof = TRUE
	force = 7
	throwforce = 7
	origin_tech = list(TECH_POWER = 5, TECH_ENGINEERING = 4)
	var/obj/item/cell/cell = /obj/item/cell/high
	var/fuel_cost_multiplier = 10

/obj/item/weldingtool/electric/Initialize()
	if(ispath(cell))
		cell = new cell(src)
	. = ..()

/obj/item/weldingtool/electric/examine(mob/user, distance)
	. = ..()
	if (!cell)
		to_chat(user, "There is no [welding_resource] source attached.")
	else
		to_chat(user, (distance == 0 ? "It has [get_fuel()] [welding_resource] remaining. " : "") + "[cell] is attached.")

/obj/item/weldingtool/electric/use_after(obj/O, mob/living/user)
	if(istype(O, /obj/structure/reagent_dispensers/fueltank))
		if(!welding)
			to_chat(user, SPAN_WARNING("\The [src] runs on an internal charge and does not need to be refuelled."))
		return TRUE
	return ..()

/obj/item/weldingtool/electric/get_cell()
	if(cell)
		. = cell
	else if(istype(loc, /obj/item/rig_module))
		var/obj/item/rig_module/module = loc
		if(istype(module.holder))
			. = module.holder.get_cell()

/obj/item/weldingtool/electric/get_fuel()
	return get_available_charge()

/obj/item/weldingtool/electric/proc/get_available_charge()
	var/obj/item/cell/cell = get_cell()
	return cell ? cell.charge : 0

/obj/item/weldingtool/electric/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(istype(W,/obj/item/stack/material/rods) || istype(W, /obj/item/welder_tank))
		return ..()
	if(isScrewdriver(W))
		if(cell)
			cell.dropInto(get_turf(src))
			user.put_in_hands(cell)
			to_chat(user, SPAN_NOTICE("You pop \the [cell] out of \the [src]."))
			welding = FALSE
			cell = null
			update_icon()
		else
			to_chat(user, SPAN_WARNING("\The [src] has no cell installed."))
		return TRUE
	if(istype(W, /obj/item/cell))
		if(cell)
			to_chat(user, SPAN_WARNING("\The [src] already has a cell installed."))
		else if(user.unEquip(W))
			cell = W
			cell.forceMove(src)
			to_chat(user, SPAN_NOTICE("You slot \the [cell] into \the [src]."))
			update_icon()
		return TRUE
	return ..()

/obj/item/weldingtool/electric/burn_fuel(amount)
	spend_charge(amount * fuel_cost_multiplier)
	var/turf/T = get_turf(src)
	if(T)
		T.hotspot_expose(700, 5)

/obj/item/weldingtool/electric/on_update_icon()
	underlays.Cut()
	if(welding)
		icon_state = "welder_arc1"
		set_light(0.6, 0.5, 2.5, l_color = COLOR_LIGHT_CYAN)
	else
		icon_state = "welder_arc"
		set_light(0)
	if(cell)
		underlays += image(icon = icon, icon_state = "[initial(icon_state)]_cell")
	item_state = welding ? "welder1" : "welder"
	var/mob/M = loc
	if(istype(M))
		M.update_inv_l_hand()
		M.update_inv_r_hand()

/obj/item/weldingtool/electric/proc/spend_charge(amount)
	var/obj/item/cell/cell = get_cell()
	if(cell)
		cell.use(amount * CELLRATE)
