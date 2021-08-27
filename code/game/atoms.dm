/atom
	var/level = 2
	var/atom_flags = ATOM_FLAG_NO_TEMP_CHANGE
	var/list/blood_DNA
	var/was_bloodied
	var/blood_color
	var/last_bumped = 0
	var/pass_flags = 0
	var/throwpass = 0
	var/germ_level = GERM_LEVEL_AMBIENT // The higher the germ level, the more germ on the atom.
	var/simulated = TRUE //filter for actions - used by lighting overlays
	var/fluorescent // Shows up under a UV light.
	var/datum/reagents/reagents // chemical contents.
	var/list/climbers
	var/climb_speed_mult = 1
	var/init_flags = EMPTY_BITFIELD

/atom/New(loc, ...)
	//atom creation method that preloads variables at creation
	if(GLOB.use_preloader && (src.type == GLOB._preloader.target_path))//in case the instanciated atom is creating other atoms in New()
		GLOB._preloader.load(src)

	var/do_initialize = SSatoms.atom_init_stage
	var/list/created = SSatoms.created_atoms
	if(do_initialize > INITIALIZATION_INSSATOMS_LATE)
		args[1] = do_initialize == INITIALIZATION_INNEW_MAPLOAD
		if(SSatoms.InitAtom(src, args))
			//we were deleted
			return
	else if(created)
		var/list/argument_list
		if(length(args) > 1)
			argument_list = args.Copy(2)
		if(argument_list || do_initialize == INITIALIZATION_INSSATOMS_LATE)
			created[src] = argument_list

	if(atom_flags & ATOM_FLAG_CLIMBABLE)
		verbs += /atom/proc/climb_on

//Called after New if the map is being loaded. mapload = TRUE
//Called from base of New if the map is not being loaded. mapload = FALSE
//This base must be called or derivatives must set initialized to TRUE
//must not sleep
//Other parameters are passed from New (excluding loc)
//Must return an Initialize hint. Defined in __DEFINES/subsystems.dm

/atom/proc/Initialize(mapload, ...)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	if(atom_flags & ATOM_FLAG_INITIALIZED)
		crash_with("Warning: [src]([type]) initialized multiple times!")
	atom_flags |= ATOM_FLAG_INITIALIZED

	if(light_max_bright && light_outer_range)
		update_light()

	if(opacity)
		updateVisibility(src)
		var/turf/T = loc
		if(istype(T))
			T.RecalculateOpacity()

	if (use_health_handler)
		initialize_health()

	return INITIALIZE_HINT_NORMAL

//called if Initialize returns INITIALIZE_HINT_LATELOAD
/atom/proc/LateInitialize()
	return

/atom/Destroy()
	QDEL_NULL(reagents)
	. = ..()

/atom/proc/reveal_blood()
	return

/atom/proc/MayZoom()
	return TRUE

/atom/proc/assume_air(datum/gas_mixture/giver)
	return null

/atom/proc/remove_air(amount)
	return null

/atom/proc/return_air()
	if(loc)
		return loc.return_air()
	else
		return null

//return flags that should be added to the viewer's sight var.
//Otherwise return a negative number to indicate that the view should be cancelled.
/atom/proc/check_eye(user as mob)
	if (istype(user, /mob/living/silicon/ai)) // WHYYYY
		return 0
	return -1

//Return flags that may be added as part of a mobs sight
/atom/proc/additional_sight_flags()
	return 0

/atom/proc/additional_see_invisible()
	return 0

/atom/proc/on_reagent_change()
	return

/atom/proc/on_color_transfer_reagent_change()
	return

/atom/proc/Bumped(AM as mob|obj)
	return

// Convenience proc to see if a container is open for chemistry handling
// returns true if open
// false if closed
/atom/proc/is_open_container()
	return atom_flags & ATOM_FLAG_OPEN_CONTAINER

/*//Convenience proc to see whether a container can be accessed in a certain way.

	proc/can_subract_container()
		return flags & EXTRACT_CONTAINER

	proc/can_add_container()
		return flags & INSERT_CONTAINER
*/

/atom/proc/CheckExit()
	return 1

// If you want to use this, the atom must have the PROXMOVE flag, and the moving
// atom must also have the PROXMOVE flag currently to help with lag. ~ ComicIronic
/atom/proc/HasProximity(atom/movable/AM as mob|obj)
	return

/atom/proc/emp_act(var/severity)
	return

/atom/proc/set_density(var/new_density)
	if(density != new_density)
		density = !!new_density
		if (isturf(loc))
			var/turf/T = loc
			if (density)
				T.has_dense_atom = TRUE
			else
				T.has_dense_atom = null

