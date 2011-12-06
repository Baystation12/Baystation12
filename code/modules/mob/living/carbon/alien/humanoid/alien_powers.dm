/*NOTES:
These are general powers. Specific powers are stored under the appropriate alien creature type.
*/

/*Alien spit now works like a taser shot. It won't home in on the target but will act the same once it does hit.
Doesn't work on other aliens/AI.*/


/mob/living/carbon/alien/proc/powerc(X, Y)//Y is optional, checks for weed planting. X can be null.
	if(stat)
		src << "\green You must be conscious to do this."
		return 0
	else if(X && getPlasma() < X)
		src << "\green Not enough plasma stored."
		return 0
	else if(Y && (!isturf(src.loc) || istype(src.loc, /turf/space)))
		src << "\green Bad place for a garden!"
		return 0
	else	return 1

/mob/living/carbon/alien/humanoid/verb/plant()
	set name = "Plant Weeds (50)"
	set desc = "Plants some alien weeds"
	set category = "Alien"

	if(powerc(50,1))
		adjustToxLoss(-50)
		for(var/mob/O in viewers(src, null))
			O.show_message(text("\green <B>[src] has planted some alien weeds!</B>"), 1)
		new /obj/effect/alien/weeds/node(loc)
	return

/mob/living/carbon/alien/humanoid/verb/ActivateHuggers()
	set name = "Activate facehuggers (5)"
	set desc = "Makes all nearby facehuggers activate"
	set category = "Alien"

	if(powerc(5))
		adjustToxLoss(-5)
		for(var/obj/item/clothing/mask/facehugger/F in range(8,src))
			F.GoActive()
		emote("roar")
	return

/mob/living/carbon/alien/humanoid/verb/whisp(mob/M as mob in oview())
	set name = "Whisper (10)"
	set desc = "Whisper to someone"
	set category = "Alien"

	if(powerc(10))
		adjustToxLoss(-10)
		var/msg = sanitize(input("Message:", "Alien Whisper") as text|null)
		if(msg)
			log_say("AlienWhisper: [key_name(src)]->[M.key] : [msg]")
			M << "\green You hear a strange, alien voice in your head... \italic [msg]"
			src << {"\green You said: "[msg]" to [M]"}
	return

/mob/living/carbon/alien/humanoid/verb/transfer_plasma(mob/living/carbon/alien/M as mob in oview())
	set name = "Transfer Plasma"
	set desc = "Transfer Plasma to another alien"
	set category = "Alien"

	if(isalien(M))
		var/amount = input("Amount:", "Transfer Plasma to [M]") as num
		if (amount)
			if(powerc(amount))
				if (get_dist(src,M) <= 1)
					M.adjustToxLoss(amount)
					adjustToxLoss(-amount)
					M << "\green [src] has transfered [amount] plasma to you."
					src << {"\green You have trasferred [amount] plasma to [M]"}
				else
					src << "\green You need to be closer."
	return

/*Xenos now have a proc and a verb for drenching stuff in acid. I couldn't get them to work right when combined so this was the next best solution.
The first proc defines the acid throw function while the other two work in the game itself. Probably a good idea to revise this later.
I kind of like the right click only--the window version can get a little confusing. Perhaps something telling the alien they need to right click?
/N*/
/obj/proc/acid(user as mob)
	var/obj/effect/alien/acid/A = new(src.loc)
	A.target = src
	for(var/mob/M in viewers(src, null))
		M.show_message(text("\green <B>[user] vomits globs of vile stuff all over [src]!</B>"), 1)
	A.tick()

/mob/living/carbon/alien/humanoid/proc/corrode_target() //Aliens only see items on the list of objects that they can actually spit on./N
	set name = "Spit Corrosive Acid (200)"
	set desc = "Drench an object in acid, destroying it over time."
	set category = "Alien"

	if(powerc(200))//Check 1.
		var/list/xeno_target
		xeno_target = list("Abort Command")
		for(var/obj/O in view(1))
			if(!O.unacidable)
				xeno_target.Add(O)
		var/obj/A
		A = input("Corrode which target?", "Targets", A) in xeno_target
		if(!A == "Abort Command")
			if(powerc(200))//Check 2.
				if(A in view(1))//Check 3.
					adjustToxLoss(-200)
					A.acid(src)
				else
					src << "\green Target is too far away."
	return

