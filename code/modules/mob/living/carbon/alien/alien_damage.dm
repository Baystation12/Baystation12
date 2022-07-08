/mob/living/carbon/alien/ex_act(severity)
	if (status_flags & GODMODE)
		return
	if(!blinded)
		flash_eyes()

	var/b_loss = null
	var/f_loss = null
	switch (severity)
		if (EX_ACT_DEVASTATING)
			b_loss += 500
			gib()
			return

		if (EX_ACT_HEAVY)

			b_loss += 60

			f_loss += 60

			ear_damage += 30
			ear_deaf += 120

		if(EX_ACT_LIGHT)
			b_loss += 30
			if (prob(50))
				Paralyse(1)
			ear_damage += 15
			ear_deaf += 60

	adjustBruteLoss(b_loss)
	adjustFireLoss(f_loss)

	updatehealth()
