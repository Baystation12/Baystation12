/mob/living/proc/handle_recoil(var/obj/item/gun/G)
	deltimer(recoil_reduction_timer)
	if(G.one_hand_penalty)//If the gun has a two handed penalty and is not weilded.
		if(!G.is_held_twohanded(src))
			recoil += G.one_hand_penalty+(((2-src.get_skill_value(SKILL_WEAPONS))*0.1)/2) //Then the one hand penalty wil lbe added to the recoil.
	if(G.recoil_buildup)
		recoil += G.recoil_buildup+((2-src.get_skill_value(SKILL_WEAPONS))*0.1)
		update_recoil()

/mob/living/proc/calc_recoil()

	if(recoil >= 10)
		recoil *= 0.9
	else if(recoil < 10 && recoil > 1)
		recoil -= 1
	else
		recoil = 0

	if(recoil != 0) recoil_reduction_timer = addtimer(CALLBACK(src, .proc/calc_recoil), 0.1 SECONDS, TIMER_STOPPABLE)
	else deltimer(recoil_reduction_timer)

//Called after setting recoil
/mob/living/proc/update_recoil()
	recoil_reduction_timer = addtimer(CALLBACK(src, .proc/calc_recoil), 0.3 SECONDS, TIMER_STOPPABLE)
