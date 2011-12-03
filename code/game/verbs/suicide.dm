/mob/var/suiciding = 0

/mob/living/carbon/human/verb/suicide()
	set hidden = 1

	if (stat == 2)
		src << "You're already dead!"
		return

	if (!ticker)
		src << "You can't commit suicide before the game starts!"
		return

	if (suiciding)
		src << "You're already committing suicide! Be patient!"
		return

	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")

	if(alien_egg_flag)
		src << "The alien inside you forces you to breathe, preventing you from suiciding."
		return

	if(confirm == "Yes")
		suiciding = 1
		//instead of killing them instantly, just put them at -175 health and let 'em gasp for a while
		viewers(src) << "\red <b>[src] is attempting to bite \his tongue. It looks like \he's trying to commit suicide.</b>"
		oxyloss = max(175 - getToxLoss() - getFireLoss() - getBruteLoss(), getOxyLoss())
		updatehealth()

/mob/living/carbon/brain/verb/suicide()
	set hidden = 1

	if (stat == 2)
		src << "You're already dead!"
		return

	if (!ticker)
		src << "You can't commit suicide before the game starts!"
		return

	if (suiciding)
		src << "You're already committing suicide! Be patient!"
		return

	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")

	if(confirm == "Yes")
		suiciding = 1
		viewers(loc) << "\red <b>[src]'s brain is growing dull and lifeless. It looks like it's trying to commit suicide. Somehow.</b>"
		oxyloss = max(175 - getToxLoss() - getFireLoss() - getBruteLoss(), getOxyLoss())
		updatehealth()
		spawn(200)
			suiciding = 0

/mob/living/carbon/monkey/verb/suicide()
	set hidden = 1

	if (stat == 2)
		src << "You're already dead!"
		return

	if (!ticker)
		src << "You can't commit suicide before the game starts!"
		return

	if (suiciding)
		src << "You're already committing suicide! Be patient!"
		return

	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")

	if(confirm == "Yes")
		suiciding = 1
		//instead of killing them instantly, just put them at -175 health and let 'em gasp for a while
		viewers(src) << "\red <b>[src] is attempting to bite \his tongue. It looks like \he's trying to commit suicide.</b>"
		oxyloss = max(175 - getToxLoss() - getFireLoss() - getBruteLoss(), getOxyLoss())
		updatehealth()

/mob/living/silicon/ai/verb/suicide()
	set hidden = 1

	if (stat == 2)
		src << "You're already dead!"
		return

	if (suiciding)
		src << "You're already committing suicide! Be patient!"
		return

	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")

	if(confirm == "Yes")
		suiciding = 1
		viewers(src) << "\red <b>[src] is powering down. It looks like \he's trying to commit suicide.</b>"
		//put em at -175
		oxyloss = max(175 - getToxLoss() - getFireLoss() - getBruteLoss(), getOxyLoss())
		updatehealth()

/mob/living/silicon/robot/verb/suicide()
	set hidden = 1

	if (stat == 2)
		src << "You're already dead!"
		return

	if (suiciding)
		src << "You're already committing suicide! Be patient!"
		return

	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")

	if(confirm == "Yes")
		suiciding = 1
		viewers(src) << "\red <b>[src] is powering down. It looks like \he's trying to commit suicide.</b>"
		//put em at -175
		oxyloss = max(475 - getToxLoss() - getFireLoss() - getBruteLoss(), getOxyLoss())
		updatehealth()

/mob/living/silicon/pai/verb/suicide()
	set category = "pAI Commands"
	set desc = "Kill yourself and become a ghost (You will receive a confirmation prompt)"
	set name = "pAI Suicide"
	var/answer = input("REALLY kill yourself? This action can't be undone.", "Suicide", "No") in list ("Yes", "No")
	if(answer == "Yes")
		var/obj/item/device/paicard/card = loc
		card.pai = null
		var/turf/T = get_turf_or_move(card.loc)
		for (var/mob/M in viewers(T))
			M.show_message("\blue [src] flashes a message across its screen, \"Wiping core files. Please acquire a new personality to continue using pAI device functions.\"", 3, "\blue [src] bleeps electronically.", 2)
		death(0)
	else
		src << "Aborting suicide attempt."

/mob/living/carbon/alien/humanoid/verb/suicide()
	set hidden = 1

	if (stat == 2)
		src << "You're already dead!"
		return

	if (suiciding)
		src << "You're already committing suicide! Be patient!"
		return

	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")

	if(confirm == "Yes")
		suiciding = 1
		viewers(src) << "\red <b>[src] is thrashing wildly! It looks like \he's trying to commit suicide.</b>"
		//put em at -175
		oxyloss = max(100 - getFireLoss() - getBruteLoss(), getOxyLoss())
		updatehealth()


/mob/living/carbon/metroid/verb/suicide()
	set hidden = 1
	if (stat == 2)
		src << "You're already dead!"
		return

	if (suiciding)
		src << "You're already committing suicide! Be patient!"
		return

	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")

	if(confirm == "Yes")
		suiciding = 1
		oxyloss = 100
		bruteloss = 100
		toxloss = 100
		cloneloss = 100

		updatehealth()