/mob/living/carbon/alien/humanoid/verb/corrode(obj/O as anything in oview(1)) //If they right click to corrode, an error will flash if its an invalid target./N
	set name = "Corrode with Acid (200)"
	set desc = "Drench an object in acid, destroying it over time."
	set category = "Alien"

	if(istype(O, /obj))
		if(powerc(200))
			if(!O.unacidable)
				adjustToxLoss(-200)
				O.acid()
			else//So the aliens don't destroy energy fields/singularies/other aliens/etc with their acid.
				src << "\green You cannot destroy this object."
	return

/mob/living/carbon/alien/humanoid/verb/ventcrawl() // -- TLE
	set name = "Crawl through Vent"
	set desc = "Enter an air vent and crawl through the pipes."
	set category = "Alien"
//	if(!istype(V,/obj/machinery/atmoalter/siphs/fullairsiphon/air_vent))
//		return

	if(powerc())
		var/obj/machinery/atmospherics/unary/vent_pump/vent_found
		for(var/obj/machinery/atmospherics/unary/vent_pump/v in range(1,src))
			if(!v.welded)
				vent_found = v
			else
				src << "\red That vent is welded."
		if(vent_found)
			var/list/vents = list()
			if(vent_found.network&&vent_found.network.normal_members.len)
				for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in vent_found.network.normal_members)
					if(temp_vent.loc == loc)
						continue
					if(temp_vent.welded)
						continue
					vents.Add(temp_vent)
				var/list/choices = list()
				for(var/obj/machinery/atmospherics/unary/vent_pump/vent in vents)
					if(vent.loc.z != loc.z)
						continue
					if(vent.welded)
						continue
					var/atom/a = get_turf_loc(vent)
					choices.Add(a.loc)
				var/turf/startloc = loc
				var/obj/selection = input("Select a destination.", "Duct System") in choices
				var/selection_position = choices.Find(selection)
				if(loc==startloc)

					// Hacky way of hopefully preventing a runtime error from happening
					if(vents.len < selection_position)
						vents.len = selection_position//What the fuck is this I dont even,  Right will likely have to fix this later

					var/obj/machinery/atmospherics/unary/vent_pump/target_vent = vents[selection_position]
					if(target_vent)
						for(var/mob/O in viewers(src, null))
							O.show_message(text("<B>[src] scrambles into the ventillation ducts!</B>"), 1)
		//				var/list/huggers = list()
			//			for(var/obj/effect/alien/facehugger/F in view(3, src))
			//				if(istype(F, /obj/effect/alien/facehugger))
			//					huggers.Add(F)
						loc = vent_found

			//			for(var/obj/effect/alien/facehugger/F in huggers)
			//			F.loc = vent_found
						var/travel_time = get_dist(loc, target_vent.loc)

						spawn(round(travel_time/2))//give sound warning to anyone near the target vent
							if(!target_vent.welded)
								for(var/mob/O in hearers(target_vent, null))
									O.show_message("You hear something crawling trough the ventilation pipes.",2)

						spawn(travel_time)
							if(target_vent.welded)//the vent can be welded while alien scrolled through the list or travelled.
								target_vent = vent_found //travel back. No additional time required.
								src << "\red The vent you were heading to appears to be welded."
							loc = target_vent.loc
//							for(var/obj/effect/alien/facehugger/F in huggers)
//								F.loc = loc

				else
					src << "\green You need to remain still while entering a vent."
			else
				src << "\green This vent is not connected to anything."
		else
			src << "\green You must be standing on or beside an open air vent to enter it."
	return