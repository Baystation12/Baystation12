/obj/machinery/scrap/stacking_machine
	name = "scrap stacking machine"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "stacker"
	density = TRUE
	anchored = TRUE
	use_power = 0
	var/obj/machinery/mineral/input = null
	var/obj/machinery/mineral/output = null
	var/list/stack_storage[0]
	var/list/stack_paths[0]
	var/scrap_amount = 0
	var/stack_amt = 20 // Amount to stack before releassing

/obj/machinery/scrap/stacking_machine/Bumped(atom/movable/AM)
	if(stat & (MACHINE_BROKEN_GENERIC|MACHINE_STAT_NOPOWER))
		return
	if(istype(AM, /mob/living))
		return
	if(istype(AM, /obj/item/stack/material/refined_scrap))
		var/obj/item/stack/material/refined_scrap/S = AM
		scrap_amount += S.get_amount()
		qdel(S)
		if(scrap_amount >= stack_amt)
			new /obj/item/stack/material/refined_scrap(loc, stack_amt)
			scrap_amount -= stack_amt
	else
		AM.forceMove(loc)

/obj/machinery/scrap/stacking_machine/physical_attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(scrap_amount < 1)
		return 1
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	visible_message("<span class='notice'>\The [src] was forced to release everything inside.</span>")
	new /obj/item/stack/material/refined_scrap(loc, scrap_amount)
	scrap_amount = 0
