//Meteor groups, used for various random events and the Meteor gamemode.

// Dust, used by space dust event and during earliest stages of meteor mode.
var/global/list/meteors_dust = list(/obj/meteor/dust)

// Standard meteors, used during early stages of the meteor gamemode.
var/global/list/meteors_normal = list(\
		/obj/meteor/medium=8,\
		/obj/meteor/dust=3,\
		/obj/meteor/irradiated=3,\
		/obj/meteor/big=3,\
		/obj/meteor/flaming=1,\
		/obj/meteor/golden=1,\
		/obj/meteor/silver=1\
		)

// Threatening meteors, used during the meteor gamemode.
var/global/list/meteors_threatening = list(\
		/obj/meteor/big=10,\
		/obj/meteor/medium=5,\
		/obj/meteor/golden=3,\
		/obj/meteor/silver=3,\
		/obj/meteor/flaming=3,\
		/obj/meteor/irradiated=3,\
		/obj/meteor/emp=3\
		)

// Catastrophic meteors, pretty dangerous without shields and used during the meteor gamemode.
var/global/list/meteors_catastrophic = list(\
		/obj/meteor/big=75,\
		/obj/meteor/flaming=10,\
		/obj/meteor/irradiated=10,\
		/obj/meteor/emp=10,\
		/obj/meteor/medium=5,\
		/obj/meteor/golden=4,\
		/obj/meteor/silver=4,\
		/obj/meteor/tunguska=1\
		)

// Armageddon meteors, very dangerous, and currently used only during the meteor gamemode.
var/global/list/meteors_armageddon = list(\
		/obj/meteor/big=25,\
		/obj/meteor/flaming=10,\
		/obj/meteor/irradiated=10,\
		/obj/meteor/emp=10,\
		/obj/meteor/medium=3,\
		/obj/meteor/tunguska=3,\
		/obj/meteor/golden=2,\
		/obj/meteor/silver=2\
		)

// Cataclysm meteor selection. Very very dangerous and effective even against shields. Used in late game meteor gamemode only.
var/global/list/meteors_cataclysm = list(\
		/obj/meteor/big=40,\
		/obj/meteor/emp=20,\
		/obj/meteor/tunguska=20,\
		/obj/meteor/irradiated=10,\
		/obj/meteor/golden=10,\
		/obj/meteor/silver=10,\
		/obj/meteor/flaming=10,\
		/obj/meteor/supermatter=1\
		)



///////////////////////////////
//Meteor spawning global procs
///////////////////////////////

/proc/spawn_meteors(number = 10, list/meteortypes, startSide, zlevel)
	for(var/i = 0; i < number; i++)
		spawn_meteor(meteortypes, startSide, zlevel)

/proc/spawn_meteor(list/meteortypes, startSide, zlevel)
	var/turf/pickedstart = spaceDebrisStartLoc(startSide, zlevel)
	var/turf/pickedgoal = spaceDebrisFinishLoc(startSide, zlevel)

	var/Me = pickweight(meteortypes)
	var/obj/meteor/M = new Me(pickedstart)
	M.dest = pickedgoal
	spawn(0)
		walk_towards(M, M.dest, 3)
	return

/proc/spaceDebrisStartLoc(startSide, Z)
	RETURN_TYPE(/turf)
	var/starty
	var/startx
	switch(startSide)
		if(NORTH)
			starty = world.maxy-(TRANSITIONEDGE+1)
			startx = rand((TRANSITIONEDGE+1), world.maxx-(TRANSITIONEDGE+1))
		if(EAST)
			starty = rand((TRANSITIONEDGE+1),world.maxy-(TRANSITIONEDGE+1))
			startx = world.maxx-(TRANSITIONEDGE+1)
		if(SOUTH)
			starty = (TRANSITIONEDGE+1)
			startx = rand((TRANSITIONEDGE+1), world.maxx-(TRANSITIONEDGE+1))
		if(WEST)
			starty = rand((TRANSITIONEDGE+1), world.maxy-(TRANSITIONEDGE+1))
			startx = (TRANSITIONEDGE+1)
	var/turf/T = locate(startx, starty, Z)
	return T

