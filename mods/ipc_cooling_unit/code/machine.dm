/datum/species/machine
	passive_temp_gain = 0  // This should cause IPCs to stabilize at ~80 C in a 20 C environment.(5 is default without organ)


/datum/species/machine/New()
	LAZYINITLIST(has_organ)
	has_organ[BP_COOLING] = /obj/item/organ/internal/cooling_system
	..()

// ROBOT ORGAN PRINTER
/obj/machinery/organ_printer/robot/New()
	LAZYINITLIST(products)
	products[BP_COOLING] = list(/obj/item/organ/internal/cooling_system, 35)
	. = ..()


/mob/living/carbon/human/Stat()
	. = ..()
	if(statpanel("Status"))
		var/obj/item/organ/internal/cell/potato = internal_organs_by_name[BP_CELL]
		var/obj/item/organ/internal/cooling_system/coolant = internal_organs_by_name[BP_COOLING]
		if(potato && potato.cell && src.is_species(SPECIES_IPC))
			stat("Coolant remaining:","[coolant.get_coolant_remaining()]/[coolant.refrigerant_max]")

/obj/item/organ/internal/cell/Process()
	..()
	var/cost = get_power_drain()
	if(!checked_use(cost) && owner.isSynthetic())
		if(owner.species.name == SPECIES_IPC)
			owner.species.passive_temp_gain = 0
	if(owner.species.name == SPECIES_IPC)
		var/obj/item/organ/internal/cooling_system/cooling_organ = owner.internal_organs_by_name[BP_COOLING]
		var/normal_passive_temp_gain = 30
		if(!cooling_organ)
			if(owner.bodytemperature > 950 CELSIUS)
				owner.species.passive_temp_gain = 0
			else
				owner.species.passive_temp_gain = normal_passive_temp_gain
		else
			owner.species.passive_temp_gain = cooling_organ.get_tempgain()
