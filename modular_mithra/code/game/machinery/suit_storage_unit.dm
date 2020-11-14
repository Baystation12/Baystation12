//This is for overriding whatever the heck is related to Suit Storage Units

//Suit cycler overrides for allowing our snowflake species to wear suits:
/obj/machinery/suit_cycler/Initialize()
	. = ..()
	species |= list(SPECIES_AKULA,SPECIES_VULP,SPECIES_VASS,SPECIES_TAJ)

/obj/machinery/suit_cycler/engineering/Initialize()
	. = ..()
	species |= list(SPECIES_AKULA,SPECIES_VULP,SPECIES_VASS,SPECIES_TAJ)

/obj/machinery/suit_cycler/mining/Initialize()
	. = ..()
	species |= list(SPECIES_AKULA,SPECIES_VULP,SPECIES_VASS,SPECIES_TAJ)

/obj/machinery/suit_cycler/science/Initialize()
	. = ..()
	species |= list(SPECIES_AKULA,SPECIES_VULP,SPECIES_VASS,SPECIES_TAJ)

/obj/machinery/suit_cycler/security/Initialize()
	. = ..()
	species |= list(SPECIES_AKULA,SPECIES_VULP,SPECIES_VASS,SPECIES_TAJ)

/obj/machinery/suit_cycler/medical/Initialize()
	. = ..()
	species |= list(SPECIES_AKULA,SPECIES_VULP,SPECIES_VASS,SPECIES_TAJ)

/obj/machinery/suit_cycler/syndicate/Initialize()
	. = ..()
	species |= list(SPECIES_AKULA,SPECIES_VULP,SPECIES_VASS,SPECIES_TAJ)

/obj/machinery/suit_cycler/pilot/Initialize()
	. = ..()
	species |= list(SPECIES_AKULA,SPECIES_VULP,SPECIES_VASS,SPECIES_TAJ)

/obj/machinery/suit_cycler/exploration/Initialize()
	. = ..()
	species |= list(SPECIES_AKULA,SPECIES_VULP,SPECIES_VASS,SPECIES_TAJ)