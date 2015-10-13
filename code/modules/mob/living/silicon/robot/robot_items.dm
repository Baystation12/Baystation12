//A portable analyzer, for research borgs.  This is better then giving them a gripper which can hold anything and letting them use the normal analyzer.
/obj/item/weapon/portable_destructive_analyzer
	name = "Portable Destructive Analyzer"
	icon = 'icons/obj/items.dmi'
	icon_state = "portable_analyzer"
	desc = "Similar to the stationary version, this rather unwieldy device allows you to break down objects in the name of science."

	var/min_reliability = 90 //Can't upgrade, call it laziness or a drawback

	var/datum/research/techonly/files 	//The device uses the same datum structure as the R&D computer/server.
										//This analyzer can only store tech levels, however.

	var/obj/item/weapon/loaded_item	//What is currently inside the analyzer.

/obj/item/weapon/portable_destructive_analyzer/New()
	..()
	files = new /datum/research/techonly(src) //Setup the research data holder.

/obj/item/weapon/portable_destructive_analyzer/attack_self(user as mob)
	var/response = alert(user, 	"Analyzing the item inside will *DESTROY* the item for good.\n\
							Syncing to the research server will send the data that is stored inside to research.\n\
							Ejecting will place the loaded item onto the floor.",
							"What would you like to do?", "Analyze", "Sync", "Eject")
	if(response == "Analyze")
		if(loaded_item)
			var/confirm = alert(user, "This will destroy the item inside forever.  Are you sure?","Confirm Analyze","Yes","No")
			if(confirm == "Yes") //This is pretty copypasta-y
				user << "You activate the analyzer's microlaser, analyzing \the [loaded_item] and breaking it down."
				flick("portable_analyzer_scan", src)
				playsound(src.loc, 'sound/items/Welder2.ogg', 50, 1)
				var/list/temp_tech = ConvertReqString2List(loaded_item.origin_tech)
				for(var/T in temp_tech)
					files.UpdateTech(T, temp_tech[T])
					user << "\The [loaded_item] had level [temp_tech[T]] in [T]."
				loaded_item = null
				for(var/obj/I in contents)
					for(var/mob/M in I.contents)
						M.death()
					if(istype(I,/obj/item/stack/material))//Only deconstructs one sheet at a time instead of the entire stack
						var/obj/item/stack/material/S = I
						if(S.get_amount() > 1)
							S.use(1)
							loaded_item = S
						else
							qdel(S)
							desc = initial(desc)
							icon_state = initial(icon_state)
					else
						qdel(I)
						desc = initial(desc)
						icon_state = initial(icon_state)
			else
				return
		else
			user << "The [src] is empty.  Put something inside it first."
	if(response == "Sync")
		var/success = 0
		for(var/obj/machinery/r_n_d/server/S in machines)
			for(var/datum/tech/T in files.known_tech) //Uploading
				S.files.AddTech2Known(T)
			for(var/datum/tech/T in S.files.known_tech) //Downloading
				files.AddTech2Known(T)
			success = 1
			files.RefreshResearch()
		if(success)
			user << "You connect to the research server, push your data upstream to it, then pull the resulting merged data from the master branch."
			playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 1)
		else
			user << "Reserch server ping response timed out.  Unable to connect.  Please contact the system administrator."
			playsound(src.loc, 'sound/machines/buzz-two.ogg', 50, 1)
	if(response == "Eject")
		if(loaded_item)
			loaded_item.loc = get_turf(src)
			desc = initial(desc)
			icon_state = initial(icon_state)
			loaded_item = null
		else
			user << "The [src] is already empty."


