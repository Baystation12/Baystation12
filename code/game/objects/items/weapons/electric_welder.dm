/obj/item/weldingtool/electric
	name = "arc welder"
	desc = "A man-portable arc welding tool."
	icon_state = "welder_arc"
	welding_resource = "stored charge"
	tank = null
	waterproof = TRUE
	force = 7
	throwforce = 7
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

/obj/item/weldingtool/electric/afterattack(var/obj/O, var/mob/user, var/proximity)
	if(proximity && istype(O, /obj/structure/reagent_dispensers/fueltank))
		if(!welding)
			to_chat(user, SPAN_WARNING("\The [src] runs on an internal charge and does not need to be refuelled."))
		return
	. = ..()

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

/obj/item/weldingtool/electric/attackby(var/obj/item/W, var/mob/user)
	if(istype(W,/obj/item/stack/material/rods) || istype(W, /obj/item/welder_tank))
		return
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
		return
	else if(istype(W, /obj/item/cell))
		if(cell)
			to_chat(user, SPAN_WARNING("\The [src] already has a cell installed."))
		else if(user.unEquip(W))
			cell = W
			cell.forceMove(src)
			to_chat(user, SPAN_NOTICE("You slot \the [cell] into \the [src]."))
			update_icon()
		return
	. = ..()

/obj/item/weldingtool/electric/burn_fuel(var/amount)
	spend_charge(amount * fuel_cost_multiplier)
	var/turf/T = get_turf(src)
	if(T)
		T.hotspot_expose(700, 5)

/obj/item/weldingtool/electric/on_update_icon()
	underlays.Cut()
	item_state = welding ? "welder1" : "welder"
	if(cell)
		underlays += image(icon = icon, icon_state = "[initial(icon_state)]_cell")

/obj/item/weldingtool/electric/proc/spend_charge(var/amount)
	var/obj/item/cell/cell = get_cell()
	if(cell)
		cell.use(amount * CELLRATE)
