/* Site 15 related effects.
// Snow is thanks to Polaris.
*/

/obj/effect/overlay/snowfall
	name = "DO NOT USE THIS!"
	desc = "If you see this being used, scream at the mapper."
	icon = 'icons/effects/effects.dmi'
	layer = ABOVE_HUMAN_LAYER
	density = 0
	anchored = 1

/obj/effect/overlay/snowfall/snowlight
	name = "Light Snowfall"
	desc = "What pretty snow!"
	icon_state = "snowfall_light"

 /obj/effect/overlay/snowfall/snowmed
	name = "Moderate Snowfall"
	desc = "Hmm... Looks like six more weeks of winter."
	icon_state = "snowfall_med"

/obj/effect/overlay/snowfall/snowheavy
	name = "Heavy Snowfall"
	desc = "Well, that's just great. Guess your outdoors smoke break just got canceled by inclement weather."
	icon_state = "snowfall_heavy"
