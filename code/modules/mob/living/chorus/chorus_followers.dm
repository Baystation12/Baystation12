/obj/item/weapon/implant/chorus_loyalty
	name = "strange implant"
	known = TRUE
	var/mob/living/chorus/controller

/obj/item/weapon/implant/chorus_loyalty/New(var/newloc, var/chorus)
	..(newloc)
	controller = chorus
	controller.shape_implant(src)
	GLOB.death_event.register(controller, .proc/deity_dead, src)

/obj/item/weapon/implant/chorus_loyalty/implant_in_mob(var/mob/M, var/target_zone)
	. = ..()
	if(imp_in && isliving(imp_in))
		var/mob/living/L = imp_in
		if(L.mind)
			var/datum/mind/mind = L.mind
			if(controller && (mind in controller.followers))
				return
		controller.add_follower(L)

/obj/item/weapon/implant/chorus_loyalty/removed()
	if(imp_in && controller)
		controller.remove_follower(imp_in)

/obj/item/weapon/implant/chorus_loyalty/proc/deity_dead()
	controller = null
	to_chat(imp_in, "<span class='notice'>You feel weird. As if something has lost control of you.</span>")
	GLOB.death_event.unregister(controller, src)

/obj/item/weapon/implant/chorus_loyalty/Destroy()
	GLOB.death_event.unregister(controller, src)
	. = ..()

/mob/living/chorus/proc/give_implant(var/mob/living/L)
	var/obj/item/weapon/implant/chorus_loyalty/cl = new(get_turf(L), src)
	if(!cl.can_implant(L, BP_HEAD))
		qdel(cl)
	cl.implant_in_mob(L, BP_HEAD)

/mob/living/chorus/proc/get_implant(var/mob/living/L)
	var/obj/item/organ/external/head
	if(istype(L, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = L
		head = H.get_organ(BP_HEAD)
	if(!head)
		return null
	for(var/i in head.implants)
		if(istype(i, /obj/item/weapon/implant/chorus_loyalty))
			var/obj/item/weapon/implant/chorus_loyalty/cl = i
			if(cl.controller == src)
				return cl
	return null

/mob/living/chorus/set_form(var/datum/chorus_form/new_form)
	. = ..()
	if(.)
		for(var/m in followers) //Get the right implant...
			var/datum/mind/mind = m
			var/mob/living/L = mind.current
			if(L)
				var/imp = get_implant(L)
				if(imp)
					shape_implant(imp)

/mob/living/chorus
	var/list/followers = list() //Mind datums

/mob/living/chorus/proc/add_follower(var/mob/living/L)
	if(L.mind && !(L.mind in followers))
		followers += L.mind
		if(form)
			to_chat(L, "<span class='notice'>[form.join_message][src]</span>")
		chorus_net.add_source(L)
		update_buildings_followers()
		var/imp = get_implant(L)
		if(!imp)
			give_implant(L)

/mob/living/chorus/proc/remove_follower(var/mob/living/L)
	if(L.mind && (L.mind in followers))
		followers -= L.mind
		if(form)
			to_chat(L, "<span class='warning'>[form.leave_message][src]</span>")
		chorus_net.remove_source(L)
		update_buildings_followers()
		if(L.mind in GLOB.godcult.current_antagonists)
			GLOB.godcult.remove_antagonist(L.mind)
		var/obj/item/weapon/implant/chorus_loyalty/imp = get_implant(L)
		if(imp) //Do all the remove steps if it isn't removed already and delete the implant
			imp.part.implants -= imp
			for(var/w in imp.part.wounds)
				var/datum/wound/wound = w
				wound.embedded_objects -= imp
			imp.dropInto(get_turf(L))
			imp.removed()
			qdel(imp)

/mob/living/chorus/proc/get_followers_nearby(var/atom/target, var/dist)
	. = list()
	for(var/m in followers)
		var/datum/mind/mind = m
		if(mind.current && get_dist(target, mind.current) <= dist)
			. += mind.current

/mob/living/chorus/proc/follow_follower(var/mob/living/L)
	eyeobj.start_following(L)