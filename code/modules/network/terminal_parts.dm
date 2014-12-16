// Computer parts.
/obj/item/weapon/stock_parts/hdd
	name = "hard drive"
	desc = "A clunky solid state hard drive. What is this, 2198?"
	icon_state = "matter_bin"
	origin_tech = "materials=1"
	matter = list(DEFAULT_WALL_MATERIAL = 80)

/obj/item/weapon/stock_parts/hdd/server
	name = "advanced hard drive"
	desc = "A powerful, modern quantum-state hard storage medium."

/obj/item/weapon/stock_parts/cpu
	name = "central processor unit"
	desc = "The 'brain' of a computer system."
	icon_state = "matter_bin"
	origin_tech = "materials=1"
	matter = list(DEFAULT_WALL_MATERIAL = 80)

/obj/item/weapon/stock_parts/ram
	name = "RAM stick"
	desc = "Volatile memory for a computer system."
	icon_state = "matter_bin"
	origin_tech = "materials=1"
	matter = list(DEFAULT_WALL_MATERIAL = 80)

/obj/item/weapon/stock_parts/nic
	name = "network interface card"
	desc = "A device used to connect a terminal to the station network."
	icon_state = "matter_bin"
	origin_tech = "materials=1"
	matter = list(DEFAULT_WALL_MATERIAL = 80)

	var/max_connection_count = 1
	var/list/connections = list()
	var/adapter_name = "Local Network Adapter"
	var/wireless_range = 0
	var/address

/obj/item/weapon/stock_parts/nic/proc/can_add_connection()
	return connections.len < max_connection_count

/obj/item/weapon/stock_parts/nic/wifi
	name = "wireless interface card"
	adapter_name = "Wireless Network Adapter"
	wireless_range = 10

/obj/item/weapon/stock_parts/nic/wifi/node
	max_connection_count = 64 // Testing

/obj/item/weapon/stock_parts/mobo
	name = "motherboard"
	desc = "A computer motherboard. Determines number of external memory slots and compatibility with advanced components."
	icon_state = "matter_bin"
	origin_tech = "materials=1"
	matter = list(DEFAULT_WALL_MATERIAL = 80)