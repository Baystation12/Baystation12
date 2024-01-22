/obj/machinery/suit_cycler/engineering
	name = "engineering suit cycler"
	model_text = "Engineering"
	req_access = list(access_construction)
	 // [SIERRA-EDIT] - HARDSUITS - Костюмы со спрайтами Инфинити
	 // available_modifications = list(/singleton/item_modifier/space_suit/engineering, /singleton/item_modifier/space_suit/atmos) // SIERRA-EDIT - ORIGINAL
	available_modifications = list(/singleton/item_modifier/space_suit/sierra/engineering, /singleton/item_modifier/space_suit/sierra/atmos)
	 // [/SIERRA-EDIT]
	species = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_UNATHI)

/obj/machinery/suit_cycler/mining
	name = "mining suit cycler"
	model_text = "Mining"
	req_access = list(access_mining)
	available_modifications = list(/singleton/item_modifier/space_suit/mining)
	species = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI)

/obj/machinery/suit_cycler/salvage
	name = "salvage suit cycler"
	model_text = "Salvage"
	available_modifications = list(/singleton/item_modifier/space_suit/salvage)
	species = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI)

/obj/machinery/suit_cycler/science
	name = "excavation suit cycler"
	model_text = "Excavation"
	req_access = list(access_xenoarch)
	available_modifications = list(/singleton/item_modifier/space_suit/science)
	species = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI)

/obj/machinery/suit_cycler/security
	name = "security suit cycler"
	model_text = "Security"
	req_access = list(access_security)
	available_modifications = list(/singleton/item_modifier/space_suit/security)
	 // [SIERRA-EDIT] - HARDSUITS - Костюмы со спрайтами Инфинити
	 // available_modifications = list(/singleton/item_modifier/space_suit/security) // SIERRA-EDIT - ORIGINAL
	available_modifications = list(/singleton/item_modifier/space_suit/sierra/security, /singleton/item_modifier/space_suit/sierra/security/alt)
	 // [/SIERRA-EDIT]
	species = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI)

/obj/machinery/suit_cycler/security/alt
	available_modifications = list(/singleton/item_modifier/space_suit/security/alt)

/obj/machinery/suit_cycler/medical
	name = "medical suit cycler"
	model_text = "Medical"
	req_access = list(access_medical)
	available_modifications = list(/singleton/item_modifier/space_suit/medical)
	species = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI)

/obj/machinery/suit_cycler/syndicate
	name = "nonstandard suit cycler"
	model_text = "Nonstandard"
	req_access = list(access_syndicate)
	available_modifications = list(/singleton/item_modifier/space_suit/mercenary)
	species = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI, SPECIES_VOX)
	can_repair = 1

/obj/machinery/suit_cycler/pilot
	name = "pilot suit cycler"
	model_text = "Pilot"
	req_access = list(access_mining_office)
	 // [SIERRA-EDIT] - HARDSUITS - Костюмы со спрайтами Инфинити
	 // available_modifications = list(/singleton/item_modifier/space_suit/pilot) // SIERRA-EDIT - ORIGINAL
	available_modifications = list(/singleton/item_modifier/space_suit/sierra/pilot)
	 // [/SIERRA-EDIT]
	species = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI)
