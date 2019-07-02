/obj/item/weapon/stock_parts/console_screen
	name = "console screen"
	desc = "Used in the construction of computers and other devices with an interactive screen."
	icon_state = "screen"
	origin_tech = list(TECH_MATERIAL = 1)
	matter = list(MATERIAL_GLASS = 200)
	base_type = /obj/item/weapon/stock_parts/console_screen

/obj/item/weapon/stock_parts/console_screen/on_refresh(obj/machinery/machine)
	..()
	machine.set_noscreen(FALSE)

/obj/item/weapon/stock_parts/keyboard
	name = "keyboard"
	desc = "A standard part required by many machines to recieve user input."
	icon_state = "med_key_off"
	origin_tech = list(TECH_MATERIAL = 1)
	matter = list(MATERIAL_PLASTIC = 200)
	base_type = /obj/item/weapon/stock_parts/keyboard

/obj/item/weapon/stock_parts/keyboard/on_refresh(obj/machinery/machine)
	..()
	machine.set_noinput(FALSE)