/datum/phenomena/movable_object/dimensional_locker
	object_type = /obj/structure/closet
	name = "Dimensional Locker"
	cost = 10
	desc = "Summon a trans-dimensional locker anywhere within your influence. You may transport objects and things, but not people in it."

/datum/phenomena/movable_object/dimensional_locker/activate(var/atom/a, var/mob/living/deity/user)
	var/list/mobs_inside = list()
	recursive_content_check(object_to_move, mobs_inside, client_check = 0, sight_check = 0, include_objects = 0)

	for(var/i in mobs_inside)
		var/mob/M = i
		M.dropInto(object_to_move.loc)
		to_chat(M,"<span class='warning'>You are suddenly flung out of \the [object_to_move]!</span>")
	..()

/datum/phenomena/portals
	name = "Portals"
	desc = "Summon a portal linked to the last portal you've created. The portal will be destroyed if it is not linked when someone crosses it."
	cost = 30
	flags = PHENOMENA_NEAR_STRUCTURE|PHENOMENA_MUNDANE|PHENOMENA_FOLLOWER|PHENOMENA_NONFOLLOWER
	expected_type = /atom
	var/list/portals = list()

/datum/phenomena/portals/activate(var/atom/a, var/mob/living/deity/user)
	..()
	var/obj/effect/portal/P = new(get_turf(a), null, 0)
	P.failchance = 0
	portals += P
	GLOB.destroyed_event.register(P,src,/datum/phenomena/portals/proc/remove_portal)
	if(portals.len > 2)
		var/removed = portals[1]
		remove_portal(removed)
		qdel(removed)
	if(portals.len > 1)
		var/obj/effect/portal/P1 = portals[1]
		var/obj/effect/portal/P2 = portals[2]
		P1.target = get_turf(P2)
		P2.target = get_turf(P1)

/datum/phenomena/portals/proc/remove_portal(var/portal)
	portals -= portal
	GLOB.destroyed_event.unregister(portal,src)
	var/turf/T = get_turf(portal)
	for(var/obj/effect/portal/P in portals)
		if(P.target == T)
			P.target = null

/datum/phenomena/banishing_smite
	name = "Banishing Smite"
	desc = "Deal a terrible blow to a mortal. If they are hurt enough ,they will find themselves trapped in a rift for 30 seconds."
	cost = 70
	cooldown = 300
	flags = PHENOMENA_NEAR_STRUCTURE|PHENOMENA_MUNDANE|PHENOMENA_FOLLOWER|PHENOMENA_NONFOLLOWER
	expected_type = /mob/living

/datum/phenomena/banishing_smite/activate(var/mob/living/L, var/mob/living/deity/user)
	..()
	L.take_overall_damage(rand(5,30),0,0,0,"blunt intrument") //Actual spell does 5d10 but maaaybe too much.
	playsound(get_turf(L), 'sound/effects/bamf.ogg', 100, 1)
	to_chat(L, "<span class='danger'>Something hard hits you!</span>")
	if(L.health < L.maxHealth/2) //If it reduces past 50%
		var/obj/effect/rift/R = new(get_turf(L))
		L.visible_message("<span class='danger'>\The [L] is quickly sucked into \a [R]!</span>")
		L.forceMove(R)
		spawn(300)
			qdel(R)

/obj/effect/rift
	name = "rift"
	desc = "a tear in space and time."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "rift"
	unacidable = 1
	anchored = 1
	density = 0

/obj/effect/rift/Destroy()
	for(var/o in contents)
		var/atom/movable/M = o
		M.dropInto(loc)
	. = ..()