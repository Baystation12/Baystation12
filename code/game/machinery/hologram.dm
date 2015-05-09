/* Holograms!
 * Contains:
 *		Holopad
 *		Hologram
 *		Other stuff
 */

/*
Revised. Original based on space ninja hologram code. Which is also mine. /N
How it works:
AI clicks on holopad in camera view. View centers on holopad.
AI clicks again on the holopad to display a hologram. Hologram stays as long as AI is looking at the pad and it (the hologram) is in range of the pad.
AI can use the directional keys to move the hologram around, provided the above conditions are met and the AI in question is the holopad's master.
Only one AI may project from a holopad at any given time.
AI may cancel the hologram at any time by clicking on the holopad once more.

Possible to do for anyone motivated enough:
	Give an AI variable for different hologram icons.
	Itegrate EMP effect to disable the unit.
*/


/*
 * Holopad
 */

#define HOLOPAD_PASSIVE_POWER_USAGE 1
#define HOLOGRAM_POWER_USAGE 2
#define RANGE_BASED 4
#define AREA_BASED 6

var/const/HOLOPAD_MODE = RANGE_BASED

/obj/machinery/hologram/holopad
	name = "\improper AI holopad"
	desc = "It's a floor-mounted device for projecting holographic images. It is activated remotely."
	icon_state = "holopad0"

	layer = TURF_LAYER+0.1 //Preventing mice and drones from sneaking under them.
	
	var/power_per_hologram = 500 //per usage per hologram
	idle_power_usage = 5
	use_power = 1

	var/list/mob/living/silicon/ai/masters = new() //List of AIs that use the holopad
	var/last_request = 0 //to prevent request spam. ~Carn
	var/holo_range = 5 // Change to change how far the AI can move away from the holopad before deactivating.

/obj/machinery/hologram/holopad/attack_hand(var/mob/living/carbon/human/user) //Carn: Hologram requests.
	if(!istype(user))
		return
	if(alert(user,"Would you like to request an AI's presence?",,"Yes","No") == "Yes")
		if(last_request + 200 < world.time) //don't spam the AI with requests you jerk!
			last_request = world.time
			user << "<span class='notice'>You request an AI's presence.</span>"
			var/area/area = get_area(src)
			for(var/mob/living/silicon/ai/AI in living_mob_list)
				if(!AI.client)	continue
				AI << "<span class='info'>Your presence is requested at <a href='?src=\ref[AI];jumptoholopad=\ref[src]'>\the [area]</a>.</span>"
		else
			user << "<span class='notice'>A request for AI presence was already sent recently.</span>"

/obj/machinery/hologram/holopad/attack_ai(mob/living/silicon/ai/user)
	if (!istype(user))
		return
	/*There are pretty much only three ways to interact here.
	I don't need to check for client since they're clicking on an object.
	This may change in the future but for now will suffice.*/
	if(user.eyeobj.loc != src.loc)//Set client eye on the object if it's not already.
		user.eyeobj.setLoc(get_turf(src))
	else if(!masters[user])//If there is no hologram, possibly make one.
		activate_holo(user)
	else//If there is a hologram, remove it.
		clear_holo(user)
	return

/obj/machinery/hologram/holopad/proc/activate_holo(mob/living/silicon/ai/user)
	if(!(stat & NOPOWER) && user.eyeobj.loc == src.loc)//If the projector has power and client eye is on it
		if (user.holo)
			user << "<span class='danger'>ERROR:</span> Image feed in progress."
			return
		create_holo(user)//Create one.
		src.visible_message("A holographic image of [user] flicks to life right before your eyes!")
	else
		user << "<span class='danger'>ERROR:</span> Unable to project hologram."
	return

/*This is the proc for special two-way communication between AI and holopad/people talking near holopad.
For the other part of the code, check silicon say.dm. Particularly robot talk.*/
/obj/machinery/hologram/holopad/hear_talk(mob/living/M, text, verb, datum/language/speaking)
	if(M)
		for(var/mob/living/silicon/ai/master in masters)
			if(!master.say_understands(M, speaking))//The AI will be able to understand most mobs talking through the holopad.
				if(speaking)
					text = speaking.scramble(text)
				else
					text = stars(text)
			var/name_used = M.GetVoice()
			//This communication is imperfect because the holopad "filters" voices and is only designed to connect to the master only.
			var/rendered
			if(speaking)
				rendered = "<i><span class='game say'>Holopad received, <span class='name'>[name_used]</span> [speaking.format_message(text, verb)]</span></i>"
			else
				rendered = "<i><span class='game say'>Holopad received, <span class='name'>[name_used]</span> [verb], <span class='message'>\"[text]\"</span></span></i>"
			master.show_message(rendered, 2)