/obj/item/weapon/portable_destructive_analyzer/afterattack(var/atom/target, var/mob/living/user, proximity)
	if(!target)
		return
	if(!proximity)
		return
	if(!isturf(target.loc)) // Don't load up stuff if it's inside a container or mob!
		return
	if(istype(target,/obj/item))
		if(loaded_item)
			user << "Your [src] already has something inside.  Analyze or eject it first."
			return
		var/obj/item/I = target
		I.loc = src
		loaded_item = I
		for(var/mob/M in viewers())
			M.show_message(text("<span class='notice'>[user] adds the [I] to the [src].</span>"), 1)
		desc = initial(desc) + "<br>It is holding \the [loaded_item]."
		flick("portable_analyzer_load", src)
		icon_state = "portable_analyzer_full"

//This is used to unlock other borg covers.
/obj/item/weapon/card/robot //This is not a child of id cards, as to avoid dumb typechecks on computers.
	name = "access code transmission device"
	icon_state = "id-robot"
	desc = "A circuit grafted onto the bottom of an ID card.  It is used to transmit access codes into other robot chassis, \
	allowing you to lock and unlock other robots' panels."

//A harvest item for serviceborgs.
/obj/item/weapon/robot_harvester
	name = "auto harvester"
	desc = "A hand-held harvest tool that resembles a sickle.  It uses energy to cut plant matter very efficently."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "autoharvester"

/obj/item/weapon/robot_harvester/afterattack(var/atom/target, var/mob/living/user, proximity)
	if(!target)
		return
	if(!proximity)
		return
	if(istype(target,/obj/machinery/portable_atmospherics/hydroponics))
		var/obj/machinery/portable_atmospherics/hydroponics/T = target
		if(T.harvest) //Try to harvest, assuming it's alive.
			T.harvest(user)
		else if(T.dead) //It's probably dead otherwise.
			T.remove_dead(user)
	else
		user << "Harvesting \a [target] is not the purpose of this tool.  The [src] is for plants being grown."

// A special tray for the service droid. Allow droid to pick up and drop items as if they were using the tray normally
// Click on table to unload, click on item to load. Otherwise works identically to a tray.
// Unlike the base item "tray", robotrays ONLY pick up food, drinks and condiments.

/obj/item/weapon/tray/robotray
	name = "RoboTray"
	desc = "An autoloading tray specialized for carrying refreshments."

/obj/item/weapon/tray/robotray/afterattack(atom/target, mob/user as mob, proximity)
	if(!proximity)
		return
	if ( !target )
		return
	// pick up items, mostly copied from base tray pickup proc
	// see code\game\objects\items\weapons\kitchen.dm line 241
	if ( istype(target,/obj/item))
		if ( !isturf(target.loc) ) // Don't load up stuff if it's inside a container or mob!
			return
		var turf/pickup = target.loc

		var addedSomething = 0

		for(var/obj/item/weapon/reagent_containers/food/I in pickup)


			if( I != src && !I.anchored && !istype(I, /obj/item/clothing/under) && !istype(I, /obj/item/clothing/suit) && !istype(I, /obj/item/projectile) )
				var/add = 0
				if(I.w_class == 1.0)
					add = 1
				else if(I.w_class == 2.0)
					add = 3
				else
					add = 5
				if(calc_carry() + add >= max_carry)
					break

				I.loc = src
				carrying.Add(I)
				overlays += image("icon" = I.icon, "icon_state" = I.icon_state, "layer" = 30 + I.layer)
				addedSomething = 1
		if ( addedSomething )
			user.visible_message("\blue [user] load some items onto their service tray.")

		return

	// Unloads the tray, copied from base item's proc dropped() and altered
	// see code\game\objects\items\weapons\kitchen.dm line 263

	if ( isturf(target) || istype(target,/obj/structure/table) )
		var foundtable = istype(target,/obj/structure/table/)
		if ( !foundtable ) //it must be a turf!
			for(var/obj/structure/table/T in target)
				foundtable = 1
				break

		var turf/dropspot
		if ( !foundtable ) // don't unload things onto walls or other silly places.
			dropspot = user.loc
		else if ( isturf(target) ) // they clicked on a turf with a table in it
			dropspot = target
		else					// they clicked on a table
			dropspot = target.loc


		overlays = null

		var droppedSomething = 0

		for(var/obj/item/I in carrying)
			I.loc = dropspot
			carrying.Remove(I)
			droppedSomething = 1
			if(!foundtable && isturf(dropspot))
				// if no table, presume that the person just shittily dropped the tray on the ground and made a mess everywhere!
				spawn()
					for(var/i = 1, i <= rand(1,2), i++)
						if(I)
							step(I, pick(NORTH,SOUTH,EAST,WEST))
							sleep(rand(2,4))
		if ( droppedSomething )
			if ( foundtable )
				user.visible_message("\blue [user] unloads their service tray.")
			else
				user.visible_message("\blue [user] drops all the items on their tray.")

	return ..()




