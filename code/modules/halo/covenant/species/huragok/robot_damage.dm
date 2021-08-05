// Replacing parts is... Difficult. Let's use a simplified damage system

/mob/living/silicon/robot/huragok/getBruteLoss()
	return bruteloss

/mob/living/silicon/robot/huragok/getFireLoss()
	return fireloss

/mob/living/silicon/robot/huragok/adjustBruteLoss(var/amount)
	bruteloss = max(0,bruteloss + amount)
	return

/mob/living/silicon/robot/huragok/adjustFireLoss(var/amount)
	fireloss = max(0,fireloss + amount)
	return

// Just in case this code gets called

/mob/living/silicon/robot/huragok/heal_organ_damage(var/brute, var/burn)
	heal_overall_damage(brute,burn)
	return

/mob/living/silicon/robot/huragok/take_organ_damage(var/brute = 0, var/burn = 0, var/sharp = 0, var/edge = 0, var/emp = 0)
	take_overall_damage(brute,burn)
	return

/mob/living/silicon/robot/huragok/heal_overall_damage(var/brute, var/burn)
	if (brute) adjustBruteLoss(-brute)
	if (burn) adjustFireLoss(-burn)
	return

/mob/living/silicon/robot/huragok/take_overall_damage(var/brute = 0, var/burn = 0, var/sharp = 0, var/used_weapon = null)
	if (brute) adjustBruteLoss(brute)
	if (burn) adjustFireLoss(burn)
	return
