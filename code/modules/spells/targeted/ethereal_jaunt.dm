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
		if(HAS_TRANSFORMATION_MOVEMENT_HANDLER(target))
			continue

		if(target.buckled)
			target.buckled.unbuckle_mob()
		spawn(0)
			var/mobloc = get_turf(target.loc)
			var/obj/effect/dummy/spell_jaunt/holder = new /obj/effect/dummy/spell_jaunt( mobloc )
			var/atom/movable/overlay/animation = new /atom/movable/overlay(holder)
			animation.SetName("water")
			animation.set_density(0)
			animation.anchored = 1
			animation.icon = 'icons/mob/mob.dmi'
			animation.layer = FLY_LAYER 
			target.ExtinguishMob()
			if(target.buckled)
				target.buckled = null
			jaunt_disappear(animation, target)
			target.forceMove(holder)
			jaunt_steam(mobloc)
			sleep(duration)
			mobloc = holder.last_valid_turf
			animation.forceMove(mobloc)
			jaunt_steam(mobloc)
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
	playsound(get_turf(target), 'sound/magic/ethereal_enter.ogg', 30)

/spell/targeted/ethereal_jaunt/proc/jaunt_reappear(var/atom/movable/overlay/animation, var/mob/living/target)
	flick("reappear",animation)
	playsound(get_turf(target), 'sound/magic/ethereal_exit.ogg', 30)

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
		AM.dropInto(loc)
	return ..()

/obj/effect/dummy/spell_jaunt/relaymove(var/mob/user, direction)
	if (!canmove || reappearing) return
	var/turf/newLoc = get_step(src, direction)
	if(!(newLoc.turf_flags & TURF_FLAG_NOJAUNT))
		forceMove(newLoc)
		var/turf/T = get_turf(loc)
		if(!T.contains_dense_objects())
			last_valid_turf = T
	else
		to_chat(user, "<span class='warning'>Some strange aura is blocking the way!</span>")
	canmove = 0
	addtimer(CALLBACK(src, .proc/allow_move), 2)

/obj/effect/dummy/spell_jaunt/proc/allow_move()
	canmove = TRUE

/obj/effect/dummy/spell_jaunt/ex_act(blah)
	return
/obj/effect/dummy/spell_jaunt/bullet_act(blah)
	return

/spell/targeted/ethereal_jaunt/tower
	charge_max = 2
	spell_flags = Z2NOCAST | INCLUDEUSER