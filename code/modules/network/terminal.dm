var/terminal_count = 0

/obj/machinery/terminal
	name = "network terminal"
	desc = "A state of the art network terminal."
	icon = 'icons/obj/computer.dmi'
	icon_state = "comm_monitor0"

	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 300
	active_power_usage = 300

	// Network helpers.
	var/domain = "STATION"
	var/connection_priority = 1
	var/datum/data_network/network

	// Component helpers
	var/obj/item/weapon/stock_parts/hdd/hard_drive
	var/obj/item/weapon/stock_parts/cpu/processor
	var/obj/item/weapon/stock_parts/ram/memory
	var/obj/item/weapon/stock_parts/nic/network_interface
	var/obj/item/weapon/stock_parts/mobo/motherboard

	var/list/default_parts = list(
		/obj/item/weapon/stock_parts/hdd,
		/obj/item/weapon/stock_parts/cpu,
		/obj/item/weapon/stock_parts/ram,
		/obj/item/weapon/stock_parts/nic/wifi,
		/obj/item/weapon/stock_parts/mobo
		)

/obj/machinery/terminal/proc/create_default_parts()
	component_parts = list()
	for(var/component_type in default_parts)
		component_parts += new component_type(src)
	RefreshParts()

/obj/machinery/terminal/New()
	..()
	create_default_parts()
	terminal_count++
	name = "[initial(name)] #[terminal_count]"

/obj/machinery/terminal/RefreshParts()
	// Helpers.
	hard_drive = locate() in contents
	processor = locate() in contents
	memory = locate() in contents
	network_interface = locate() in contents
	motherboard = locate() in contents
	..()

/obj/machinery/terminal/node
	name = "network node"
	connection_priority = 100 // Nodes are routers, they should always be preferred.
	default_parts = list(
		/obj/item/weapon/stock_parts/hdd,
		/obj/item/weapon/stock_parts/cpu,
		/obj/item/weapon/stock_parts/ram,
		/obj/item/weapon/stock_parts/nic/wifi/node,
		/obj/item/weapon/stock_parts/mobo
		)