/obj/machinery/hologram/holopad/see_emote(mob/living/M, text)
	if(M)
		for(var/mob/living/silicon/ai/master in masters)
			//var/name_used = M.GetVoice()
			var/rendered = "<i><span class='game say'>Holopad received, <span class='message'>[text]</span></span></i>"
			//The lack of name_used is needed, because message already contains a name.  This is needed for simple mobs to emote properly.
			master.show_message(rendered, 2)
	return

/obj/machinery/hologram/holopad/proc/create_holo(mob/living/silicon/ai/A, turf/T = loc)
	var/obj/effect/overlay/hologram = new(T)//Spawn a blank effect at the location.
	hologram.icon = A.holo_icon
	hologram.mouse_opacity = 0//So you can't click on it.
	hologram.layer = FLY_LAYER//Above all the other objects/mobs. Or the vast majority of them.
	hologram.anchored = 1//So space wind cannot drag it.
	hologram.name = "[A.name] (Hologram)"//If someone decides to right click.
	hologram.SetLuminosity(2)	//hologram lighting
	hologram.color = color //painted holopad gives coloured holograms
	masters[A] = hologram
	SetLuminosity(2)			//pad lighting
	icon_state = "holopad1"
	A.holo = src
	return 1

/obj/machinery/hologram/holopad/proc/clear_holo(mob/living/silicon/ai/user)
	if(user.holo == src)
		user.holo = null
	del(masters[user])//Get rid of user's hologram //qdel
	masters -= user //Discard AI from the list of those who use holopad
	if (!masters.len)//If no users left
		SetLuminosity(0)			//pad lighting (hologram lighting will be handled automatically since its owner was deleted)
		icon_state = "holopad0"
	return 1

/obj/machinery/hologram/holopad/process()
	for (var/mob/living/silicon/ai/master in masters)
		var/active_ai = (master && !master.stat && master.client && master.eyeobj)//If there is an AI attached, it's not incapacitated, it has a client, and the client eye is centered on the projector.
		if((stat & NOPOWER) || !active_ai)
			clear_holo(master)
			continue
		
		if((HOLOPAD_MODE == RANGE_BASED && (get_dist(master.eyeobj, src) > holo_range)))
			clear_holo(master)
			continue
		
		if(HOLOPAD_MODE == AREA_BASED)
			var/area/holo_area = get_area(src)
			var/area/eye_area = get_area(master.eyeobj)
			
			if(!(eye_area in holo_area.master.related))
				clear_holo(master)
				continue

		use_power(power_per_hologram)
	return 1

/obj/machinery/hologram/holopad/proc/move_hologram(mob/living/silicon/ai/user)
	if(masters[user])
		step_to(masters[user], user.eyeobj) // So it turns.
		var/obj/effect/overlay/H = masters[user]
		H.loc = get_turf(user.eyeobj)
		masters[user] = H
	return 1

/*
 * Hologram
 */

/obj/machinery/hologram
	anchored = 1
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 100

//Destruction procs.
/obj/machinery/hologram/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
		if(2.0)
			if (prob(50))
				del(src)
		if(3.0)
			if (prob(5))
				del(src)
	return

/obj/machinery/hologram/blob_act()
	del(src)
	return

/obj/machinery/hologram/meteorhit()
	del(src)
	return

/obj/machinery/hologram/holopad/Del()
	for (var/mob/living/silicon/ai/master in masters)
		clear_holo(master)
	..()

/*
Holographic project of everything else.

/mob/verb/hologram_test()
	set name = "Hologram Debug New"
	set category = "CURRENT DEBUG"

	var/obj/effect/overlay/hologram = new(loc)//Spawn a blank effect at the location.
	var/icon/flat_icon = icon(getFlatIcon(src,0))//Need to make sure it's a new icon so the old one is not reused.
	flat_icon.ColorTone(rgb(125,180,225))//Let's make it bluish.
	flat_icon.ChangeOpacity(0.5)//Make it half transparent.
	var/input = input("Select what icon state to use in effect.",,"")
	if(input)
		var/icon/alpha_mask = new('icons/effects/effects.dmi', "[input]")
		flat_icon.AddAlphaMask(alpha_mask)//Finally, let's mix in a distortion effect.
		hologram.icon = flat_icon

		world << "Your icon should appear now."
	return
*/

/*
 * Other Stuff: Is this even used?
 */
/obj/machinery/hologram/projector
	name = "hologram projector"
	desc = "It makes a hologram appear...with magnets or something..."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "hologram0"


#undef RANGE_BASED
#undef AREA_BASED
#undef HOLOPAD_PASSIVE_POWER_USAGE
#undef HOLOGRAM_POWER_USAGE
