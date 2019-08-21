// Submap specific atom definitions.

MANTIDIFY(/obj/item/weapon/reagent_containers/food/drinks/cans/waterbottle, "hydration cylinder", "hydration")
MANTIDIFY(/obj/item/weapon/material/knife/kitchen/cleaver, "mantid cleaver", "cleaver")
MANTIDIFY(/obj/structure/reagent_dispensers/water_cooler, "mantid fluid dispenser", "water dispensing")
MANTIDIFY(/obj/structure/bed/chair/padded/purple, "mantid nest", "resting place")

/obj/structure/bed/chair/padded/purple/ascent
	icon_state = "nest_chair"
	base_icon = "nest_chair"
	pixel_z = 0

/obj/structure/bed/chair/padded/purple/ascent/gyne
	name = "mantid throne"
	icon_state = "nest_chair_large"
	base_icon = "nest_chair_large"

/obj/item/weapon/light/tube/ascent
	name = "mantid light filament"
	color = COLOR_CYAN
	b_colour = COLOR_CYAN
	desc = "Some kind of strange alien lightbulb technology."

/obj/structure/ascent_spawn
	name = "mantid cryotank"
	desc = "A liquid-filled, cloudy tank with strange forms twitching inside."
	icon = 'icons/obj/cryogenics.dmi'
	icon_state = "cellold2"
	anchored = TRUE
	density =  TRUE
