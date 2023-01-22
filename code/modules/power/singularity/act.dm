#define I_SINGULO "singulo"

/atom/proc/singularity_act()
	return

/atom/proc/singularity_pull(S, current_size)
	return

/mob/living/singularity_act()
	investigate_log("has been consumed by a singularity", I_SINGULO)
	gib()
	return 20

/mob/living/singularity_pull(S, current_size)
	step_towards(src, S)
	apply_damage(current_size * 3, DAMAGE_RADIATION, damage_flags = DAMAGE_FLAG_DISPERSED)

/mob/living/carbon/human/singularity_pull(S, current_size)
	if(current_size >= STAGE_THREE)
		var/list/handlist = list(l_hand, r_hand)
		for(var/obj/item/hand in handlist)
			if(prob(current_size*5) && hand.w_class >= ((11-current_size)/2) && unEquip(hand))
				step_towards(hand, S)
				to_chat(src, "<span class = 'warning'>\The [S] pulls \the [hand] from your grip!</span>")
		if(!lying && (!shoes || !(shoes.item_flags & ITEM_FLAG_NOSLIP)) && (!species || !(species.check_no_slip(src))) && prob(current_size*5))
			to_chat(src, "<span class='danger'>A strong gravitational force slams you to the ground!</span>")
			Weaken(current_size)
	..()

/obj/singularity_act()
	if(simulated)
		ex_act(EX_ACT_DEVASTATING)
		if(src)
			qdel(src)
		return 2

/obj/singularity_pull(S, current_size)
	if(simulated && !anchored)
		step_towards(src, S)

/obj/effect/beam/singularity_pull()
	return

/obj/effect/overlay/singularity_pull()
	return

/obj/item/singularity_pull(S, current_size)
	set waitfor = 0
	if(anchored)
		return
	sleep(0) //this is needed or multiple items will be thrown sequentially and not simultaneously
	if(current_size >= STAGE_FOUR)
		//throw_at(S, 14, 3)
		step_towards(src,S)
		sleep(1)
		step_towards(src,S)
	else if(current_size > STAGE_ONE)
		step_towards(src,S)
	else ..()

/obj/machinery/atmospherics/pipe/singularity_pull()
	return

/obj/machinery/power/supermatter/shard/singularity_act()
	qdel(src)
	return 5000

/obj/machinery/power/supermatter/singularity_act()
	qdel(src)
	return 50000

/obj/item/projectile/beam/emitter/singularity_pull()
	return

/obj/item/storage/backpack/holding/singularity_act(S, current_size)
	var/dist = max((current_size - 2), 1)
	explosion(src.loc,(dist),(dist*2),(dist*4))
	return 1000

/turf/singularity_act(S, current_size)
	if(!is_plating())
		for(var/obj/O in contents)
			if(O.level != 1)
				continue
			if(O.invisibility == 101)
				O.singularity_act(src, current_size)
	ChangeTurf(get_base_turf_by_area(src))
	return 2

/turf/space/singularity_act()
	return

/*******************
* Nar-Sie Act/Pull *
*******************/
/atom/proc/singuloCanEat()
	return 1

/mob/observer/singuloCanEat()
	return 0

/mob/new_player/singuloCanEat()
	return 0
