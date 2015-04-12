/mob/living/carbon/slime/death(gibbed)

	if(stat == DEAD) return
	stat = DEAD

	if(!gibbed)
		if(is_adult)
			var/mob/living/carbon/slime/M = new /mob/living/carbon/slime(loc)
			M.colour = colour
			M.rabid = 1
			is_adult = 0
			maxHealth = 150
			revive()
			regenerate_icons()
			number = rand(1, 1000)
			name = "[colour] [is_adult ? "adult" : "baby"] slime ([number])"
			return

	icon_state = "[colour] baby slime dead"
	overlays.Cut()

	return ..(gibbed)