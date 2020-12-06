/obj/item/weapon/weldingtool/electric
	name = "arc welder"
	desc = "A man-portable arc welding tool."
	icon_state = "welder_arc"
	welding_resource = "stored charge"
	tank = null
	waterproof = TRUE
	var/obj/item/weapon/cell/cell = /obj/item/weapon/cell/high
	var/fuel_cost_multiplier = 10

/obj/item/weapon/weldingtool/electric/Initialize()
	if(ispath(cell))
		cell = new cell(src)
	. = ..()

/obj/item/weapon/weldingtool/electric/afterattack(var/obj/O, var/mob/user, var/proximity)
	if(proximity && istype(O, /obj/structure/reagent_dispensers/fueltank))
		if(!welding)
			to_chat(user, SPAN_WARNING("\The [src] runs on an internal charge and does not need to be refuelled."))
		return
	. = ..()

/obj/item/weapon/weldingtool/electric/get_cell()
	if(cell)
		. = cell
	else if(istype(loc, /obj/item/rig_module))
		var/obj/item/rig_module/module = loc
		if(istype(module.holder))
			. = module.holder.get_cell()

/obj/item/weapon/weldingtool/electric/get_fuel()
	return get_available_charge()

/obj/item/weapon/weldingtool/electric/proc/get_available_charge()
	var/obj/item/weapon/cell/cell = get_cell()
	return cell ? cell.charge : 0

/obj/item/weapon/weldingtool/electric/attackby(var/obj/item/W, var/mob/user)
	if(istype(W,/obj/item/stack/material/rods) || istype(W, /obj/item/weapon/welder_tank))
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
	else if(istype(W, /obj/item/weapon/cell))
		if(cell)
			to_chat(user, SPAN_WARNING("\The [src] already has a cell installed."))
		else if(user.unEquip(W))
			cell = W
			cell.forceMove(src)
			to_chat(user, SPAN_NOTICE("You slot \the [cell] into \the [src]."))
			update_icon()
		return
	. = ..()

/obj/item/weapon/weldingtool/electric/show_fuel(var/mob/user)
	to_chat(user, SPAN_NOTICE("It can use [get_fuel()]W of charge."))

/obj/item/weapon/weldingtool/electric/burn_fuel(var/amount)
	spend_charge(amount * fuel_cost_multiplier)
	var/turf/T = get_turf(src)
	if(T) 
		T.hotspot_expose(700, 5)

/obj/item/weapon/weldingtool/electric/update_tank_underlay()
	underlays.Cut()
	if(cell)
		underlays += image(icon = icon, icon_state = "[initial(icon_state)]_cell")

/obj/item/weapon/weldingtool/electric/proc/spend_charge(var/amount)
	var/obj/item/weapon/cell/cell = get_cell()
	if(cell)
		cell.use(amount * CELLRATE)
