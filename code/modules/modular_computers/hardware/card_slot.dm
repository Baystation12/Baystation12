/obj/item/weapon/computer_hardware/card_slot
	name = "RFID card slot"
	desc = "Slot that allows this computer to write data on RFID cards. Necessary for some programs to run properly."
	power_usage = 10 //W
	critical = 0
	icon_state = "cardreader"
	hardware_size = 1
	origin_tech = list(TECH_DATA = 2)
	usage_flags = PROGRAM_ALL & ~PROGRAM_PDA
	var/can_write = TRUE
	var/can_broadcast = FALSE

	var/obj/item/weapon/card/id/stored_card = null

/obj/item/weapon/computer_hardware/card_slot/broadcaster // read only
	name = "RFID card broadcaster"
	desc = "Reads and broadcasts the RFID signal of an inserted card."
	can_write = FALSE
	can_broadcast = TRUE

	usage_flags = PROGRAM_PDA

/obj/item/weapon/computer_hardware/card_slot/Destroy()
	if(holder2 && (holder2.card_slot == src))
		holder2.card_slot = null
	if(stored_card)
		stored_card.dropInto(holder2 ? holder2.loc : loc)
	holder2 = null
	return ..()