/atom/proc/bullet_act(obj/item/projectile/P, def_zone)
	P.on_hit(src, 0, def_zone)
	. = 0

/atom/proc/in_contents_of(container)//can take class or object instance as argument
	if(ispath(container))
		if(istype(src.loc, container))
			return 1
	else if(src in container)
		return 1
	return

/*
 *	atom/proc/search_contents_for(path,list/filter_path=null)
 * Recursevly searches all atom contens (including contents contents and so on).
 *
 * ARGS: path - search atom contents for atoms of this type
 *	   list/filter_path - if set, contents of atoms not of types in this list are excluded from search.
 *
 * RETURNS: list of found atoms
 */

/atom/proc/search_contents_for(path,list/filter_path=null)
	var/list/found = list()
	for(var/atom/A in src)
		if(istype(A, path))
			found += A
		if(filter_path)
			var/pass = 0
			for(var/type in filter_path)
				pass |= istype(A, type)
			if(!pass)
				continue
		if(A.contents.len)
			found += A.search_contents_for(path,filter_path)
	return found




/*
Beam code by Gunbuddy

Beam() proc will only allow one beam to come from a source at a time.  Attempting to call it more than
once at a time per source will cause graphical errors.
Also, the icon used for the beam will have to be vertical and 32x32.
The math involved assumes that the icon is vertical to begin with so unless you want to adjust the math,
its easier to just keep the beam vertical.
*/
/atom/proc/Beam(atom/BeamTarget,icon_state="b_beam",icon='icons/effects/beam.dmi',time=50, maxdistance=10)
	//BeamTarget represents the target for the beam, basically just means the other end.
	//Time is the duration to draw the beam
	//Icon is obviously which icon to use for the beam, default is beam.dmi
	//Icon_state is what icon state is used. Default is b_beam which is a blue beam.
	//Maxdistance is the longest range the beam will persist before it gives up.
	var/EndTime=world.time+time
	while(BeamTarget&&world.time<EndTime&&get_dist(src,BeamTarget)<maxdistance&&z==BeamTarget.z)
	//If the BeamTarget gets deleted, the time expires, or the BeamTarget gets out
	//of range or to another z-level, then the beam will stop.  Otherwise it will
	//continue to draw.

		set_dir(get_dir(src,BeamTarget))	//Causes the source of the beam to rotate to continuosly face the BeamTarget.

		for(var/obj/effect/overlay/beam/O in orange(10,src))	//This section erases the previously drawn beam because I found it was easier to
			if(O.BeamSource==src)				//just draw another instance of the beam instead of trying to manipulate all the
				qdel(O)							//pieces to a new orientation.
		var/Angle=round(Get_Angle(src,BeamTarget))
		var/icon/I=new(icon,icon_state)
		I.Turn(Angle)
		var/DX=(32*BeamTarget.x+BeamTarget.pixel_x)-(32*x+pixel_x)
		var/DY=(32*BeamTarget.y+BeamTarget.pixel_y)-(32*y+pixel_y)
		var/N=0
		var/length=round(sqrt((DX)**2+(DY)**2))
		for(N,N<length,N+=32)
			var/obj/effect/overlay/beam/X=new(loc)
			X.BeamSource=src
			if(N+32>length)
				var/icon/II=new(icon,icon_state)
				II.DrawBox(null,1,(length-N),32,32)
				II.Turn(Angle)
				X.icon=II
			else X.icon=I
			var/Pixel_x=round(sin(Angle)+32*sin(Angle)*(N+16)/32)
			var/Pixel_y=round(cos(Angle)+32*cos(Angle)*(N+16)/32)
			if(DX==0) Pixel_x=0
			if(DY==0) Pixel_y=0
			if(Pixel_x>32)
				for(var/a=0, a<=Pixel_x,a+=32)
					X.x++
					Pixel_x-=32
			if(Pixel_x<-32)
				for(var/a=0, a>=Pixel_x,a-=32)
					X.x--
					Pixel_x+=32
			if(Pixel_y>32)
				for(var/a=0, a<=Pixel_y,a+=32)
					X.y++
					Pixel_y-=32
			if(Pixel_y<-32)
				for(var/a=0, a>=Pixel_y,a-=32)
					X.y--
					Pixel_y+=32
			X.pixel_x=Pixel_x
			X.pixel_y=Pixel_y
		sleep(3)	//Changing this to a lower value will cause the beam to follow more smoothly with movement, but it will also be more laggy.
					//I've found that 3 ticks provided a nice balance for my use.
	for(var/obj/effect/overlay/beam/O in orange(10,src)) if(O.BeamSource==src) qdel(O)


