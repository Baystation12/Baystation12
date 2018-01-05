//snowflake subtype of the blood drain spell. Drains less blood, but can do so MUCH more frequently.
//Does extremely minor healing; this is an offensive spell.
/spell/aoe_turf/drain_blood/vampire

	desc = "This spell allows the user to feed from a range, just like Kain would've done!"
	flags = REQUIRESVAMPIRE
	charge_max = 10 SECONDS
	invocation = "holds a hand up, their middle and ring fingers curled in." //HE'S THROWING UP THE HORNS
	invocation_type = SpI_EMOTE
	range = 7
	inner_radius = 0
	time_between_channels = 1 SECOND
	number_of_channels = 3
	volume = 5

/spell/aoe_turf/drain_blood/vampire/cast(var/list/targets, var/mob/user)
	var/parent = ..() //This is dumb but effective.
	if(parent)
		user.draw_usable_blood(volume)