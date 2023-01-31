/** # Beam Datum and Effect
 * **IF YOU ARE LAZY AND DO NOT WANT TO READ, GO TO THE BOTTOM OF THE FILE AND USE THAT PROC!**
 *
 * This is the beam datum! It's a really neat effect for the game in drawing a line from one atom to another.
 * It has two parts:
 * The datum itself which manages redrawing the beam to constantly keep it pointing from the origin to the target.
 * The effect which is what the beams are made out of. They're placed in a line from the origin to target, rotated towards the target and snipped off at the end.
 * These effects are kept in a list and constantly created and destroyed (hence the proc names draw and reset, reset destroying all effects and draw creating more.)
 *
 * You can add more special effects to the beam itself by changing what the drawn beam effects do. For example you can make a vine that pricks people by making the beam_type
 * include a crossed proc that damages the crosser. Examples check tg's venus_human_trap.dm
*/
/datum/beam
	///where the beam goes from
	var/atom/origin = null
	///where the beam goes to
	var/atom/target = null
	///list of beam objects. These have their visuals set by the visuals var which is created on starting
	var/list/elements = list()
	///icon used by the beam.
	var/icon
	///icon state of the main segments of the beam
	var/icon_state = ""
	///The beam will qdel if it's longer than this many tiles.
	var/max_distance = 0
	///the objects placed in the elements list
	var/beam_type = /obj/effect/ebeam
	///This is used as the visual_contents of beams, so you can apply one effect to this and the whole beam will look like that. never gets deleted on redrawing.
	var/obj/effect/ebeam/visuals

/datum/beam/New(beam_origin,beam_target,beam_icon='icons/effects/beam.dmi',beam_icon_state="b_beam",time=INFINITY,maxdistance=INFINITY,btype = /obj/effect/ebeam)
	origin = beam_origin
	target = beam_target
	max_distance = maxdistance
	icon = beam_icon
	icon_state = beam_icon_state
	beam_type = btype
	if(time < INFINITY)
		QDEL_IN(src, time)

/**
 * Proc called by the atom Beam() proc. Sets up signals, and draws the beam for the first time.
 */
/datum/beam/proc/Start()
	visuals = new beam_type()
	visuals.icon = icon
	visuals.icon_state = icon_state
	Draw()
	//Register for movement events
	GLOB.moved_event.register(origin, src, .proc/redrawing)
	GLOB.moved_event.register(target, src, .proc/redrawing)
	GLOB.destroyed_event.register(origin, src, .proc/redrawing)
	GLOB.destroyed_event.register(target, src, .proc/redrawing)

/**
 * Triggered by events set up when the beam is set up. If it's still sane to create a beam, it removes the old beam, creates a new one. Otherwise it kills the beam.
 *
 * Arguments:
 * - mover: either the origin of the beam or the target of the beam that moved.
 * - oldloc: from where mover moved.
 * - direction: in what direction mover moved from.
 */
/datum/beam/proc/redrawing(atom/movable/mover, atom/oldloc, new_loc)
	if(!QDELETED(origin) && !QDELETED(target) && get_dist(origin,target)<max_distance && origin.z == target.z)
		QDEL_NULL_LIST(elements)
		invoke_async(src, .proc/Draw)
	else
		qdel(src)

/datum/beam/Destroy()
	QDEL_NULL_LIST(elements)
	QDEL_NULL(visuals)
	GLOB.moved_event.unregister(origin, src, .proc/redrawing)
	GLOB.moved_event.unregister(target, src, .proc/redrawing)
	GLOB.destroyed_event.unregister(origin, src, .proc/redrawing)
	GLOB.destroyed_event.unregister(target, src, .proc/redrawing)
	target = null
	origin = null
	return ..()

/**
 * Creates the beam effects and places them in a line from the origin to the target. Sets their rotation to make the beams face the target, too.
 */
