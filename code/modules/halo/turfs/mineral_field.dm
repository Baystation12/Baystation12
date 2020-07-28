
#define RESOURCEFIELD_LOWER_AMOUNT 5
#define RESOURCEFIELD_UPPER_AMOUNT 15

/turf/simulated/floor/mineral_field
	name = "Mineral Field"
	desc = "A sparkling field that marks a high concentration of minerals in the ground. A ground penetrating drill should be able to reach the hidden riches."
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_state = "asteroid"
	base_name = "sand"
	base_desc = "Gritty and unpleasant."
	base_icon = 'icons/turf/flooring/asteroid.dmi'
	base_icon_state = "asteroid"

	initial_flooring = null
	initial_gas = null
	temperature = TCMB

	has_resources = 1

/turf/simulated/floor/mineral_field/Initialize()
	. = ..()
	for(var/resource in resources)
		resources[resource] = rand(RESOURCEFIELD_LOWER_AMOUNT,RESOURCEFIELD_UPPER_AMOUNT)

/turf/simulated/floor/mineral_field/iron
	resources = list("iron")

/turf/simulated/floor/mineral_field/gold
	resources = list("gold")

/turf/simulated/floor/mineral_field/silver
	resources = list("silver")

/turf/simulated/floor/mineral_field/diamond
	resources = list("diamond")

/turf/simulated/floor/mineral_field/uranium
	resources = list("uranium")

/turf/simulated/floor/mineral_field/carbon //"carbonaceous rock",
	resources = list("carbonaceous rock")

/turf/simulated/floor/mineral_field/platinum
	resources = list("platinum")

/turf/simulated/floor/mineral_field/duridium
	resources = list("duridium")

/turf/simulated/floor/mineral_field/osmium
	resources = list("osmium")
