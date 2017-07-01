//Redefining some robot procs, since drones can't be repaired and really shouldn't take component damage.
/mob/living/silicon/robot/drone
	var/fireloss = 0
	var/bruteloss = 0

/mob/living/silicon/robot/drone/take_overall_damage(var/brute = 0, var/burn = 0, var/sharp = 0, var/used_weapon = null)
	adjustBruteLoss(brute)
	adjustFireLoss(burn)

/mob/living/silicon/robot/drone/heal_overall_damage(var/brute, var/burn)
	adjustBruteLoss(-brute)
	adjustFireLoss(-burn)

/mob/living/silicon/robot/drone/take_organ_damage(var/brute = 0, var/burn = 0, var/sharp = 0, var/emp = 0)
	take_overall_damage(brute,burn)

/mob/living/silicon/robot/drone/heal_organ_damage(var/brute, var/burn)
	heal_overall_damage(brute,burn)

/mob/living/silicon/robot/drone/getFireLoss()
	return fireloss

/mob/living/silicon/robot/drone/getBruteLoss()
	return bruteloss