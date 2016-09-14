/spell/targeted/ethereal_jaunt
	name = "Ethereal Jaunt"
	desc = "This spell creates your ethereal form, temporarily making you invisible and able to pass through walls."
	feedback = "EJ"
	school = "transmutation"
	charge_max = 300
	spell_flags = Z2NOCAST | NEEDSCLOTHES | INCLUDEUSER
	invocation = "none"
	invocation_type = SpI_NONE
	range = -1
	max_targets = 1
	level_max = list(Sp_TOTAL = 4, Sp_SPEED = 4, Sp_POWER = 3)
	cooldown_min = 100 //50 deciseconds reduction per rank
	duration = 50 //in deciseconds

	hud_state = "wiz_jaunt"

/spell/targeted/ethereal_jaunt/cast(list/targets) //magnets, so mostly hardcoded
	for(var/mob/living/target in targets)
		target.transforming = 1 //protects the mob from being transformed (replaced) midjaunt and getting stuck in bluespace
		if(target.buckled)
			target.buckled.unbuckle_mob()
		spawn(0)
			var/mobloc = get_turf(target.loc)
			var/obj/effect/dummy/spell_jaunt/holder = new /obj/effect/dummy/spell_jaunt( mobloc )
			var/atom/movable/overlay/animation = new /atom/movable/overlay( mobloc )
			animation.name = "water"
			animation.density = 0
			animation.anchored = 1
			animation.icon = 'icons/mob/mob.dmi'
			animation.layer = 5
			animation.master = holder
			target.ExtinguishMob()
			if(target.buckled)
				target.buckled = null
			jaunt_disappear(animation, target)
			target.loc = holder
			target.transforming=0 //mob is safely inside holder now, no need for protection.
			jaunt_steam(mobloc)
			sleep(duration)
			mobloc = holder.last_valid_turf
			animation.loc = mobloc
			jaunt_steam(mobloc)
			target.canmove = 0
			holder.reappearing = 1
			sleep(20)
			jaunt_reappear(animation, target)
			sleep(5)
			if(!target.forceMove(mobloc))
				for(var/direction in list(1,2,4,8,5,6,9,10))
					var/turf/T = get_step(mobloc, direction)
					if(T)
						if(target.forceMove(T))
							break
			target.canmove = 1
			target.client.eye = target
			qdel(animation)
			qdel(holder)


/spell/targeted/ethereal_jaunt/empower_spell()
	if(!..())
		return 0
	duration += 20

	return "[src] now lasts longer."

/spell/targeted/ethereal_jaunt/proc/jaunt_disappear(var/atom/movable/overlay/animation, var/mob/living/target)
	animation.icon_state = "liquify"
	flick("liquify",animation)

/spell/targeted/ethereal_jaunt/proc/jaunt_reappear(var/atom/movable/overlay/animation, var/mob/living/target)
	flick("reappear",animation)

/spell/targeted/ethereal_jaunt/proc/jaunt_steam(var/mobloc)
	var/datum/effect/effect/system/steam_spread/steam = new /datum/effect/effect/system/steam_spread()
	steam.set_up(10, 0, mobloc)
	steam.start()

/obj/effect/dummy/spell_jaunt
	name = "water"
	icon = 'icons/effects/effects.dmi'
	icon_state = "nothing"
	var/canmove = 1
	var/reappearing = 0
	density = 0
	anchored = 1
	var/turf/last_valid_turf

/obj/effect/dummy/spell_jaunt/New(var/location)
	..()
	last_valid_turf = get_turf(location)

/obj/effect/dummy/spell_jaunt/Destroy()
	// Eject contents if deleted somehow
	for(var/atom/movable/AM in src)
		AM.loc = get_turf(src)
	return ..()

/obj/effect/dummy/spell_jaunt/relaymove(var/mob/user, direction)
	if (!src.canmove || reappearing) return
	var/turf/newLoc = get_step(src,direction)
	if(!(newLoc.flags & NOJAUNT))
		loc = newLoc
		var/turf/T = get_turf(loc)
		if(!T.contains_dense_objects())
			last_valid_turf = T
	else
		user << "<span class='warning'>Some strange aura is blocking the way!</span>"
	src.canmove = 0
	spawn(2) src.canmove = 1

/obj/effect/dummy/spell_jaunt/ex_act(blah)
	return
/obj/effect/dummy/spell_jaunt/bullet_act(blah)
	return