/proc/spaceDebrisFinishLoc(startSide, Z)
	RETURN_TYPE(/turf)
	var/endy
	var/endx
	switch(startSide)
		if(NORTH)
			endy = TRANSITIONEDGE
			endx = rand(TRANSITIONEDGE, world.maxx-TRANSITIONEDGE)
		if(EAST)
			endy = rand(TRANSITIONEDGE, world.maxy-TRANSITIONEDGE)
			endx = TRANSITIONEDGE
		if(SOUTH)
			endy = world.maxy-TRANSITIONEDGE
			endx = rand(TRANSITIONEDGE, world.maxx-TRANSITIONEDGE)
		if(WEST)
			endy = rand(TRANSITIONEDGE,world.maxy-TRANSITIONEDGE)
			endx = world.maxx-TRANSITIONEDGE
	var/turf/T = locate(endx, endy, Z)
	return T

///////////////////////
//The meteor effect
//////////////////////

/obj/meteor
	name = "the concept of meteor"
	desc = "You should probably run instead of gawking at this."
	icon = 'icons/obj/meteor.dmi'
	icon_state = "small"
	density = TRUE
	anchored = TRUE
	var/hits = 4
	var/hitpwr = EX_ACT_HEAVY //Level of ex_act to be called on hit.
	var/dest
	pass_flags = PASS_FLAG_TABLE
	var/heavy = 0
	var/z_original
	var/meteordrop = /obj/item/ore/iron
	var/dropamt = 1
	var/ismissile //missiles don't spin

	var/move_count = 0

/obj/meteor/proc/get_shield_damage()
	return max(((max(hits, 2)) * (heavy + 1) * rand(30, 60)) / hitpwr , 0)

/obj/meteor/New()
	..()
	z_original = z

/obj/meteor/Initialize()
	. = ..()
	GLOB.meteor_list += src

/obj/meteor/Move()
	. = ..() //process movement...
	move_count++
	if(loc == dest)
		qdel(src)

/obj/meteor/touch_map_edge()
	if(move_count > TRANSITIONEDGE)
		qdel(src)

/obj/meteor/Destroy()
	walk(src,0) //this cancels the walk_towards() proc
	GLOB.meteor_list -= src
	return ..()

/obj/meteor/Initialize()
	. = ..()
	if (!ismissile)
		SpinAnimation()

/obj/meteor/Bump(atom/A)
	..()
	if(A && !QDELETED(src))	// Prevents explosions and other effects when we were deleted by whatever we Bumped() - currently used by shields.
		ram_turf(get_turf(A))
		get_hit() //should only get hit once per move attempt

/obj/meteor/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	return istype(mover, /obj/meteor) ? 1 : ..()

/obj/meteor/proc/ram_turf(turf/T)
	//first bust whatever is in the turf
	for(var/atom/A in T)
		if(A != src && !A.CanPass(src, src.loc, 0.5, 0)) //only ram stuff that would actually block us
			A.ex_act(hitpwr)

	//then, ram the turf if it still exists
	if(T && !T.CanPass(src, src.loc, 0.5, 0))
		T.ex_act(hitpwr, TRUE)

//process getting 'hit' by colliding with a dense object
//or randomly when ramming turfs
/obj/meteor/proc/get_hit()
	hits--
	if(hits <= 0)
		make_debris()
		meteor_effect()
		qdel(src)

/obj/meteor/ex_act()
	return


/obj/meteor/use_tool(obj/item/tool, mob/user, list/click_params)
	// Pickaxe - Delete meteor
	if (istype(tool, /obj/item/pickaxe))
		user.visible_message(
			SPAN_WARNING("\The [user] hits \the [src] with \a [tool], breaking it apart!"),
			SPAN_WARNING("You hit \the [src] with \the [tool], breaking it apart!")
		)
		qdel(src)
		return TRUE

	return ..()


