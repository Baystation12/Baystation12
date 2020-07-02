
/obj/machinery/research
	icon = 'code/modules/halo/crafting/machines/research.dmi'
	anchored = 1
	density = 1
	use_power = 1
	idle_power_usage = 30
	active_power_usage = 5000
	layer = TABLE_LAYER
	flags = OBJ_ANCHORABLE

	var/datum/nano_module/program/experimental_analyzer/controller
	var/automated = FALSE

/obj/machinery/research/proc/attempt_load_item(var/obj/item/I, var/mob/user as mob)
	//override in children

