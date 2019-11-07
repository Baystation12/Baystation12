/obj/machinery/fabricator/micro
	name = "microlathe"
	desc = "It produces small items from common resources."
	icon = 'icons/obj/machines/fabricators/microlathe.dmi'
	icon_state = "minilathe"
	base_icon_state = "minilathe"
	idle_power_usage = 5
	active_power_usage = 1000
	base_type = /obj/machinery/fabricator/micro
	fabricator_class = FABRICATOR_CLASS_MICRO
	base_storage_capacity = list(
		/material/aluminium = 5000,
		/material/plastic =   5000
	)