// A type overriding /examine() should either return the result of ..() or return TRUE if not calling ..()
// Calls to ..() should generally not supply any arguments and instead rely on BYOND's automatic argument passing
// There is no need to check the return value of ..(), this is only done by the calling /examinate() proc to validate the call chain
/atom/proc/examine(mob/user, distance, infix = "", suffix = "")
	//This reformat names to get a/an properly working on item descriptions when they are bloody
	var/f_name = "\a [src][infix]."
	if(blood_color && !istype(src, /obj/effect/decal))
		if(gender == PLURAL)
			f_name = "some "
		else
			f_name = "a "
		f_name += "<font color ='[blood_color]'>stained</font> [name][infix]!"

	to_chat(user, "[icon2html(src, user)] That's [f_name] [suffix]")
	to_chat(user, desc)
	return TRUE

// called by mobs when e.g. having the atom as their machine, pulledby, loc (AKA mob being inside the atom) or buckled var set.
// see code/modules/mob/mob_movement.dm for more.
/atom/proc/relaymove()
	return

//called to set the atom's dir and used to add behaviour to dir-changes
/atom/proc/set_dir(new_dir)
	var/old_dir = dir
	if(new_dir == old_dir)
		return FALSE
	dir = new_dir
	return TRUE

/atom/proc/set_icon_state(var/new_icon_state)
	if(has_extension(src, /datum/extension/base_icon_state))
		var/datum/extension/base_icon_state/bis = get_extension(src, /datum/extension/base_icon_state)
		bis.base_icon_state = new_icon_state
		update_icon()
	else
		icon_state = new_icon_state

/atom/proc/update_icon()
	on_update_icon(arglist(args))

/atom/proc/on_update_icon()
	return

/atom/proc/ex_act()
	return

/atom/proc/emag_act(var/remaining_charges, var/mob/user, var/emag_source)
	return NO_EMAG_ACT

/atom/proc/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	return

/atom/proc/melt()
	return

/atom/proc/lava_act()
	visible_message("<span class='danger'>\The [src] sizzles and melts away, consumed by the lava!</span>")
	playsound(src, 'sound/effects/flare.ogg', 100, 3)
	qdel(src)
	. = TRUE

/atom/proc/hitby(atom/movable/AM, var/datum/thrownthing/TT)//already handled by throw impact
	if(isliving(AM))
		var/mob/living/M = AM
		M.apply_damage(TT.speed*5, BRUTE)

//returns 1 if made bloody, returns 0 otherwise
/atom/proc/add_blood(mob/living/carbon/human/M as mob)
	if(atom_flags & ATOM_FLAG_NO_BLOOD)
		return 0

	if(!blood_DNA || !istype(blood_DNA, /list))	//if our list of DNA doesn't exist yet (or isn't a list) initialise it.
		blood_DNA = list()

	was_bloodied = 1
	blood_color = COLOR_BLOOD_HUMAN
	if(istype(M))
		if (!istype(M.dna, /datum/dna))
			M.dna = new /datum/dna(null)
			M.dna.real_name = M.real_name
		M.check_dna()
		blood_color = M.species.get_blood_colour(M)
	. = 1
	return 1

/mob/living/proc/handle_additional_vomit_reagents(var/obj/effect/decal/cleanable/vomit/vomit)
	vomit.reagents.add_reagent(/datum/reagent/acid/stomach, 5)

/atom/proc/clean_blood()
	if(!simulated)
		return
	fluorescent = 0
	germ_level = 0
	blood_color = null
	gunshot_residue = null
	if(istype(blood_DNA, /list))
		blood_DNA = null
		return 1

/atom/proc/get_global_map_pos()
	if (!islist(GLOB.global_map) || !length(GLOB.global_map))
		return
	var/cur_x = null
	var/cur_y = null
	var/list/y_arr = null
	for(cur_x=1,cur_x<=GLOB.global_map.len,cur_x++)
		y_arr = GLOB.global_map[cur_x]
		cur_y = list_find(y_arr, src.z)
		if(cur_y)
			break
//	log_debug("X = [cur_x]; Y = [cur_y]")

	if(cur_x && cur_y)
		return list("x"=cur_x,"y"=cur_y)
	else
		return 0

/atom/proc/checkpass(passflag)
	return pass_flags&passflag

/atom/proc/isinspace()
	if(istype(get_turf(src), /turf/space))
		return 1
	else
		return 0


