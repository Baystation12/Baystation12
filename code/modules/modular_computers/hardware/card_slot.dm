/datum/computer_hardware/card_slot
	name = "RFID Card Slot"
	desc = "Slot that allows this computer to write data on RFID cards. Necessary for some programs to run properly."
	power_usage = 10 //W
	critical = 0

	var/obj/item/weapon/card/id/stored_card = null