#define I_SINGULO "singulo"

/atom/proc/singularity_act()
	return

/atom/proc/singularity_pull()
	return

/mob/living/singularity_act()
	investigate_log("has been consumed by a singularity", I_SINGULO)
	gib()
	return 20

/mob/living/singularity_pull(S)
	step_towards(src, S)

/mob/living/carbon/human/singularity_act()
	var/gain = 20
	if(mind)
		if((mind.assigned_role == "Station Engineer") || (mind.assigned_role == "Chief Engineer"))
			gain = 100
		if(mind.assigned_role == "Assistant")
			gain = rand(0, 300)
	investigate_log(I_SINGULO,"has been consumed by a singularity", I_SINGULO)
	gib()
	return gain

/mob/living/carbon/human/singularity_pull(S, current_size)
	if(current_size >= STAGE_THREE)
		var/list/handlist = list(l_hand, r_hand)
		for(var/obj/item/hand in handlist)
			if(prob(current_size*5) && hand.w_class >= ((11-current_size)/2) && u_equip(hand))
				step_towards(hand, src)
				src << "<span class = 'warning'>The [S] pulls \the [hand] from your grip!</span>"
	apply_effect(current_size * 3, IRRADIATE)
	if(shoes)
		if(shoes.item_flags & NOSLIP) return 0
	..()

/obj/singularity_act()
	if(simulated)
		ex_act(1)
		if(src)
			qdel(src)
		return 2

/obj/singularity_pull(S, current_size)
	if(simulated)
		if(anchored)
			if(current_size >= STAGE_FIVE)
				step_towards(src, S)
		else
			step_towards(src, S)

/obj/effect/beam/singularity_pull()
	return

/obj/effect/overlay/singularity_pull()
	return

/obj/item/singularity_pull(S, current_size)
	spawn(0) //this is needed or multiple items will be thrown sequentially and not simultaneously
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
	src.loc = null
	qdel(src)
	return 5000

/obj/machinery/power/supermatter/singularity_act()
	if(!src.loc)
		return

	var/prints = ""
	if(src.fingerprintshidden)
		prints = ", all touchers : " + src.fingerprintshidden

	SetUniversalState(/datum/universal_state/supermatter_cascade)
	log_admin("New super singularity made by eating a SM crystal [prints]. Last touched by [src.fingerprintslast].")
	message_admins("New super singularity made by eating a SM crystal [prints]. Last touched by [src.fingerprintslast].")
	src.loc = null
	qdel(src)
	return 50000

/obj/item/projectile/beam/emitter/singularity_pull()
	return

/obj/item/weapon/storage/backpack/holding/singularity_act(S, current_size)
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
	ChangeTurf(get_base_turf(src.z))
	return 2

/turf/simulated/wall/singularity_pull(S, current_size)

	if(!reinf_material)
		if(current_size >= STAGE_FIVE)
			if(prob(75))
				dismantle_wall()
			return
		if(current_size == STAGE_FOUR)
			if(prob(30))
				dismantle_wall()
	else
		if(current_size >= STAGE_FIVE)
			if(prob(30))
				dismantle_wall()

/turf/space/singularity_act()
	return

/*******************
* Nar-Sie Act/Pull *
*******************/
/atom/proc/singuloCanEat()
	return 1

/mob/dead/singuloCanEat()
	return 0

/mob/eye/singuloCanEat()
	return 0

/mob/new_player/singuloCanEat()
	return 0
