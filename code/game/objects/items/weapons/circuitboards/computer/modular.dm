/obj/item/weapon/stock_parts/circuitboard/modular_computer
	name = "general-purpose computer motherboard"
	build_path = /obj/machinery/computer/modular
	req_components = list(
		/obj/item/weapon/stock_parts/computer/processor_unit = 1
	)
	additional_spawn_components = list(
		/obj/item/weapon/stock_parts/computer/network_card/wired = 1,
		/obj/item/weapon/stock_parts/computer/hard_drive/super = 1,
		/obj/item/weapon/stock_parts/console_screen = 1,
		/obj/item/weapon/stock_parts/keyboard = 1,
		/obj/item/weapon/stock_parts/power/apc/buildable = 1,
		/obj/item/weapon/stock_parts/computer/nano_printer = 1,
		/obj/item/weapon/stock_parts/computer/scanner/paper = 1
	)
	var/emagged

/obj/item/weapon/stock_parts/circuitboard/modular_computer/emag_act(var/remaining_charges, var/mob/user)
	if(emagged)
		return ..()
	else
		emagged = TRUE
		to_chat(user, "<span class='warning'>You disable the factory safeties on \the [src].</span>")
