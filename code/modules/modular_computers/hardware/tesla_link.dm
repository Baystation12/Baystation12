/obj/item/weapon/computer_hardware/tesla_link
	name = "tesla link"
	desc = "An advanced tesla link that wirelessly recharges connected device from nearby area power controller."
	critical = 0
	enabled = 1
	icon_state = "teslalink"
	hardware_size = 1
	origin_tech = list(TECH_DATA = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)
	var/passive_charging_rate = 250			// W

/obj/item/weapon/computer_hardware/tesla_link/Destroy()
	if(holder2 && (holder2.tesla_link == src))
		holder2.tesla_link = null
	return ..()