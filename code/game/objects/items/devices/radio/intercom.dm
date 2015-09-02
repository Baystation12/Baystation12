// Access check is of the type requires one. These have been carefully selected to avoid allowing the janitor to see channels he shouldn't
var/global/list/default_intercom_channels = list(
	num2text(PUB_FREQ) = list(),
	num2text(AI_FREQ)  = list(access_synth),
	num2text(ERT_FREQ) = list(access_cent_specops),
	num2text(COMM_FREQ)= list(access_heads),
	num2text(ENG_FREQ) = list(access_engine_equip, access_atmospherics),
	num2text(MED_FREQ) = list(access_medical_equip),
	num2text(SEC_FREQ) = list(access_security),
	num2text(SCI_FREQ) = list(access_tox,access_robotics,access_xenobiology),
	num2text(SUP_FREQ) = list(access_cargo),
	num2text(SRV_FREQ) = list(access_janitor, access_hydroponics)
)

/obj/item/device/radio/intercom
	name = "station intercom (General)"
	desc = "Talk through this."
	icon_state = "intercom"
	anchored = 1
	w_class = 4.0
	canhear_range = 2
	flags = CONDUCT | NOBLOODY
	var/number = 0
	var/last_tick //used to delay the powercheck

	var/list/intercom_channels

/obj/item/device/radio/intercom/custom
	name = "station intercom (Custom)"
	broadcasting = 0
	listening = 0

/obj/item/device/radio/intercom/interrogation
	name = "station intercom (Interrogation)"
	frequency  = 1449

/obj/item/device/radio/intercom/private
	name = "station intercom (Private)"
	frequency = AI_FREQ

/obj/item/device/radio/intercom/specops
	name = "\improper Spec Ops intercom"
	frequency = ERT_FREQ

/obj/item/device/radio/intercom/department
	canhear_range = 5
	broadcasting = 0
	listening = 1

/obj/item/device/radio/intercom/department/medbay
	name = "station intercom (Medbay)"
	frequency = MED_I_FREQ

/obj/item/device/radio/intercom/department/security
	name = "station intercom (Security)"
	frequency = SEC_I_FREQ

/obj/item/device/radio/intercom/New()
	..()
	processing_objects += src
	intercom_channels = default_intercom_channels.Copy()

/obj/item/device/radio/intercom/department/medbay/New()
	..()
	intercom_channels = list(
		num2text(PUB_FREQ) = list(),
		num2text(MED_I_FREQ) = list(access_medical_equip)
	)

/obj/item/device/radio/intercom/department/security/New()
	..()
	intercom_channels = list(
		num2text(PUB_FREQ) = list(),
		num2text(SEC_I_FREQ) = list(access_security)
	)

/obj/item/device/radio/intercom/syndicate
	name = "illicit intercom"
	desc = "Talk through this. Evilly"
	frequency = SYND_FREQ
	subspace_transmission = 1
	syndie = 1

/obj/item/device/radio/intercom/syndicate/New()
	..()
	intercom_channels[num2text(SYND_FREQ)] = list(access_syndicate)

/obj/item/device/radio/intercom/proc/has_channel_access(var/mob/user, var/freq)
	if(!user)
		return 0

	if(!(freq in intercom_channels))
		return 0

	var/obj/item/weapon/card/id/I = user.GetIdCard()
	return has_access(list(), intercom_channels[freq], I ? I.GetAccess() : list())

/obj/item/device/radio/intercom/Destroy()
	processing_objects -= src
	..()

/obj/item/device/radio/intercom/attack_ai(mob/user as mob)
	src.add_fingerprint(user)
	spawn (0)
		attack_self(user)

/obj/item/device/radio/intercom/attack_hand(mob/user as mob)
	src.add_fingerprint(user)
	spawn (0)
		attack_self(user)

/obj/item/device/radio/intercom/list_channels(var/mob/user)
	var/dat = ""
	for (var/priv_chan in intercom_channels)
		if(has_channel_access(user, priv_chan))
			dat+="<A href='byond://?src=\ref[src];spec_freq=[priv_chan]'>[get_frequency_name(text2num(priv_chan))]</A><br>"

	if(dat)
		dat = "<br><b>Available Channels</b><br>" + dat
	return dat

/obj/item/device/radio/intercom/receive_range(freq, level)
	if (!on)
		return -1
	if(!(0 in level))
		var/turf/position = get_turf(src)
		if(isnull(position) || !(position.z in level))
			return -1
	if (!src.listening)
		return -1
	if(freq in ANTAG_FREQS)
		if(!(src.syndie))
			return -1//Prevents broadcast of messages over devices lacking the encryption

	return canhear_range

/obj/item/device/radio/intercom/process()
	if(((world.timeofday - last_tick) > 30) || ((world.timeofday - last_tick) < 0))
		last_tick = world.timeofday

		if(!src.loc)
			on = 0
		else
			var/area/A = get_area(src)
			if(!A)
				on = 0
			else
				on = A.powered(EQUIP) // set "on" to the power status

		if(!on)
			icon_state = "intercom-p"
		else
			icon_state = "intercom"

/obj/item/device/radio/intercom/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["spec_freq"])
		var freq = href_list["spec_freq"]
		if(has_channel_access(usr, freq))
			set_frequency(text2num(freq))
		. = 1

	if(.)
		interact(usr)

/obj/item/device/radio/intercom/locked
    var/locked_frequency

/obj/item/device/radio/intercom/locked/set_frequency(var/frequency)
	if(frequency == locked_frequency)
		..(locked_frequency)

/obj/item/device/radio/intercom/locked/list_channels()
	return ""

/obj/item/device/radio/intercom/locked/ai_private
	name = "\improper AI intercom"
	frequency = AI_FREQ

/obj/item/device/radio/intercom/locked/confessional
	name = "confessional intercom"
	frequency = 1480
