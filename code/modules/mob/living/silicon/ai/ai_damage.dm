/mob/living/silicon/ai
	var/fireloss = 0
	var/bruteloss = 0
	var/oxyloss = 0

/mob/living/silicon/ai/getFireLoss()
	return fireloss

/mob/living/silicon/ai/getBruteLoss()
	return bruteloss

/mob/living/silicon/ai/getOxyLoss()
	return oxyloss

/mob/living/silicon/ai/adjustFireLoss(amount)
	if(status_flags & GODMODE) return
	fireloss = max(0, fireloss + min(amount, get_current_health()))

/mob/living/silicon/ai/adjustBruteLoss(amount)
	if(status_flags & GODMODE) return
	bruteloss = max(0, bruteloss + min(amount, get_current_health()))

/mob/living/silicon/ai/adjustOxyLoss(amount)
	if(status_flags & GODMODE) return
	oxyloss = max(0, oxyloss + min(amount, get_max_health() - oxyloss))

/mob/living/silicon/ai/setFireLoss(amount)
	if(status_flags & GODMODE)
		fireloss = 0
		return
	fireloss = max(0, amount)

/mob/living/silicon/ai/setOxyLoss(amount)
	if(status_flags & GODMODE)
		oxyloss = 0
		return
	oxyloss = max(0, amount)

/mob/living/silicon/ai/updatehealth()
	if(status_flags & GODMODE)
		revive_health()
		set_stat(CONSCIOUS)
		setOxyLoss(0)
	else
		set_health(get_max_health() - getFireLoss() - getBruteLoss()) // Oxyloss is not part of health as it represents AIs backup power. AI is immune against ToxLoss as it is machine.

/mob/living/silicon/ai/rejuvenate()
	..()
	add_ai_verbs(src)

// Returns percentage of AI's remaining backup capacitor charge (maxhealth - oxyloss).
/mob/living/silicon/ai/proc/backup_capacitor()
	var/max_health = get_max_health()
	return ((getOxyLoss() - max_health) / max_health) * (-100)

// Returns percentage of AI's remaining hardware integrity (maxhealth - (bruteloss + fireloss))
/mob/living/silicon/ai/proc/hardware_integrity()
	return get_health_percentage()
