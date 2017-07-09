/obj/structure/deity/altar
	name = "altar"
	desc = "A structure made for the express purpose of religion."
	health = 50
	power_adjustment = 10
	must_be_converted_turf = 0
	important_structure = 1
	build_cost = 500
	var/mob/living/target
	var/cycles_before_converted = 5
	var/next_cycle = 0

/obj/structure/deity/altar/New()
	..()
	if(linked_god)
		linked_god.power_min += 10

/obj/structure/deity/altar/Destroy()
	if(target)
		remove_target()
	if(linked_god)
		linked_god.power_min -= 10
		to_chat(src, "<span class='danger'>You've lost an altar!</span>")
	return ..()

/obj/structure/deity/altar/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/grab))
		var/obj/item/grab/G = I
		if(G.force_danger())
			G.affecting.forceMove(get_turf(src))
			G.affecting.Weaken(1)
			user.visible_message("<span class='warning'>\The [user] throws \the [G.affecting] onto \the [src]!</span>")
			user.drop_from_inventory(G)
	else ..()

/obj/structure/deity/altar/process()
	if(!target || world.time < next_cycle)
		return
	if(!linked_god || target.stat)
		to_chat(linked_god, "<span class='warning'>\The [target] has lost consciousness, breaking \the [src]'s hold on their mind!</span>")
		remove_target()
		return

	next_cycle = world.time + 10 SECONDS
	cycles_before_converted--
	if(!cycles_before_converted)
		src.visible_message("For one thundering moment, \the [target] cries out in pain before going limp and broken.")
		godcult.add_antagonist_mind(target.mind,1, "Servant of [linked_god]","Your loyalty may be faulty, but you know that it now has control over you...", specific_god=linked_god)
		remove_target()
		return

	switch(cycles_before_converted)
		if(4)
			text = "You can't think straight..."
		if(3)
			text = "You feel like your thought are being overriden..."
		if(2)
			text = "You can't.... concentrate.. must... resist!"
		if(1)
			text = "Can't... resist. ... anymore."
			to_chat(linked_god, "<span class='warning'>\The [target] is getting close to conversion!</span>")
	to_chat(target, "<span class='cult'>[text]. <a href='?src=\ref[src];resist=\ref[target]'>Resist Conversion</a></span>")


//Used for force conversion.
/obj/structure/deity/altar/proc/set_target(var/mob/living/L)
	if(target || !linked_god)
		return
	cycles_before_converted = initial(cycles_before_converted)
	processing_objects |= src
	target = L
	destroyed_event.register(L,src,/obj/structure/deity/altar/proc/remove_target)
	moved_event.register(L, src, /obj/structure/deity/altar/proc/remove_target)
	death_event.register(L, src, /obj/structure/deity/altar/proc/remove_target)
	update_icon()

/obj/structure/deity/altar/proc/remove_target()
	processing_objects -= src
	destroyed_event.unregister(target, src)
	moved_event.unregister(target, src)
	death_event.unregister(target, src)
	target = null
	update_icon()

/obj/structure/deity/altar/Topic(var/href, var/list/href_list)
	if(..())
		return 1

	if(href_list["resist"])
		var/mob/living/M = locate(href_list["resist"])
		if(!M || target != M || M.stat || M.last_special > world.time)
			return

		M.last_special = world.time + 10 SECONDS
		M.visible_message("<span class='warning'>\The [M] writhes on top of \the [src]!</span>", "<span class='notice'>You struggle against the intruding thoughts, keeping them at bay!</span>")
		to_chat(linked_god, "<span class='warning'>\The [M] slows its conversion through willpower!</span>")
		cycles_before_converted++
		if(prob(50))
			to_chat(M, "<span class='danger'>The mental strain is too much for you! You feel your body weakening!</span>")
			M.adjustToxLoss(15)
			M.adjustHalLoss(30)

/obj/structure/deity/altar/update_icon()
	overlays.Cut()
	if(target)
		overlays += image('icons/effects/effects.dmi', icon_state =  "summoning")