/obj/item/stock_parts/console_screen
	name = "console screen"
	desc = "Used in the construction of computers and other devices with an interactive screen."
	icon_state = "output"
	origin_tech = list(TECH_MATERIAL = 1)
	matter = list(MATERIAL_GLASS = 200)
	base_type = /obj/item/stock_parts/console_screen
	part_flags = PART_FLAG_HAND_REMOVE

/obj/item/stock_parts/console_screen/on_refresh(obj/machinery/machine)
	..()
	machine.set_noscreen(FALSE)

/obj/item/stock_parts/keyboard
	name = "input controller"
	desc = "A standard part required by many machines to recieve user input."
	icon_state = "input"
	origin_tech = list(TECH_MATERIAL = 1)
	matter = list(MATERIAL_PLASTIC = 200)
	base_type = /obj/item/stock_parts/keyboard
	part_flags = PART_FLAG_HAND_REMOVE

/obj/item/stock_parts/keyboard/on_refresh(obj/machinery/machine)
	..()
	machine.set_noinput(FALSE)