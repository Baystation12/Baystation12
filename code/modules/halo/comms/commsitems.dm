
/obj/item/device/mobilecomms/commsbackpack
	name = "Communications Backpack"
	desc = "A reinforced backpack filled with an array of wires and communication equipment."
	icon = 'code/modules/halo/clothing/marine_items.dmi'
	icon_state = "commsback"
	item_state = "commsback"
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK
	var/list/recieving_frequencies = list(CIV_NAME)
	var/active = 0

	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		)
	item_state_slots = list(
		slot_l_hand_str = "commsback_l",
		slot_r_hand_str = "commsback_r",
		)

/obj/item/device/mobilecomms/commsbackpack/New()
	..()
	telecomms_list += src
	spawn(5)
		for(var/frequency in recieving_frequencies)
			convert_freq_to_numerical(frequency)
			radio_controller.add_object(src,frequency,RADIO_CHAT)

/obj/item/device/mobilecomms/commsbackpack/proc/convert_freq_to_numerical(var/frequency)
	var/freq_numerical = halo_frequencies.frequencies[frequency]
	recieving_frequencies += freq_numerical
	recieving_frequencies -= frequency //Delete the original text value.
	return 1

/obj/item/device/mobilecomms/commsbackpack/proc/set_active(var/set_to)
	active = set_to
	desc = initial(desc) + (active ? " A red light blinks softly." : " It appears to be inactive.")

/obj/item/device/mobilecomms/commsbackpack/equipped()
	set_active(1)

/obj/item/device/mobilecomms/commsbackpack/dropped(var/mob/user)
	set_active(0)
	to_chat(user,"<span class = 'notice'>[src.name] deactivates.</span>")

/obj/item/device/mobilecomms/commsbackpack/receive_signal(var/datum/signal/signal,var/recieve_method, recieve_param)
	if(!active)
		return
	if(signal.source == src)
		return
	if(signal.data["reject"] == 1)
		return
	if(!(signal.frequency in recieving_frequencies))
		return


	//This is mostly stolen from all-in-one code, with a few small changes.
	signal.data["done"] = 1 //Mark as done
	signal.data["compression"] = 0 //remove all corruption from the signal

	var/datum/signal/original = signal.data["original"]
	if(original)
		original.data["done"] = 1
		original.data["reject"] = 1

	var/datum/radio_frequency/connection = signal.data["connection"]

	Broadcast_Message(signal.data["connection"], signal.data["mob"],
					  signal.data["vmask"], signal.data["vmessage"],
					  signal.data["radio"], signal.data["message"],
					  signal.data["name"], signal.data["job"],
					  signal.data["realname"], signal.data["vname"],, signal.data["compression"], list(0), connection.frequency,
					  signal.data["verb"], signal.data["language"])

	signal.data["reject"] = 1 //To stop backpack multisend

/obj/item/device/mobilecomms/commsbackpack/unsc
	desc = "A reinforced backpack filled with an array of wires and communication equipment. The insignia of the UNSC is stitched into the back."
	recieving_frequencies = list(TEAMCOM_NAME,CIV_NAME,EBAND_NAME,FLEETCOM_NAME,SQUADCOM_NAME,SHIPCOM_NAME,ODST_NAME)

/obj/item/device/mobilecomms/commsbackpack/innie
	desc = "A reinforced backpack filled with an array of wires and communication equipment. This one appears to have been tampered with."
	recieving_frequencies = list(CIV_NAME,EBAND_NAME)

/obj/item/device/mobilecomms/commsbackpack/innie/New()
	..()
	spawn(6) //The convert_freq_to_numerical proc runtimes if this isn't here, it attempts to read the innie frequency
		recieving_frequencies.Add(halo_frequencies.innie_freq)

/obj/item/device/mobilecomms/commsbackpack/unsc/permanant
	active = 1

/obj/item/device/mobilecomms/commsbackpack/unsc/permanant/set_active()
	return

/obj/item/device/mobilecomms/commsbackpack/innie/permanant
	active = 1

/obj/item/device/mobilecomms/commsbackpack/innie/permanant/set_active()
	return

/obj/item/device/mobilecomms/commsbackpack/sec
	recieving_frequencies = list(SEC_NAME,EBAND_NAME)

/obj/item/device/mobilecomms/commsbackpack/sec/permanent
	active = 1

/obj/item/device/mobilecomms/commsbackpack/sec/permanent/set_active()
	return

#undef SHIPCOM_NAME
#undef TEAMCOM_NAME
#undef SQUADCOM_NAME
#undef FLEETCOM_NAME
#undef COV_COMMON_NAME
#undef EBAND_NAME
#undef CIV_NAME
#undef SEC_NAME
#undef ODST_NAME
#undef BERTELS_NAME