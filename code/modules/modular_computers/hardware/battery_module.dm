/**
  * This device is wrapper for actual power cell. I have decided to not use power
  * cells directly as even low-end cells available on station have tremendeous capacity
  * in comparsion. Higher tier cells would provide your device with nearly infinite
  * battery life, which is something i want to avoid.
  */
/obj/item/stock_parts/computer/battery_module
	name = "standard battery"
	desc = "A standard power cell, commonly seen in high-end portable microcomputers or low-end laptops. It's rating is 120 Wh."
	icon_state = "battery_normal"
	critical = TRUE
	malfunction_probability = 1
	origin_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 1)
	var/battery_rating = 120
	var/obj/item/cell/battery = null

/obj/item/stock_parts/computer/battery_module/advanced
	name = "advanced battery"
	desc = "An advanced power cell, often used in most laptops. It is too large to be fitted into smaller devices. It's rating is 650 Wh."
	icon_state = "battery_advanced"
	origin_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 2)
	hardware_size = 2
	battery_rating = 650

/obj/item/stock_parts/computer/battery_module/super
	name = "super battery"
	desc = "A very advanced power cell, often used in high-end devices, or as uninterruptable power supply for important consoles or servers. It's rating is 820 Wh."
	icon_state = "battery_super"
	origin_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 3)
	hardware_size = 2
	battery_rating = 820

/obj/item/stock_parts/computer/battery_module/ultra
	name = "ultra battery"
	desc = "A very advanced large power cell. It's often used as uninterruptable power supply for critical consoles or servers. It's rating is 1100 Wh."
	icon_state = "battery_ultra"
	origin_tech = list(TECH_POWER = 5, TECH_ENGINEERING = 4)
	hardware_size = 3
	battery_rating = 1100

/obj/item/stock_parts/computer/battery_module/micro
	name = "micro battery"
	desc = "A small power cell, commonly seen in most portable microcomputers. It's rating is 80 Wh."
	icon_state = "battery_micro"
	origin_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 2)
	battery_rating = 80

/obj/item/stock_parts/computer/battery_module/nano
	name = "nano battery"
	desc = "A tiny power cell, commonly seen in low-end portable microcomputers. It's rating is 60 Wh."
	icon_state = "battery_nano"
	origin_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 1)
	battery_rating = 60

// This is not intended to be obtainable in-game. Intended for adminbus and debugging purposes.
/obj/item/stock_parts/computer/battery_module/lambda
	name = "lambda coil"
	desc = "A very complex power source compatible with various computers. It is capable of providing power for nearly unlimited duration."
	icon_state = "battery_lambda"
	hardware_size = 1
	battery_rating = 9000

/obj/item/stock_parts/computer/battery_module/lambda/Initialize()
	. = ..()
	battery = new/obj/item/cell/infinite(src)

/obj/item/stock_parts/computer/battery_module/diagnostics()
	. = ..()
	. += "Internal battery charge: [battery.charge]/[battery.maxcharge] CU"

/obj/item/stock_parts/computer/battery_module/Initialize()
	. = ..()
	battery = new/obj/item/cell/standard(src)
	battery.maxcharge = battery_rating
	battery.charge = 0

/obj/item/stock_parts/computer/battery_module/Destroy()
	QDEL_NULL(battery)
	return ..()

/obj/item/stock_parts/computer/battery_module/proc/charge_to_full()
	if(battery)
		battery.charge = battery.maxcharge

/obj/item/stock_parts/computer/battery_module/get_cell()
	return battery
