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
			return /obj/item/stack/material/steel
		if("glass")
			return /obj/item/stack/material/glass
		if("gold")
			return /obj/item/stack/material/gold
		if("silver")
			return /obj/item/stack/material/silver
		if("phoron")
			return /obj/item/stack/material/phoron
		if("uranium")
			return /obj/item/stack/material/uranium
		if("diamond")
			return /obj/item/stack/material/diamond
	return null

/obj/machinery/r_n_d/proc/getMaterialName(var/type)
	switch(type)
		if(/obj/item/stack/material/steel)
			return "metal"
		if(/obj/item/stack/material/glass)
			return "glass"
		if(/obj/item/stack/material/gold)
			return "gold"
		if(/obj/item/stack/material/silver)
			return "silver"
		if(/obj/item/stack/material/phoron)
			return "phoron"
		if(/obj/item/stack/material/uranium)
			return "uranium"
		if(/obj/item/stack/material/diamond)
			return "diamond"