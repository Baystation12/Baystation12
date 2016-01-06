
// Available as custom loadout item, this is literally the worst possible cheap tablet
/obj/item/modular_computer/tablet/preset/custom_loadout/cheap/New()
	. = ..()
	desc = "A low-end tablet often seen among low ranked station personnel"
	battery_module = new/obj/item/weapon/computer_hardware/battery_module/nano(src)
	hard_drive = new/obj/item/weapon/computer_hardware/hard_drive/micro(src)
	network_card = new/obj/item/weapon/computer_hardware/network_card(src)

// Alternative version, an average one, for higher ranked positions mostly
/obj/item/modular_computer/tablet/preset/custom_loadout/advanced/New()
	. = ..()
	battery_module = new/obj/item/weapon/computer_hardware/battery_module(src)
	hard_drive = new/obj/item/weapon/computer_hardware/hard_drive/small(src)
	network_card = new/obj/item/weapon/computer_hardware/network_card(src)
	nano_printer = new/obj/item/weapon/computer_hardware/nano_printer(src)
	card_slot = new/obj/item/weapon/computer_hardware/card_slot(src)