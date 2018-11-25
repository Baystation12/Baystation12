
/obj/item/device/mobilecomms/commsbackpack/covenant
	name = "hyperwave communicator"
	desc = "A machine that handles the transmission of covenant hyperwave channels"
	icon = null
	anchored = 1
	recieving_frequencies = list("Battlenet")
	active = 1

/obj/item/device/mobilecomms/commsbackpack/covenant/set_active()
	return

/obj/item/device/radio/headset/covenant
	name = "Battlenet Communication Transmitter"
	desc = "An updated, modular intercom that fits over the head. Takes encryption keys."
	icon_state = "headset"
	item_state = "headset"

	ks1type = /obj/item/device/encryptionkey/covenant

/obj/item/device/radio/headset/covenant/attackby()
	return

/obj/item/device/encryptionkey/covenant
	icon_state = null //This should never be found outside a headset
	channels = list("Battlenet" = 1)