// A special pen for service droids. Can be toggled to switch between normal writting mode, and paper rename mode
// Allows service droids to rename paper items.

/obj/item/weapon/pen/robopen
	desc = "A black ink printing attachment with a paper naming mode."
	name = "Printing Pen"
	var/mode = 1

/obj/item/weapon/pen/robopen/attack_self(mob/user as mob)

	var/choice = input("Would you like to change colour or mode?") as null|anything in list("Colour","Mode")
	if(!choice) return

	playsound(src.loc, 'sound/effects/pop.ogg', 50, 0)

	switch(choice)

		if("Colour")
			var/newcolour = input("Which colour would you like to use?") as null|anything in list("black","blue","red","green","yellow")
			if(newcolour) colour = newcolour

		if("Mode")
			if (mode == 1)
				mode = 2
			else
				mode = 1
			user << "Changed printing mode to '[mode == 2 ? "Rename Paper" : "Write Paper"]'"

	return

// Copied over from paper's rename verb
// see code\modules\paperwork\paper.dm line 62

/obj/item/weapon/pen/robopen/proc/RenamePaper(mob/user as mob,obj/paper as obj)
	if ( !user || !paper )
		return
	var/n_name = sanitizeSafe(input(user, "What would you like to label the paper?", "Paper Labelling", null)  as text, 32)
	if ( !user || !paper )
		return

	//n_name = copytext(n_name, 1, 32)
	if(( get_dist(user,paper) <= 1  && user.stat == 0))
		paper.name = "paper[(n_name ? text("- '[n_name]'") : null)]"
	add_fingerprint(user)
	return

//TODO: Add prewritten forms to dispense when you work out a good way to store the strings.
/obj/item/weapon/form_printer
	//name = "paperwork printer"
	name = "paper dispenser"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "paper_bin1"
	item_state = "sheet-metal"

/obj/item/weapon/form_printer/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	return

/obj/item/weapon/form_printer/afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, flag, params)

	if(!target || !flag)
		return

	if(istype(target,/obj/structure/table))
		deploy_paper(get_turf(target))

/obj/item/weapon/form_printer/attack_self(mob/user as mob)
	deploy_paper(get_turf(src))

/obj/item/weapon/form_printer/proc/deploy_paper(var/turf/T)
	T.visible_message("\blue \The [src.loc] dispenses a sheet of crisp white paper.")
	new /obj/item/weapon/paper(T)


//Personal shielding for the combat module.
/obj/item/borg/combat/shield
	name = "personal shielding"
	desc = "A powerful experimental module that turns aside or absorbs incoming attacks at the cost of charge."
	icon = 'icons/obj/decals.dmi'
	icon_state = "shock"
	var/shield_level = 0.5 //Percentage of damage absorbed by the shield.

/obj/item/borg/combat/shield/verb/set_shield_level()
	set name = "Set shield level"
	set category = "Object"
	set src in range(0)

	var/N = input("How much damage should the shield absorb?") in list("5","10","25","50","75","100")
	if (N)
		shield_level = text2num(N)/100

/obj/item/borg/combat/mobility
	name = "mobility module"
	desc = "By retracting limbs and tucking in its head, a combat android can roll at high speeds."
	icon = 'icons/obj/decals.dmi'
	icon_state = "shock"