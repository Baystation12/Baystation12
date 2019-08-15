/obj/machinery/fabricator/micro
	name = "microlathe"
	desc = "It produces small items using plastic and aluminium. It has a built in shredder that can recycle most items, although any materials it cannot use will be wasted."
	icon = 'icons/obj/machines/fabricators/microlathe.dmi'
	icon_state = "minilathe"
	base_icon_state = "minilathe"
	idle_power_usage = 5
	active_power_usage = 1000
	base_type = /obj/machinery/fabricator/micro
	fabricator_class = FABRICATOR_CLASS_MICRO
	base_storage_capacity = list(
		MATERIAL_ALUMINIUM = 5000,
		MATERIAL_PLASTIC =   5000
	)
