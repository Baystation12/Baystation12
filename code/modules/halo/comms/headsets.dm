


/* CIVILIAN */

//default civilian headset
/obj/item/device/radio/headset
	dongles = list(/obj/item/device/channel_dongle/human_civ)

//colonial police headset
/obj/item/device/radio/headset/police
	name = "colonial police radio headset"
	icon_state = "sec_headset"
	dongles = list(/obj/item/device/channel_dongle/human_civ,\
		/obj/item/device/channel_dongle/gcpd)



/* INNIE */

//insurrectionist headset
/obj/item/device/radio/headset/insurrection
	dongles = list(/obj/item/device/channel_dongle/human_civ,\
		/obj/item/device/channel_dongle/innie)

//URF Commando headset
/obj/item/device/radio/headset/commando
	dongles = list(/obj/item/device/channel_dongle/human_civ,\
		/obj/item/device/channel_dongle/innie,\
		/obj/item/device/channel_dongle/urfc)



/* UNSC */

//unsc crew headset
/obj/item/device/radio/headset/unsc
	name = "UNSC radio headset"
	icon_state = "med_headset"
	dongles = list(/obj/item/device/channel_dongle/human_civ,\
		/obj/item/device/channel_dongle/squadcom)

//unsc pilot headset
/obj/item/device/radio/headset/unsc/pilot
	name = "UNSC pilot radio headset"
	icon_state = "cargo_headset"
	dongles = list(/obj/item/device/channel_dongle/human_civ,\
		/obj/item/device/channel_dongle/squadcom,\
		/obj/item/device/channel_dongle/shipcom)

//unsc marine headset
/obj/item/device/radio/headset/unsc/marine
	name = "UNSC marine radio headset"
	icon_state = "cent_headset"
	dongles = list(/obj/item/device/channel_dongle/human_civ,\
		/obj/item/device/channel_dongle/squadcom,\
		/obj/item/device/channel_dongle/marines)

//unsc odst headset
/obj/item/device/radio/headset/unsc/odst
	name = "ODST radio headset"
	icon_state = "cent_headset"
	dongles = list(/obj/item/device/channel_dongle/human_civ,\
		/obj/item/device/channel_dongle/squadcom,\
		/obj/item/device/channel_dongle/marines,\
		/obj/item/device/channel_dongle/odst)

//unsc spartan headset
/obj/item/device/radio/headset/unsc/spartan
	name = "Spartan II radio headset"
	icon_state = "mine_headset"
	dongles = list(/obj/item/device/channel_dongle/human_civ,\
		/obj/item/device/channel_dongle/squadcom,\
		/obj/item/device/channel_dongle/marines,\
		/obj/item/device/channel_dongle/odst,\
		/obj/item/device/channel_dongle/oni,\
		/obj/item/device/channel_dongle/spartan)

//unsc officer headset
/obj/item/device/radio/headset/unsc/officer
	name = "UNSC officer radio headset"
	icon_state = "med_headset"
	dongles = list(/obj/item/device/channel_dongle/human_civ,\
		/obj/item/device/channel_dongle/squadcom,\
		/obj/item/device/channel_dongle/marines,\
		/obj/item/device/channel_dongle/odst,\
		/obj/item/device/channel_dongle/fleetcom)

//unsc senior officer headset
/obj/item/device/radio/headset/unsc/commander
	name = "UNSC commander radio headset"
	icon_state = "nt_headset"
	dongles = list(/obj/item/device/channel_dongle/human_civ,\
		/obj/item/device/channel_dongle/squadcom,\
		/obj/item/device/channel_dongle/marines,\
		/obj/item/device/channel_dongle/odst,\
		/obj/item/device/channel_dongle/fleetcom)

//unsc oni headset
/obj/item/device/radio/headset/unsc/oni
	dongles = list(/obj/item/device/channel_dongle/human_civ,\
		/obj/item/device/channel_dongle/squadcom,\
		/obj/item/device/channel_dongle/marines,\
		/obj/item/device/channel_dongle/odst,\
		/obj/item/device/channel_dongle/oni)



/* COVENANT */

/obj/item/device/radio/headset/covenant
	name = "Battlenet headset"
	icon = 'code/modules/halo/comms/comms.dmi'
	dongles = list(/obj/item/device/channel_dongle/battlenet)

/obj/item/device/radio/headset/covenant/attackby()
	return

/obj/item/device/radio/headset/brute_ramclan
	name = "Ram Clan headset"
	icon = 'code/modules/halo/comms/comms.dmi'
	dongles = list(/obj/item/device/channel_dongle/ramnet)

/obj/item/device/radio/headset/brute_ramclan/attackby()
	return

/obj/item/device/radio/headset/brute_boulderclan
	name = "Boulder Clan headset"
	icon = 'code/modules/halo/comms/comms.dmi'
	dongles = list(/obj/item/device/channel_dongle/bouldernet)

/obj/item/device/radio/headset/brute_boulderclan/attackby()
	return
