
/obj/item/device/channel_dongle
	name = "blank channel dongle"
	desc = "An channel dongle for a radio headset. Contains all you need to access a channel."
	icon = 'icons/obj/radio.dmi'
	icon_state = "cypherkey"
	item_state = ""
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	var/channel_preset
	var/datum/channel_cipher/cipher
	var/listening = 1

/obj/item/device/channel_dongle/New(var/loc, var/new_channel)
	if(new_channel)
		channel_preset = new_channel
	. = ..()

/obj/item/device/channel_dongle/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/item/device/channel_dongle/LateInitialize()
	. = ..()

	cipher = GLOB.channels_ciphers[channel_preset]
	if(istype(cipher))
		name = "[cipher.channel_name] channel dongle"
	else
		name = "invalid channel dongle"
		desc = "An channel dongle for a radio headset. Does not appear to have a valid channel cipher."
