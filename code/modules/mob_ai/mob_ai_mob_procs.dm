// Defines default behaviors the AI can rely on
/mob/living/proc/MobAISpeech()
	return

/mob/proc/MobAICanAttackTarget(var/atom/target)
	return 0

/mob/living/MobAICanAttackTarget(var/atom/target)
	return target && (get_dist(host, target) <= 1)

/mob/living/simple_animal/MobAISpeech()


/mob/living/simple_animal/MobAICanAttackTarget(var/atom/target)
	var distance = (ranged ? 6 : 1)
	return target && (get_dist(src, target) <= distance)
