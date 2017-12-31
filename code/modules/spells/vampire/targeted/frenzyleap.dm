// Grapple a victim by leaping onto them.


//CD: 80 SECONDS

/datum/actionbutton
	name = "Grapple"
	desc = "Lunge towards a target like an animal, and grapple them."
	charge_max = 80 SECONDS

/spell/targeted/vampire/grapple/cast()
	VAMPMACRO(grapple())

/mob/living/carbon/human/proc/grapple()

	if (status_flags & LEAPING)
		return

	if (stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		to_chat(src, "<span class='warning'>You cannot leap in your current state.</span>")
		return

	var/list/targets = list()
	for (var/mob/living/carbon/human/H in oview(4, src))
		targets += H

	targets -= src

	if (!targets.len)
		to_chat(src, "<span class='warning'>No valid targets visible or in range.</span>")
		return

	var/mob/living/carbon/human/T = pick(targets)

	visible_message("<span class='danger'>[src] leaps at [T]!</span>")
	throw_at(get_step(get_turf(T), get_turf(src)), 4, 1, src)

	status_flags |= LEAPING

	sleep(5)

	if (status_flags & LEAPING)
		status_flags &= ~LEAPING

	if (!src.Adjacent(T))
		to_chat(src, "<span class='warning'>You miss!</span>")
		return

	T.Weaken(3)

	admin_attack_log(src, T, "lept at and grappled [key_name(T)]", "was lept at and grappled by [key_name(src)]", "lept at and grappled")

	src.visible_message("<span class='warning'><b>\The [src]</b> seizes [T] aggressively!</span>")
	make_grab(src,T,NORM_AGGRESSIVE)

