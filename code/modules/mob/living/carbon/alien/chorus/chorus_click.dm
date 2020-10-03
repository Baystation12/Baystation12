/mob/living/carbon/alien/chorus/ClickOn(var/atom/A, var/params)
	if(stat != CONSCIOUS)
		return
	var/list/modifiers = params2list(params)
	if(modifiers["ctrl"] && selected_building)
		start_building(A)
	else if(istype(A, /obj/structure/chorus) && a_intent != I_HURT)
		var/obj/structure/chorus/C = A
		C.chorus_click(src)
	else
		..()

/mob/living/carbon/alien/chorus/UnarmedAttack(var/atom/A)
	setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(A.attack_generic(src, melee_damage, attack_text, 1, BRUTE))
		playsound(src, attack_sound, 50, 1)