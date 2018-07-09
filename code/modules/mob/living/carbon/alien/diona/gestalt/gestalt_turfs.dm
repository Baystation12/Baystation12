/decl/flooring/diona
	name = "biomass"
	desc = "a mass of small intertwined aliens forming a floor... Creepy."
	icon = 'icons/turf/floors.dmi'
	icon_base = "diona"
	flags = TURF_ACID_IMMUNE | TURF_REMOVE_SHOVEL

/material/diona
	name = "biomass"
	icon_colour = null
	stack_type = null
	integrity = 600
	icon_base = "diona"
	icon_reinf = "noreinf"
	hitsound = 'sound/effects/attackblob.ogg'
	conductive = 0

/material/diona/place_dismantled_product()
	return

/material/diona/place_dismantled_girder(var/turf/target)
	spawn_diona_nymph(target)
