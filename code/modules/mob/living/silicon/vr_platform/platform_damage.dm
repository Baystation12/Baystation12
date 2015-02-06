/mob/living/silicon/platform/take_overall_damage(var/brute = 0, var/burn = 0, var/sharp = 0, var/used_weapon = null)
	health -= brute
	health -= burn

/mob/living/silicon/platform/heal_overall_damage(var/brute, var/burn)

	health += brute
	health += burn

	if(bruteloss<0) bruteloss = 0
	if(fireloss<0) fireloss = 0

/mob/living/silicon/platform/take_organ_damage(var/brute = 0, var/burn = 0, var/sharp = 0)
	take_overall_damage(brute,burn)

/mob/living/silicon/platform/heal_organ_damage(var/brute, var/burn)
	heal_overall_damage(brute,burn)

/mob/living/silicon/platform/getFireLoss()
	return fireloss

/mob/living/silicon/platform/getBruteLoss()
	return bruteloss