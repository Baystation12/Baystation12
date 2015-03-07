/mob/living/carbon/alien/ex_act(severity)

	if(!blinded)
		flick("flash", flash)

	var/b_loss = null
	var/f_loss = null
	switch (severity)
		if (1.0)
			b_loss += 500
			gib()
			return

		if (2.0)

			b_loss += 60

			f_loss += 60

			ear_damage += 30
			ear_deaf += 120

		if(3.0)
			b_loss += 30
			if (prob(50))
				Paralyse(1)
			ear_damage += 15
			ear_deaf += 60

	adjustBruteLoss(b_loss)
	adjustFireLoss(f_loss)

	updatehealth()



/mob/living/carbon/alien/blob_act()
	if (stat == 2)
		return
	var/shielded = 0

	var/damage = null
	if (stat != 2)
		damage = rand(10,30)

	if(shielded)
		damage /= 4

		//paralysis += 1

	show_message("\red The blob attacks you!")

	adjustFireLoss(damage)

	updatehealth()
	return