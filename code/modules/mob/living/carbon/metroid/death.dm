/mob/living/carbon/slime/death(gibbed)

	if(stat == DEAD) return

	if(!gibbed && is_adult)
		var/mob/living/carbon/slime/M = new /mob/living/carbon/slime(loc, colour)
		M.rabid = 1
		M.Friends = Friends.Copy()
		step_away(M, src)
		is_adult = 0
		maxHealth = 150
		revive()
		if (!client) rabid = 1
		number = rand(1, 1000)
		name = "[colour] [is_adult ? "adult" : "baby"] slime ([number])"
		return

	. = ..(gibbed, "seizes up and falls limp...")
	mood = null
	regenerate_icons()

	return