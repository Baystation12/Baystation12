/datum/computer_hardware/card_slot
	name = "RFID Card Slot"
	desc = "Slot that allows this computer to write data on RFID cards. Necessary for some programs to run properly."
	power_usage = 10 //W
	critical = 0

	var/obj/item/weapon/card/id/stored_card = null

/datum/computer_hardware/card_slot/Destroy()
	if(holder && (holder.card_slot == src))
		holder.card_slot = null
	if(holder2 && (holder2.card_slot == src))
		holder2.card_slot = null
	stored_card.loc = holder ? holder.loc : holder2.loc
	..()