/datum/beam/proc/Draw()
	LAZYINITLIST(elements)
	var/Angle = round(Get_Angle(origin,target))
	var/turf/origin_turf = get_turf(origin)
	//Translation vector for origin and target
	var/DX = (32*target.x+target.pixel_x)-(32*origin.x+origin.pixel_x)
	var/DY = (32*target.y+target.pixel_y)-(32*origin.y+origin.pixel_y)
	var/N = 0
	var/length = round(sqrt((DX)**2+(DY)**2)) //hypotenuse of the triangle formed by target and origin's displacement

	for(N in 0 to length-1 step 32)//-1 as we want < not <=, but we want the speed of X in Y to Z and step X
		if(QDELETED(src))
			break
		var/obj/effect/ebeam/X = new beam_type(origin_turf)
		X.owner = src
		elements += X

		//Assign our single visual ebeam to each ebeam's vis_contents
		//ends are cropped by a transparent box icon of length-N pixel size laid over the visuals obj
		if(N+32>length) //went past the target, we draw a box of space to cut away from the beam sprite so the icon actually ends at the center of the target sprite
			var/icon/II = new(icon, icon_state)//this means we exclude the overshooting object from the visual contents which does mean those visuals don't show up for the final bit of the beam...
			II.DrawBox(null,1,(length-N),32,32)//in the future if you want to improve this, remove the drawbox and instead use a 513 filter to cut away at the final object's icon
			X.icon = II
		else
			X.vis_contents += visuals
		X.SetTransform(rotation = Angle)

		//Calculate pixel offsets (If necessary)
		var/Pixel_x
		var/Pixel_y
		if(DX == 0)
			Pixel_x = 0
		else
			Pixel_x = round(sin(Angle)+32*sin(Angle)*(N+16)/32)
		if(DY == 0)
			Pixel_y = 0
		else
			Pixel_y = round(cos(Angle)+32*cos(Angle)*(N+16)/32)

		//Position the effect so the beam is one continous line
		var/a
		if(abs(Pixel_x)>32)
			a = Pixel_x > 0 ? round(Pixel_x/32) : Ceilm(Pixel_x/32, 1)
			X.x += a
			Pixel_x %= 32
		if(abs(Pixel_y)>32)
			a = Pixel_y > 0 ? round(Pixel_y/32) : Ceilm(Pixel_y/32, 1)
			X.y += a
			Pixel_y %= 32

		X.pixel_x = Pixel_x
		X.pixel_y = Pixel_y
		CHECK_TICK

/obj/effect/ebeam
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
	anchored = TRUE
	var/datum/beam/owner

/obj/effect/ebeam/Destroy()
	owner = null
	return ..()

/obj/effect/ebeam/singularity_pull()
	return
/obj/effect/ebeam/singularity_act()
	return

/**
 * This is what you use to start a beam. Example: origin.Beam(target, args). **Store the return of this proc if you don't set maxdist or time, you need it to delete the beam.**
 *
 * Unless you're making a custom beam effect (see the beam_type argument), you won't actually have to mess with any other procs. Make sure you store the return of this Proc, you'll need it
 * to kill the beam.
 * **Arguments:**
 * - BeamTarget: Where you're beaming from. Where do you get origin? You didn't read the docs, fuck you.
 * - icon_state: What the beam's icon_state is. The datum effect isn't the ebeam object, it doesn't hold any icon and isn't type dependent.
 * - icon: What the beam's icon file is. Don't change this, man. All beam icons should be in beam.dmi anyways.
 * - maxdistance: how far the beam will go before stopping itself. Used mainly for two things: preventing lag if the beam may go in that direction and setting a range to abilities that use beams.
 * - beam_type: The type of your custom beam. This is for adding other wacky stuff for your beam only. Most likely, you won't (and shouldn't) change it.
 */
/atom/proc/Beam(atom/BeamTarget,icon_state="b_beam",icon='icons/effects/beam.dmi',time=INFINITY,maxdistance=INFINITY,beam_type=/obj/effect/ebeam)
	var/datum/beam/newbeam = new(src,BeamTarget,icon,icon_state,time,maxdistance,beam_type)
	invoke_async(newbeam, /datum/beam/.proc/Start)
	return newbeam
