/obj/item/device/radio/headset
	name = "radio headset"
	desc = "An updated, modular intercom that fits over the head. Takes encryption keys."
	icon_state = "headset"
	item_state = "headset"
	matter = list(DEFAULT_WALL_MATERIAL = 75)
	subspace_transmission = 1
	canhear_range = 0 // can't hear headsets from very far away

	slot_flags = SLOT_EARS
	var/translate_binary = 0
	var/translate_hive = 0

	//obsolete but left in for backwards compatibility
	var/obj/item/device/encryptionkey/keyslot1 = null
	var/obj/item/device/encryptionkey/keyslot2 = null

	var/ks1type = /obj/item/device/encryptionkey
	var/ks2type = null

/obj/item/device/radio/headset/Destroy()
	qdel(keyslot1)
	qdel(keyslot2)
	keyslot1 = null
	keyslot2 = null
	return ..()

/obj/item/device/radio/headset/MouseDrop(var/obj/over_object)
	var/mob/M = usr
	if((!istype(over_object, /obj/screen)) && (src in M) && CanUseTopic(M))
		return attack_self(M)
	return