// Show a message to all mobs and objects in sight of this atom
// Use for objects performing visible actions
// message is output to anyone who can see, e.g. "The [src] does something!"
// blind_message (optional) is what blind people will hear e.g. "You hear something!"
/atom/proc/visible_message(message, blind_message, range = world.view, checkghosts = null, list/exclude_objs = null, list/exclude_mobs = null)
	set waitfor = FALSE
	var/turf/T = get_turf(src)
	var/list/mobs = list()
	var/list/objs = list()
	get_mobs_and_objs_in_view_fast(T,range, mobs, objs, checkghosts)

	for(var/o in objs)
		var/obj/O = o
		if (exclude_objs?.len && (O in exclude_objs))
			exclude_objs -= O
			continue
		O.show_message(message, VISIBLE_MESSAGE, blind_message, AUDIBLE_MESSAGE)

	for(var/m in mobs)
		var/mob/M = m
		if (exclude_mobs?.len && (M in exclude_mobs))
			exclude_mobs -= M
			continue
		if(M.see_invisible >= invisibility)
			M.show_message(message, VISIBLE_MESSAGE, blind_message, AUDIBLE_MESSAGE)
		else if(blind_message)
			M.show_message(blind_message, AUDIBLE_MESSAGE)

// Show a message to all mobs and objects in earshot of this atom
// Use for objects performing audible actions
// message is the message output to anyone who can hear.
// deaf_message (optional) is what deaf people will see.
// hearing_distance (optional) is the range, how many tiles away the message can be heard.
/atom/proc/audible_message(message, deaf_message, hearing_distance = world.view, checkghosts = null, list/exclude_objs = null, list/exclude_mobs = null)
	var/turf/T = get_turf(src)
	var/list/mobs = list()
	var/list/objs = list()
	get_mobs_and_objs_in_view_fast(T, hearing_distance, mobs, objs, checkghosts)

	for(var/m in mobs)
		var/mob/M = m
		if (exclude_mobs?.len && (M in exclude_mobs))
			exclude_mobs -= M
			continue
		M.show_message(message,2,deaf_message,1)

	for(var/o in objs)
		var/obj/O = o
		if (exclude_objs?.len && (O in exclude_objs))
			exclude_objs -= O
			continue
		O.show_message(message,2,deaf_message,1)

/atom/movable/proc/dropInto(var/atom/destination)
	while(istype(destination))
		var/atom/drop_destination = destination.onDropInto(src)
		if(!istype(drop_destination) || drop_destination == destination)
			return forceMove(destination)
		destination = drop_destination
	return forceMove(null)

/atom/proc/onDropInto(var/atom/movable/AM)
	return // If onDropInto returns null, then dropInto will forceMove AM into us.

/atom/movable/onDropInto(var/atom/movable/AM)
	return loc // If onDropInto returns something, then dropInto will attempt to drop AM there.

/atom/proc/InsertedContents()
	return contents

//all things climbable

/atom/attack_hand(mob/user)
	..()
	if(LAZYLEN(climbers) && !(user in climbers))
		user.visible_message("<span class='warning'>[user.name] shakes \the [src].</span>", \
					"<span class='notice'>You shake \the [src].</span>")
		object_shaken()

// Called when hitting the atom with a grab.
// Will skip attackby() and afterattack() if returning TRUE.
/atom/proc/grab_attack(var/obj/item/grab/G)
	return FALSE

/atom/proc/climb_on()

	set name = "Climb"
	set desc = "Climbs onto an object."
	set category = "Object"
	set src in oview(1)

	do_climb(usr)

/atom/proc/can_climb(var/mob/living/user, post_climb_check=FALSE, check_silicon=TRUE)
	if (!(atom_flags & ATOM_FLAG_CLIMBABLE) || !can_touch(user, check_silicon) || (!post_climb_check && climbers && (user in climbers)))
		return 0

	if (!user.Adjacent(src))
		to_chat(user, "<span class='danger'>You can't climb there, the way is blocked.</span>")
		return 0

	var/obj/occupied = turf_is_crowded(user)
	//because Adjacent() has exceptions for windows, those must be handled here
	if(!occupied && istype(src, /obj/structure/wall_frame))
		var/original_dir = get_dir(src, user.loc)
		var/progress_dir = original_dir
		for(var/atom/A in loc.contents)
			if(A.atom_flags & ATOM_FLAG_CHECKS_BORDER)
				var/obj/structure/window/W = A
				if(istype(W))
					//progressively check if a window matches the X or Y component of the dir, if collision, set the dir bit off
					if(W.is_fulltile() || (progress_dir &= ~W.dir) == 0) //if dir components are 0, fully blocked on diagonal
						occupied = A
						break
		//if true, means one dir was blocked and bit set off, so check the unblocked
		if(progress_dir != original_dir && progress_dir != 0)
			var/turf/here = get_turf(src)
			if(!here.Adjacent_free_dir(user, progress_dir))
				to_chat(user, SPAN_DANGER("You can't climb there, the way is blocked."))
				return FALSE

	if(occupied)
		to_chat(user, "<span class='danger'>There's \a [occupied] in the way.</span>")
		return 0
	return 1

