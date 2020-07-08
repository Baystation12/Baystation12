//See code/modules/halo/weapons/unsc_plasma.dm



/* PLASMA CELL */

/obj/item/unsc_plasma_cell
	name = "UNSC plasma cell"
	icon = 'code/modules/halo/machinery/unsc_plasma_charger.dmi'
	icon_state = "plasma_cell0"
	var/icon_state_base = "plasma_cell"
	var/charge = 0
	var/maxcharge = 100

/obj/item/unsc_plasma_cell/full
	icon_state = "plasma_cell1"
	charge = 100

/obj/item/unsc_plasma_cell/emp_act(severity)
	//severity goes 1-3
	var/loss = severity * round(maxcharge / 4)
	use(loss)

/obj/item/unsc_plasma_cell/proc/percent()
	return round(100 * charge/maxcharge)

/obj/item/unsc_plasma_cell/proc/fully_charged()
	return charge >= maxcharge

/obj/item/unsc_plasma_cell/proc/give(var/amount)
	charge += amount
	charge = min(charge, maxcharge)
	if(charge)
		icon_state = "[icon_state_base]1"

/obj/item/unsc_plasma_cell/proc/check_charge(var/amount)
	return (charge >= amount)

/obj/item/unsc_plasma_cell/proc/checked_use(var/amount)
	if(!check_charge(amount))
		return FALSE
	use(amount)
	return TRUE

/obj/item/unsc_plasma_cell/proc/use(var/amount)
	charge -= amount
	charge = max(charge, 0)
	if(!charge)
		icon_state = "[icon_state_base]0"

/obj/item/unsc_plasma_cell/examine(mob/user)
	if(!..(user, 5))
		return
	to_chat(user, "Current charge: [percent()]% ([charge] / [maxcharge])")