/obj/meteor/proc/make_debris()
	for(var/throws = dropamt, throws > 0, throws--)
		var/obj/item/O = new meteordrop(get_turf(src))
		O.throw_at(dest, 5, 10)

/obj/meteor/proc/meteor_effect()
	if(heavy)
		for(var/mob/M in GLOB.player_list)
			var/turf/T = get_turf(M)
			if(!T || T.z != src.z)
				continue
			var/dist = get_dist(M.loc, src.loc)
			shake_camera(M, dist > 20 ? 3 : 5, dist > 20 ? 1 : 3)


///////////////////////
//Meteor types
///////////////////////

//Dust
/obj/meteor/dust
	name = "space dust"
	icon_state = "dust"
	pass_flags = PASS_FLAG_TABLE | PASS_FLAG_GRILLE
	hits = 1
	hitpwr = EX_ACT_LIGHT
	dropamt = 1
	meteordrop = /obj/item/ore/glass

//Medium-sized
/obj/meteor/medium
	name = "meteor"
	dropamt = 2

/obj/meteor/medium/meteor_effect()
	..()
	explosion(src.loc, 3, EX_ACT_HEAVY, 0, turf_breaker = TRUE)

//Large-sized
/obj/meteor/big
	name = "large meteor"
	icon_state = "large"
	hits = 6
	heavy = 1
	dropamt = 3

/obj/meteor/big/meteor_effect()
	..()
	explosion(src.loc, 6, adminlog = 0, turf_breaker = TRUE)

//Flaming meteor
/obj/meteor/flaming
	name = "flaming meteor"
	icon_state = "flaming"
	hits = 5
	heavy = 1
	meteordrop = /obj/item/ore/phoron

/obj/meteor/flaming/meteor_effect()
	..()
	explosion(src.loc, 6, adminlog = 0, z_transfer = 0, shaped = 5, turf_breaker = TRUE)

//Radiation meteor
/obj/meteor/irradiated
	name = "glowing meteor"
	icon_state = "glowing"
	heavy = 1
	meteordrop = /obj/item/ore/uranium

/obj/meteor/irradiated/meteor_effect()
	..()
	explosion(src.loc, 4, EX_ACT_LIGHT, 0, turf_breaker = TRUE)
	new /obj/decal/cleanable/greenglow(get_turf(src))
	SSradiation.radiate(src, 50)

/obj/meteor/golden
	name = "golden meteor"
	icon_state = "glowing"
	desc = "Shiny! But also deadly."
	meteordrop = /obj/item/ore/gold

/obj/meteor/silver
	name = "silver meteor"
	icon_state = "glowing_blue"
	desc = "Shiny! But also deadly."
	meteordrop = /obj/item/ore/silver

/obj/meteor/emp
	name = "conducting meteor"
	icon_state = "glowing_blue"
	desc = "Hide your floppies!"
	meteordrop = /obj/item/ore/osmium
	dropamt = 2

/obj/meteor/emp/meteor_effect()
	..()
	// Best case scenario: Comparable to a low-yield EMP grenade.
	// Worst case scenario: Comparable to a standard yield EMP grenade.
	empulse(src, rand(2, 4), rand(4, 10))

/obj/meteor/emp/get_shield_damage()
	return ..() * rand(2,4)

//Station buster Tunguska
/obj/meteor/tunguska
	name = "tunguska meteor"
	icon_state = "flaming"
	desc = "Your life briefly passes before your eyes the moment you lay them on this monstrosity."
	hits = 10
	hitpwr = EX_ACT_DEVASTATING
	heavy = 1
	meteordrop = /obj/item/ore/diamond	// Probably means why it penetrates the hull so easily before exploding.

/obj/meteor/tunguska/meteor_effect()
	..()
	explosion(src.loc, 18, adminlog = 0, turf_breaker = TRUE)