/atom/proc/can_touch(var/mob/user, check_silicon=TRUE)
	if (!user)
		return 0
	if(!Adjacent(user))
		return 0
	if (user.restrained() || user.buckled)
		to_chat(user, "<span class='notice'>You need your hands and legs free for this.</span>")
		return 0
	if (user.incapacitated())
		return 0
	if (check_silicon && issilicon(user))
		to_chat(user, "<span class='notice'>You need hands for this.</span>")
		return 0
	return 1

/atom/proc/turf_is_crowded(var/atom/ignore)
	var/turf/T = get_turf(src)
	if(!istype(T))
		return 0
	for(var/atom/A in T.contents)
		if(ignore && ignore == A)
			continue
		if(A.atom_flags & ATOM_FLAG_CLIMBABLE)
			continue
		if(A.density && !(A.atom_flags & ATOM_FLAG_CHECKS_BORDER)) //ON_BORDER structures are handled by the Adjacent() check.
			return A
	return 0

/atom/proc/do_climb(var/mob/living/user, check_silicon=TRUE)
	if (!can_climb(user, check_silicon=check_silicon))
		return 0

	add_fingerprint(user)
	user.visible_message("<span class='warning'>\The [user] starts climbing onto \the [src]!</span>")
	LAZYDISTINCTADD(climbers,user)

	if(!do_after(user,(issmall(user) ? MOB_CLIMB_TIME_SMALL : MOB_CLIMB_TIME_MEDIUM) * climb_speed_mult, src))
		LAZYREMOVE(climbers,user)
		return 0

	if(!can_climb(user, post_climb_check=1, check_silicon=check_silicon))
		LAZYREMOVE(climbers,user)
		return 0

	var/target_turf = get_turf(src)

	//climbing over border objects like railings
	if((atom_flags & ATOM_FLAG_CHECKS_BORDER) && get_turf(user) == target_turf)
		target_turf = get_step(src, dir)

	user.forceMove(target_turf)

	if (get_turf(user) == target_turf)
		user.visible_message("<span class='warning'>\The [user] climbs onto \the [src]!</span>")
	LAZYREMOVE(climbers,user)
	return 1

/atom/proc/object_shaken()
	for(var/mob/living/M in climbers)
		M.Weaken(1)
		to_chat(M, "<span class='danger'>You topple as you are shaken off \the [src]!</span>")
		climbers.Cut(1,2)

	for(var/mob/living/M in get_turf(src))
		if(M.lying) return //No spamming this on people.

		M.Weaken(3)
		to_chat(M, "<span class='danger'>You topple as \the [src] moves under you!</span>")

		if(prob(25))

			var/damage = rand(15,30)
			var/mob/living/carbon/human/H = M
			if(!istype(H))
				to_chat(H, "<span class='danger'>You land heavily!</span>")
				M.adjustBruteLoss(damage)
				return

			var/obj/item/organ/external/affecting
			var/list/limbs = BP_ALL_LIMBS //sanity check, can otherwise be shortened to affecting = pick(BP_ALL_LIMBS)
			if(limbs.len)
				affecting = H.get_organ(pick(limbs))

			if(affecting)
				to_chat(M, "<span class='danger'>You land heavily on your [affecting.name]!</span>")
				affecting.take_external_damage(damage, 0)
				if(affecting.parent)
					affecting.parent.add_autopsy_data("Misadventure", damage)
			else
				to_chat(H, "<span class='danger'>You land heavily!</span>")
				H.adjustBruteLoss(damage)

			H.UpdateDamageIcon()
			H.updatehealth()
	return

/atom/MouseDrop_T(mob/target, mob/user)
	var/mob/living/H = user
	if(istype(H) && can_climb(H) && target == user)
		do_climb(target)
	else
		return ..()

/atom/proc/get_color()
	return isnull(color) ? COLOR_WHITE : color

/atom/proc/set_color(var/color)
	src.color = color

/atom/proc/get_cell()
	return

/atom/proc/slam_into(mob/living/L)
	L.Weaken(2)
	L.visible_message(SPAN_WARNING("\The [L] [pick("ran", "slammed")] into \the [src]!"))
	playsound(L, "punch", 25, 1, FALSE)
