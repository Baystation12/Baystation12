/mob/living/carbon/human/mantid
	var/rig_type
	var/mantid_type

/mob/living/carbon/human/mantid/New(newloc)
	..(newloc, mantid_type)
	if(ispath(rig_type))
		var/obj/item/weapon/rig/rig = new rig_type
		rig.seal_delay = 0
		put_in_hands(rig)
		equip_to_slot_or_del(rig,slot_back)
		if(rig)
			rig.toggle_seals(src,1)
			rig.seal_delay = initial(rig.seal_delay)
			if(rig.air_supply)
				internal = rig.air_supply
				if(internals)
					internals.icon_state = "internal1"
	put_in_hands(new /obj/item/weapon/gun/energy/particle)

/mob/living/carbon/human/mantid/gyne
	rig_type =    /obj/item/weapon/rig/mantid/gyne/equipped
	mantid_type = SPECIES_MANTID_GYNE

/mob/living/carbon/human/mantid/monarch
	rig_type =    /obj/item/weapon/rig/mantid/nabber/equipped
	mantid_type = SPECIES_NABBER_MONARCH

/mob/living/carbon/human/mantid/alate
	rig_type =    /obj/item/weapon/rig/mantid/equipped
	mantid_type = SPECIES_MANTID_ALATE