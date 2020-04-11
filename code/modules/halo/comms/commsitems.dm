


/* OBSOLETE */

/obj/item/device/mobilecomms/commsbackpack
	name = "obsolete communications backpack"
	desc = "A reinforced backpack filled with an array of wires and communication equipment. No longer works with newer radio equipment."
	icon = 'code/modules/halo/clothing/marine_items.dmi'
	icon_state = "commsback"
	item_state = "commsback"
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK
	var/list/recieving_frequencies = list(/*CIV_NAME*/)
	var/active = 0

	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		)
	item_state_slots = list(
		slot_l_hand_str = "commsback_l",
		slot_r_hand_str = "commsback_r",
		)

/obj/item/device/mobilecomms/commsbackpack/unsc
	desc = "A reinforced backpack filled with an array of wires and communication equipment. The insignia of the UNSC is stitched into the back. No longer works with newer radio equipment."

/obj/item/device/mobilecomms/commsbackpack/innie
	desc = "A reinforced backpack filled with an array of wires and communication equipment. This one appears to have been tampered with. No longer works with newer radio equipment."


/obj/item/device/mobilecomms/commsbackpack/unsc/permanant
	active = 1

/obj/item/device/mobilecomms/commsbackpack/innie/permanant
	active = 1

/obj/item/device/mobilecomms/commsbackpack/sec/permanent
	active = 1

/obj/item/device/mobilecomms/commsbackpack/covenant
	name = "hyperwave communicator"
	desc = "A machine that handles the transmission of covenant hyperwave channels. No longer works with newer radio equipment."
	active = 1
