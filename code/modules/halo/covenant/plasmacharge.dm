
/obj/item/plasmacharge
	name = "plasma charge"
	desc = "An explosive Covenant device for breaching doors."
	icon = 'plasmacharge.dmi'
	icon_state = "plasmacharge"
	var/detonate_timer = 50		//measured in deciseconds

/obj/item/plasmacharge/attack_self(var/mob/user)
	detonate_timer = input("Choose delay in seconds","New delay", detonate_timer/10) as num
	to_chat(user, "<span class='info'>The new delay is [detonate_timer] seconds.</span>")
	detonate_timer *= 10	//convert to deciseconds
	flick("animated",src)

/obj/item/plasmacharge/afterattack(var/atom/target,var/mob/user,adjacent,var/clickparams)
	if(istype(target, /obj/machinery/door/airlock))
		user.visible_message("<span class='warning'>[user] attaches [src] to [target] and sets it for a [detonate_timer/10] second timer!</span>")
		user.drop_item()
		detonate(target)
		qdel(src)
	else
		return ..()

/obj/item/plasmacharge/proc/detonate(var/atom/movable/target)
	if(istype(target, /obj/machinery/door/airlock))
		var/obj/machinery/door/airlock/A = target
		spawn(detonate_timer)
			if(A)
				A.visible_message("<span class='warning'>[src] detones on [A], breaking it open.</span>")
				A.open(1)
				A.set_broken()
				for(var/mob/living/M in range(A, 1))
					to_chat(M,"<span class='warning'>You are hit by a wave of plasma from [src]!.</span>")
					M.ex_act(2)
