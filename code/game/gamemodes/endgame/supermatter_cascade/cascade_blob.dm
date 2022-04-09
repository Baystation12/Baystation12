// QUALITY COPYPASTA
/turf/unsimulated/wall/supermatter
	name = "Bluespace"
	desc = "THE END IS right now actually."

	icon = 'icons/turf/space.dmi'
	icon_state = "bluespace"

	//luminosity = 5
	//l_color="#0066ff"
	plane = EFFECTS_ABOVE_LIGHTING_PLANE
	layer = SUPERMATTER_WALL_LAYER

	var/list/avail_dirs = list(NORTH,SOUTH,EAST,WEST,UP,DOWN)

/turf/unsimulated/wall/supermatter/New()
	..()
	START_PROCESSING(SSturf, src)

	// Nom.
	for(var/atom/movable/A in src)
		Consume(A)

/turf/unsimulated/wall/supermatter/Destroy()
	STOP_PROCESSING(SSturf, src)	
	. = ..()

/turf/unsimulated/wall/supermatter/Process(wait, times_fired)
	// Only check infrequently.
	var/how_often = max(round(5 SECONDS/wait), 1)
	if(times_fired % how_often)
		return

	// No more available directions? Stop processing.
	if(!avail_dirs.len)
		return PROCESS_KILL

	// Choose a direction.
	var/pdir = pick(avail_dirs)
	avail_dirs -= pdir
	var/turf/T = get_zstep(src,pdir)

	// EXPAND
	if(T && !istype(T,type))
		// Do pretty fadeout animation for 1s.
		new /obj/effect/overlay/bluespacify(T)
		spawn(1 SECOND)
			if(istype(T,type)) // In case another blob came first, don't create another blob
				return
			T.ChangeTurf(type)

/turf/unsimulated/wall/supermatter/attack_robot(mob/user as mob)
	if(Adjacent(user))
		return attack_hand(user)
	else
		user.examinate(src)

// /vg/: Don't let ghosts fuck with this.
/turf/unsimulated/wall/supermatter/attack_ghost(mob/user as mob)
	user.examinate(src)

/turf/unsimulated/wall/supermatter/attack_ai(mob/user as mob)
	user.examinate(src)

/turf/unsimulated/wall/supermatter/attack_hand(mob/user as mob)
	user.visible_message("<span class=\"warning\">\The [user] reaches out and touches \the [src]... And then blinks out of existance.</span>",\
		"<span class=\"danger\">You reach out and touch \the [src]. Everything immediately goes quiet. Your last thought is \"That was not a wise decision.\"</span>",\
		"<span class=\"warning\">You hear an unearthly noise.</span>")

	playsound(src, 'sound/effects/supermatter.ogg', 50, 1)

	Consume(user)

/turf/unsimulated/wall/supermatter/attackby(obj/item/W as obj, mob/living/user as mob)
	user.visible_message("<span class=\"warning\">\The [user] touches \a [W] to \the [src] as a silence fills the room...</span>",\
		"<span class=\"danger\">You touch \the [W] to \the [src] when everything suddenly goes silent.\"</span>\n<span class=\"notice\">\The [W] flashes into dust as you flinch away from \the [src].</span>",\
		"<span class=\"warning\">Everything suddenly goes silent.</span>")

	playsound(src, 'sound/effects/supermatter.ogg', 50, 1)

	user.drop_from_inventory(W)
	Consume(W)

#define MayConsume(A) (istype(A) && A.simulated && !isobserver(A))

/turf/unsimulated/wall/supermatter/Bumped(var/atom/movable/AM)
	if(!MayConsume(AM))
		return

	if(istype(AM, /mob/living))
		AM.visible_message("<span class=\"warning\">\The [AM] slams into \the [src] inducing a resonance... \his body starts to glow and catch flame before flashing into ash.</span>",\
		"<span class=\"danger\">You slam into \the [src] as your ears are filled with unearthly ringing. Your last thought is \"Oh, fuck.\"</span>",\
		"<span class=\"warning\">You hear an unearthly noise as a wave of heat washes over you.</span>")
	else
		AM.visible_message("<span class=\"warning\">\The [AM] smacks into \the [src] and rapidly flashes to ash.</span>",\
		"<span class=\"warning\">You hear a loud crack as you are washed with a wave of heat.</span>")

	playsound(src, 'sound/effects/supermatter.ogg', 50, 1)
	Consume(AM)

/turf/unsimulated/wall/supermatter/Entered(var/atom/movable/AM)
	Bumped(AM)

/turf/unsimulated/wall/supermatter/proc/Consume(var/atom/movable/AM)
	if(MayConsume(AM))
		qdel(AM)

#undef MayConsume