// This is the final solution against shields - a single impact can bring down most shield generators.
/obj/meteor/supermatter
	name = "supermatter shard"
	desc = "Oh god, what will be next..?"
	icon = 'icons/obj/machines/power/supermatter.dmi'
	icon_state = "darkmatter_old"

/obj/meteor/supermatter/meteor_effect()
	..()
	explosion(src.loc, 6, adminlog = 0, turf_breaker = TRUE)
	for(var/obj/machinery/power/apc/A in range(rand(12, 20), src))
		A.energy_fail(round(10 * rand(8, 12)))

/obj/meteor/supermatter/get_shield_damage()
	return ..() * rand(80, 120)

//Missiles, for events and so on
/obj/meteor/supermatter/missile
	name = "photon torpedo"
	desc = "An advanded warhead designed to tactically destroy space installations."
	icon = 'icons/obj/missile.dmi'
	icon_state = "photon"
	meteordrop = null
	ismissile = TRUE
	dropamt = 0

/obj/meteor/medium/missile
	name = "missile"
	desc = "Some kind of missile."
	icon = 'icons/obj/missile.dmi'
	icon_state = "missile"
	meteordrop = null
	ismissile = TRUE
	dropamt = 0

/obj/meteor/big/missile
	name = "high-yield missile"
	desc = "Some kind of missile."
	icon = 'icons/obj/missile.dmi'
	icon_state = "missile"
	meteordrop = null
	ismissile = TRUE
	dropamt = 0

/obj/meteor/flaming/missile
	name = "incendiary missile"
	desc = "Some kind of missile."
	icon = 'icons/obj/missile.dmi'
	icon_state = "missile"
	meteordrop = null
	ismissile = TRUE
	dropamt = 0

/obj/meteor/emp/missile
	name = "ion torpedo"
	desc = "Some kind of missile."
	icon = 'icons/obj/missile.dmi'
	icon_state = "torpedo"
	meteordrop = null
	ismissile = TRUE
	dropamt = 0

/obj/meteor/supermatter/missile/admin_missile
	name = "Hull Buster"
	desc = "A highly advanced warhead capable of destroying even the most well-armoured space installations."
	icon = 'icons/obj/missile.dmi'
	icon_state = "photon"
	meteordrop = null
	ismissile = TRUE
	hitpwr = EX_ACT_DEVASTATING
	hits = 6

/obj/meteor/supermatter/missile/admin_missile/meteor_effect()
	explosion(loc, 7, adminlog = 0, shaped = get_dir(src, dest), turf_breaker = TRUE)


/obj/meteor/supermatter/missile/sabot_round
	name = "Sabot Round"
	desc = "A warhead that penetrates the hull and detonates to send a secondary warhead further in before exploding for massive damage."
	icon = 'icons/obj/missile.dmi'
	icon_state = "sabot"
	meteordrop = null
	ismissile = TRUE
	hitpwr = EX_ACT_HEAVY
	hits = 6

/obj/meteor/supermatter/missile/sabot_round/meteor_effect()
	explosion(loc, 5, EX_ACT_LIGHT, 0, shaped = TRUE, turf_breaker = TRUE)
	var/obj/meteor/supermatter/missile/sabot_secondary_round/M = new(get_turf(src))
	M.dest = dest
	spawn(0)
		walk_towards(M, dest, 3)

/obj/meteor/supermatter/missile/sabot_secondary_round
	name = "Sabot Round Secondary"
	desc = "Secondary warhead of the Sabot Round, causes extreme damage."
	icon = 'icons/obj/missile.dmi'
	icon_state = "sabot_2"
	meteordrop = null
	ismissile = TRUE
	hitpwr = EX_ACT_DEVASTATING
	hits = 4

/obj/meteor/supermatter/missile/sabot_secondary_round/meteor_effect()
	explosion(loc, 6, shaped = get_dir(src, dest), turf_breaker = TRUE)
