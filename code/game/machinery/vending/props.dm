/obj/machinery/vending/props
	name = "prop dispenser"
	desc = "All the props an actor could need. Probably."
	icon_state = "theater"
	icon_vend = "theater-vend"
	icon_deny = "theater-deny"
	products = list(
		/obj/structure/flora/pottedplant = 2,
		/obj/item/device/flashlight/lamp = 2,
		/obj/item/device/flashlight/lamp/green = 2,
		/obj/item/glass_jar = 1,
		/obj/item/nullrod = 1,
		/obj/item/toy/cultsword = 4,
		/obj/item/toy/katana = 2
	)


/obj/machinery/vending/props/on_update_icon()
	..()
	if (is_powered())
		AddOverlays(image(icon, "[initial(icon_state)]-overlay"))
