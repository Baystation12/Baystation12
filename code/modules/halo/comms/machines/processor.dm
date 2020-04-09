
/obj/machinery/overmap_comms/processor
	name = "cryptographic processor"
	icon_state = "processor"
	icon_state_active = "processor"
	icon_state_inactive = "processor_off"
	desc = "An advanced machine for encrypting and decrypting radio signals, with the right cipher."
	var/list/frequencies_ciphers = list()

/obj/machinery/overmap_comms/processor/proc/can_decrypt(var/datum/radio_cipher/cipher, var/freq_text)
	if(!active)
		return 0

	if(frequencies_ciphers[freq_text] == cipher)
		return 1

	return 0



//PRESETS

/obj/machinery/overmap_comms/processor/unsc

/obj/machinery/overmap_comms/processor/unsc/Initialize()
	. = ..()

