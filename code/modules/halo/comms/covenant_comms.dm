


/* MOBILE COMMS */

/obj/item/device/mobilecomms/commsbackpack/covenant
	name = "hyperwave communicator"
	desc = "A machine that handles the transmission of covenant hyperwave channels"
	anchored = 1
	recieving_frequencies = list("BattleNet","RamNet","BoulderNet")
	active = 1

/obj/item/device/mobilecomms/commsbackpack/covenant/set_active()
	return



/* ENCRYPTION KEYS */

/obj/item/device/encryptionkey/covenant
	name = "BattleNet radio cyperkey"
	icon_state = "sci_cypherkey"
	channels = list("BattleNet" = 1)

/obj/item/device/encryptionkey/brute_ram
	name = "Ram Clan BattleNet radio cyperkey"
	icon_state = "srv_cypherkey"
	channels = list("RamNet" = 1)

/obj/item/device/encryptionkey/brute_boulder
	name = "Boulder Clan BattleNet radio cyperkey"
	icon_state = "syn_cypherkey"
	channels = list("BoulderNet" = 1)



/* HEADSETS */

/obj/item/device/radio/headset/covenant
	name = "Battlenet headset"
	icon = 'code/modules/halo/comms/comms.dmi'
	ks1type = /obj/item/device/encryptionkey/covenant

/obj/item/device/radio/headset/covenant/attackby()
	return

/obj/item/device/radio/headset/brute_ramclan
	name = "Ram Clan headset"
	icon = 'code/modules/halo/comms/comms.dmi'
	ks1type = /obj/item/device/encryptionkey/brute_ram

/obj/item/device/radio/headset/brute_ramclan/attackby()
	return

/obj/item/device/radio/headset/brute_boulderclan
	name = "Boulder Clan headset"
	icon = 'code/modules/halo/comms/comms.dmi'
	ks1type = /obj/item/device/encryptionkey/brute_boulder

/obj/item/device/radio/headset/brute_boulderclan/attackby()
	return
