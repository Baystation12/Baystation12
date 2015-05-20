//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

//All devices that link into the R&D console fall into thise type for easy identification and some shared procs.

/obj/machinery/r_n_d
	name = "R&D Device"
	icon = 'icons/obj/machines/research.dmi'
	density = 1
	anchored = 1
	use_power = 1
	var/busy = 0
	var/obj/machinery/computer/rdconsole/linked_console

/obj/machinery/r_n_d/attack_hand(mob/user as mob)
	return

/obj/machinery/r_n_d/proc/getMaterialType(var/name)
	switch(name)
		if("metal")
			return /obj/item/stack/sheet/metal
		if("glass")
			return /obj/item/stack/sheet/glass
		if("gold")
			return /obj/item/stack/sheet/mineral/gold
		if("silver")
			return /obj/item/stack/sheet/mineral/silver
		if("phoron")
			return /obj/item/stack/sheet/mineral/phoron
		if("uranium")
			return /obj/item/stack/sheet/mineral/uranium
		if("diamond")
			return /obj/item/stack/sheet/mineral/diamond
	return null

/obj/machinery/r_n_d/proc/getMaterialName(var/type)
	switch(type)
		if(/obj/item/stack/sheet/metal)
			return "metal"
		if(/obj/item/stack/sheet/glass)
			return "glass"
		if(/obj/item/stack/sheet/mineral/gold)
			return "gold"
		if(/obj/item/stack/sheet/mineral/silver)
			return "silver"
		if(/obj/item/stack/sheet/mineral/phoron)
			return "phoron"
		if(/obj/item/stack/sheet/mineral/uranium)
			return "uranium"
		if(/obj/item/stack/sheet/mineral/diamond)
			return "diamond"