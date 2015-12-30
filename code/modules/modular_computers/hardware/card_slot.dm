/obj/item/weapon/computer_hardware/card_slot
	name = "RFID card slot"
	desc = "Slot that allows this computer to write data on RFID cards. Necessary for some programs to run properly."
	power_usage = 10 //W
	critical = 0
	icon_state = "cardreader"
	hardware_size = 1

	var/obj/item/weapon/card/id/stored_card = null

/obj/item/weapon/computer_hardware/card_slot/Destroy()
	if(holder2 && (holder2.card_slot == src))
		holder2.card_slot = null
	stored_card.loc = get_turf(holder2)
	holder2 = null
	..()