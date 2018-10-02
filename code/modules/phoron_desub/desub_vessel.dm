/*  //////// PHORON FORMATION VESSEL ////////
	Uses phoron gas to grow a supermatter shard
*/

/obj/machinery/phoron_desublimer/vessel
	name = "Formation Vessel"
	desc = "Grows supermatter shards by seeding them with phoron."
	icon_state = "processorempty"
	var/obj/machinery/computer/teleporter/com
	var/obj/item/weapon/tank/loaded_tank
	var/obj/item/weapon/material/shard/supermatter/loaded_shard
	var/datum/gas_mixture/air_contents

	active_power_usage = 10000

/obj/machinery/phoron_desublimer/vessel/Initialize()
	. = ..()

	air_contents = new
	air_contents.volume = 84

	component_parts = list()
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/capacitor(src)
	component_parts += new /obj/item/weapon/stock_parts/capacitor(src)
	component_parts += new /obj/item/weapon/stock_parts/capacitor(src)

/obj/machinery/phoron_desublimer/vessel/Destroy()
	com = null
	QDEL_NULL(loaded_tank)
	if(loaded_shard)
		loaded_shard.dropInto(loc)
		loaded_shard = null
	QDEL_NULL(air_contents)
	for(var/obj/machinery/computer/phoron_desublimer_control/DC in get_area(src))
		if(DC.vessel)
			DC.vessel = null
			DC.find_parts()
	. = ..()

/obj/machinery/phoron_desublimer/vessel/on_update_icon()
	if(!loaded_tank)
		icon_state = "processorempty"
	else
		icon_state = "processorfull"

/obj/machinery/phoron_desublimer/vessel/attackby(var/obj/item/weapon/B as obj, var/mob/user as mob)
	if(isrobot(user))
		return
	else if(istype(B, /obj/item/weapon/material/shard/supermatter))
		if(!loaded_shard)
			if(!user.unequip_item(src))
				return
			loaded_shard = B
			to_chat(user, "You put [B] into the machine.")
		else
			to_chat(user, "There is already a shard in the machine.")
		return
	else if(istype(B, /obj/item/weapon/tank))
		if(!loaded_tank)
			if(!user.unequip_item(src))
				return
			loaded_tank = B
			to_chat(user, "You put [B] into the machine.")
		else
			to_chat(user, "There is already a tank in the machine.")
		return

	return ..()

/obj/machinery/phoron_desublimer/vessel/proc/filled()
	return (air_contents.total_moles > 1)

/obj/machinery/phoron_desublimer/vessel/proc/fill()
	if(!loaded_tank)
		src.visible_message("\icon[src] <b>[src]</b> buzzes, \"No tank loaded!\"")
		return
	if(loaded_tank.air_contents.total_moles < 1)
		src.visible_message("\icon[src] <b>[src]</b> buzzes, \"Loaded tank is empty!\"")
		return

	air_contents.merge(loaded_tank.air_contents.remove(loaded_tank.air_contents.total_moles))
	flick("processorfill", src)
	sleep(12)
	update_icon()

/obj/machinery/phoron_desublimer/vessel/proc/crystalize()
	if(active)
		return
	if(!loaded_shard)
		src.visible_message("\icon[src] <b>[src]</b> buzzes, \"No gas present in system!\"")
		return
	if(!filled())
		src.visible_message("\icon[src] <b>[src]</b> buzzes, \"Need a supermatter shard to feed!\"")
		return
	if(!report_ready())
		return

	src.visible_message("\icon[src] <b>[src]</b> beeps, \"Feeding crystal.. Do not remove.\"")
	active = 1

	loaded_shard.feed(air_contents.remove(air_contents.total_moles))

	flick("processorcrystalize", src)
	sleep(22)
	update_icon()

	if(!loaded_shard) //If our shard turned into something else, aka full crystal
		explosion(get_turf(src), 0, 0, 5, 10, 1)
		qdel_self()

	src.visible_message("\icon[src] <b>[src]</b> pings, \"Crystal successfully fed.\"")

	active = 0

/obj/machinery/phoron_desublimer/vessel/proc/eject_shard()
	if(!loaded_shard)
		return
	if(active)
		src.visible_message("\icon[src] <b>[src]</b> buzzes, \"Crystal feeding in progress, ejection failed.\"")
		return
	loaded_shard.dropInto(loc)
	loaded_shard = null

/obj/machinery/phoron_desublimer/vessel/proc/eject_tank()
	if(!loaded_tank)
		return

	loaded_tank.dropInto(loc)
	loaded_tank = null

/obj/machinery/phoron_desublimer/vessel/report_ready()
	ready = 1

	..()

	return ready