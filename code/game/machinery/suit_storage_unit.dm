//////////////////////////////////////
// SUIT STORAGE UNIT /////////////////
//////////////////////////////////////


/obj/machinery/suit_storage_unit
	name = "Suit Storage Unit"
	desc = "An industrial U-Stor-It Storage unit designed to accomodate all kinds of space suits. Its on-board equipment also allows the user to decontaminate the contents through a UV-ray purging cycle. There's a warning label dangling from the control pad, reading \"STRICTLY NO BIOLOGICALS IN THE CONFINES OF THE UNIT\"."
	icon = 'icons/obj/suitstorage.dmi'
	icon_state = "close"
	anchored = 1
	density = 1
	use_power = 1
	idle_power_usage = 50
	active_power_usage = 200
	interact_offline = 1
	req_access = list()

	var/mob/living/carbon/human/occupant = null
	var/obj/item/clothing/suit/space/suit = null
	var/obj/item/clothing/head/helmet/space/helmet = null
	var/obj/item/clothing/shoes/magboots/boots = null
	var/obj/item/weapon/tank/tank = null
	var/obj/item/clothing/mask/mask = null

	var/suit_type = null
	var/helmet_type = null
	var/boots_type = null
	var/tank_type = null
	var/mask_type = null

	var/isopen = 0
	var/islocked = 0
	var/isUV = 0
	var/isbroken = 0
	var/issuperUV = 0
	var/panelopen = 0
	var/safetieson = 1
	var/cycletime_left = 0

//The units themselves/////////////////

/obj/machinery/suit_storage_unit/standard_unit
	suit_type = /obj/item/clothing/suit/space
	helmet_type = /obj/item/clothing/head/helmet/space
	tank_type = /obj/item/weapon/tank/oxygen
	mask_type = /obj/item/clothing/mask/breath
	req_access = list(access_eva)

/obj/machinery/suit_storage_unit/atmos
	name = "Atmospherics Voidsuit Storage Unit"
	suit_type = /obj/item/clothing/suit/space/void/atmos
	helmet_type = /obj/item/clothing/head/helmet/space/void/atmos
	boots_type = /obj/item/clothing/shoes/magboots
	tank_type = /obj/item/weapon/tank/oxygen
	mask_type = /obj/item/clothing/mask/breath
	req_access = list(access_atmospherics)
	islocked = 1

/obj/machinery/suit_storage_unit/atmos/alt
	suit_type = /obj/item/clothing/suit/space/void/atmos/alt
	helmet_type = /obj/item/clothing/head/helmet/space/void/atmos/alt

/obj/machinery/suit_storage_unit/engineering
	name = "Engineering Voidsuit Storage Unit"
	suit_type = /obj/item/clothing/suit/space/void/engineering
	helmet_type = /obj/item/clothing/head/helmet/space/void/engineering
	boots_type = /obj/item/clothing/shoes/magboots
	tank_type = /obj/item/weapon/tank/oxygen
	mask_type = /obj/item/clothing/mask/breath
	req_access = list(access_engine)
	islocked = 1

/obj/machinery/suit_storage_unit/engineering/alt
	suit_type = /obj/item/clothing/suit/space/void/engineering/alt
	helmet_type = /obj/item/clothing/head/helmet/space/void/engineering/alt
	mask_type = /obj/item/clothing/mask/breath

/obj/machinery/suit_storage_unit/engineering/salvage
	suit_type = /obj/item/clothing/suit/space/void/engineering/salvage
	helmet_type = /obj/item/clothing/head/helmet/space/void/engineering/salvage
	mask_type = /obj/item/clothing/mask/breath

/obj/machinery/suit_storage_unit/medical
	name = "Medical Voidsuit Storage Unit"
	suit_type = /obj/item/clothing/suit/space/void/medical
	helmet_type = /obj/item/clothing/head/helmet/space/void/medical
	boots_type = /obj/item/clothing/shoes/magboots
	tank_type = /obj/item/weapon/tank/oxygen
	mask_type = /obj/item/clothing/mask/breath
	req_access = list(access_medical)
	islocked = 1

/obj/machinery/suit_storage_unit/medical/alt
	suit_type = /obj/item/clothing/suit/space/void/medical/alt
	helmet_type = /obj/item/clothing/head/helmet/space/void/medical/alt
	mask_type = /obj/item/clothing/mask/breath

/obj/machinery/suit_storage_unit/mining
	name = "Mining Voidsuit Storage Unit"
	suit_type = /obj/item/clothing/suit/space/void/mining
	helmet_type = /obj/item/clothing/head/helmet/space/void/mining
	boots_type = /obj/item/clothing/shoes/magboots
	tank_type = /obj/item/weapon/tank/oxygen
	mask_type = /obj/item/clothing/mask/breath
	req_access = list(access_mining)
	islocked = 1

/obj/machinery/suit_storage_unit/mining/alt
	suit_type = /obj/item/clothing/suit/space/void/mining/alt
	helmet_type = /obj/item/clothing/head/helmet/space/void/mining/alt
	mask_type = /obj/item/clothing/mask/breath

/obj/machinery/suit_storage_unit/science
	name = "Excavation Voidsuit Storage Unit"
	suit_type = /obj/item/clothing/suit/space/void/excavation
	helmet_type = /obj/item/clothing/head/helmet/space/void/excavation
	boots_type = /obj/item/clothing/shoes/magboots
	tank_type = /obj/item/weapon/tank/oxygen
	mask_type = /obj/item/clothing/mask/breath
	req_access = list(access_xenoarch)
	islocked = 1

/obj/machinery/suit_storage_unit/security
	name = "Security Voidsuit Storage Unit"
	suit_type = /obj/item/clothing/suit/space/void/security
	helmet_type = /obj/item/clothing/head/helmet/space/void/security
	boots_type = /obj/item/clothing/shoes/magboots
	tank_type = /obj/item/weapon/tank/oxygen
	mask_type = /obj/item/clothing/mask/breath
	req_access = list(access_security)
	islocked = 1

/obj/machinery/suit_storage_unit/security/alt
	suit_type = /obj/item/clothing/suit/space/void/security/alt
	helmet_type = /obj/item/clothing/head/helmet/space/void/security/alt
	mask_type = /obj/item/clothing/mask/breath

/obj/machinery/suit_storage_unit/merc
	name = "Nonstandard Voidsuit Storage Unit"
	suit_type = /obj/item/clothing/suit/space/void/merc
	helmet_type = /obj/item/clothing/head/helmet/space/void/merc
	boots_type = /obj/item/clothing/shoes/magboots
	tank_type = /obj/item/weapon/tank/oxygen
	mask_type = /obj/item/clothing/mask/breath
	req_access = list(access_syndicate)
	islocked = 1



/obj/machinery/suit_storage_unit/Initialize()
	. = ..()
	if(suit_type)
		suit = new suit_type(src)
	if(helmet_type)
		helmet = new helmet_type(src)
	if(boots_type)
		boots = new boots_type(src)
	if(tank_type)
		tank = new tank_type(src)
	if(mask_type)
		mask = new mask_type(src)
	update_icon()

/obj/machinery/suit_storage_unit/update_icon()
	overlays.Cut()
	if(panelopen)
		overlays += ("panel")
	if(isUV)
		if(issuperUV)
			overlays += ("super")
		else if(occupant)
			overlays += ("uvhuman")
		else
			overlays += ("uv")
	else if(isopen)
		if(stat & BROKEN)
			overlays += ("broken")
		else
			overlays += ("open")
			if(suit)
				overlays += ("suit")
			if(helmet)
				overlays += ("helm")
			if(boots || tank || mask)
				overlays += ("storage")
	else if(occupant)
		overlays += ("human")

/obj/machinery/suit_storage_unit/ex_act(severity)
	switch(severity)
		if(1)
			if(prob(50))
				dump_everything() //So suits dont survive all the time
			qdel(src)
			return
		if(2)
			if(prob(35))
				dump_everything()
				qdel(src)
			return
		else
			return
	return


/obj/machinery/suit_storage_unit/attack_hand(mob/user as mob)
	..()
	var/dat
	if(!user.IsAdvancedToolUser())
		return 0
	if(panelopen) //The maintenance panel is open. Time for some shady stuff
		dat+= "<HEAD><TITLE>Suit storage unit: Maintenance panel</TITLE></HEAD>"
		dat+= "<Font color ='black'><B>Maintenance panel controls</B></font><HR>"
		dat+= "<font color ='grey'>The panel is ridden with controls, button and meters, labeled in strange signs and symbols that <BR>you cannot understand. Probably the manufactoring world's language.<BR> Among other things, a few controls catch your eye.</font><BR><BR>"
		dat+= text("<font color ='black'>A small dial with a small lambda symbol on it. It's pointing towards a gauge that reads []</font>.<BR> <font color='blue'><A href='?src=\ref[];toggleUV=1'> Turn towards []</A></font><BR>",(issuperUV ? "15nm" : "185nm"),src,(issuperUV ? "185nm" : "15nm") )
		dat+= text("<font color ='black'>A thick old-style button, with 2 grimy LED lights next to it. The [] LED is on.</font><BR><font color ='blue'><A href='?src=\ref[];togglesafeties=1'>Press button</a></font>",(safetieson? "<font color='green'><B>GREEN</B></font>" : "<font color='red'><B>RED</B></font>"),src)
		dat+= text("<HR><BR><A href='?src=\ref[];mach_close=suit_storage_unit'>Close panel</A>", user)
	else if(isUV) //The thing is running its cauterisation cycle. You have to wait.
		dat += "<HEAD><TITLE>Suit storage unit</TITLE></HEAD>"
		dat+= "<font color ='red'><B>Unit is cauterising contents with selected UV ray intensity. Please wait.</font></B><BR>"
		dat+= "<font colr='black'><B>Cycle end in: [cycletime_left] seconds. </font></B>"

	else
		if(!isbroken)
			dat+= "<HEAD><TITLE>Suit storage unit</TITLE></HEAD>"
			dat+= "<font color='blue'><font size = 4><B>U-Stor-It Suit Storage Unit, model DS1900</B></FONT><BR>"
			dat+= "<B>Welcome to the Unit control panel.</B></FONT><HR>"
			dat+= text("<font color='black'>Helmet storage compartment: <B>[]</B></font><BR>",(helmet  ? helmet.name : "</font><font color ='grey'>No helmet detected.") )
			if(helmet  && isopen)
				dat+=text("<A href='?src=\ref[];dispense_helmet=1'>Dispense helmet</A><BR>",src)
			dat+= text("<font color='black'>Suit storage compartment: <B>[]</B></font><BR>",(suit ? suit.name : "</font><font color ='grey'>No suit detected.") )
			if(suit && isopen)
				dat+=text("<A href='?src=\ref[];dispense_suit=1'>Dispense suit</A><BR>",src)
			dat+= text("<font color='black'>Footwear storage compartment: <B>[]</B></font><BR>",(boots ? boots.name : "</font><font color ='grey'>No footwear detected.") )
			if(boots && isopen)
				dat+=text("<A href='?src=\ref[];dispense_boots=1'>Dispense footwear</A><BR>",src)
			dat+= text("<font color='black'>Tank storage compartment: <B>[]</B></font><BR>",(tank ? tank.name : "</font><font color ='grey'>No air tank detected.") )
			if(tank && isopen)
				dat+=text("<A href='?src=\ref[];dispense_tank=1'>Dispense air tank</A><BR>",src)
			dat+= text("<font color='black'>Breathmask storage compartment: <B>[]</B></font><BR>",(mask ? mask.name : "</font><font color ='grey'>No breathmask detected.") )
			if(mask && isopen)
				dat+=text("<A href='?src=\ref[];dispense_mask=1'>Dispense mask</A><BR>",src)
			if(occupant)
				dat+= "<HR><B><font color ='red'>WARNING: Biological entity detected inside the Unit's storage. Please remove.</B></font><BR>"
				dat+= "<A href='?src=\ref[src];eject_guy=1'>Eject extra load</A>"
			dat+= text("<HR><font color='black'>Unit is: [] - <A href='?src=\ref[];toggle_open=1'>[] Unit</A></font> ",(isopen ? "Open" : "Closed"),src,(isopen ? "Close" : "Open"))
			if(isopen)
				dat+="<HR>"
			else
				dat+= text(" - <A href='?src=\ref[];toggle_lock=1'><font color ='orange'>[] Unit</A></font><HR>",src,(islocked ? "Unlock" : "Lock") )
			dat+= text("Unit status: []",(islocked? "<font color ='red'><B>LOCKED</B></font><BR>" : "<font color ='green'><B>UNLOCKED</B></font><BR>") )
			dat+= text("<A href='?src=\ref[];start_UV=1'>Start Disinfection cycle</A><BR>",src)
			dat += text("<BR><BR><A href='?src=\ref[];mach_close=suit_storage_unit'>Close control panel</A>", user)
		else //Ohhhh shit it's dirty or broken! Let's inform the guy.
			dat+= "<HEAD><TITLE>Suit storage unit</TITLE></HEAD>"
			dat+= "<font color='maroon'><B>Unit chamber is too contaminated to continue usage. Please call for a qualified individual to perform maintenance.</font></B><BR><BR>"
			dat+= text("<HR><A href='?src=\ref[];mach_close=suit_storage_unit'>Close control panel</A>", user)

	user << browse(dat, "window=suit_storage_unit;size=400x500")
	onclose(user, "suit_storage_unit")
	return


/obj/machinery/suit_storage_unit/Topic(href, href_list) //I fucking HATE this proc
	if(..())
		return
	usr.set_machine(src)
	if (href_list["toggleUV"])
		toggleUV(usr)
		updateUsrDialog()
		update_icon()
	if (href_list["togglesafeties"])
		togglesafeties(usr)
		updateUsrDialog()
		update_icon()
	if (href_list["dispense_helmet"])
		dispense_helmet(usr)
		updateUsrDialog()
		update_icon()
	if (href_list["dispense_suit"])
		dispense_suit(usr)
		updateUsrDialog()
		update_icon()
	if (href_list["dispense_boots"])
		dispense_boots(usr)
		updateUsrDialog()
		update_icon()
	if (href_list["dispense_tank"])
		dispense_tank(usr)
		updateUsrDialog()
		update_icon()
	if (href_list["dispense_mask"])
		dispense_mask(usr)
		updateUsrDialog()
		update_icon()
	if (href_list["toggle_open"])
		toggle_open(usr)
		updateUsrDialog()
		update_icon()
	if (href_list["toggle_lock"])
		toggle_lock(usr)
		updateUsrDialog()
		update_icon()
	if (href_list["start_UV"])
		start_UV(usr)
		updateUsrDialog()
		update_icon()
	if (href_list["eject_guy"])
		eject_occupant(usr)
		updateUsrDialog()
		update_icon()
	return


/obj/machinery/suit_storage_unit/proc/toggleUV(mob/user as mob)
	if(!panelopen)
		return
	else  //welp, the guy is protected, we can continue
		if(issuperUV)
			to_chat(user, "<span class='notice'>You slide the dial back towards \"185nm\".</span>")
			issuperUV = 0
		else
			to_chat(user, "<span class='warning'>You crank the dial all the way up to \"15nm\".</span>")
			issuperUV = 1
		return


/obj/machinery/suit_storage_unit/proc/togglesafeties(mob/user as mob)
	if(!panelopen) //Needed check due to bugs
		return
	else
		safetieson = !safetieson
		to_chat(user, "<span class='notice'>You push the button. The coloured LED next to it [safetieson ? "turns green" : "turns red"].</span>")

#define dispense_clothing(item) if(item){item.dropInto(loc); item = null}

/obj/machinery/suit_storage_unit/proc/dispense_helmet(mob/user as mob)
	dispense_clothing(helmet)

/obj/machinery/suit_storage_unit/proc/dispense_suit(mob/user as mob)
	dispense_clothing(suit)

/obj/machinery/suit_storage_unit/proc/dispense_boots(mob/user as mob)
	dispense_clothing(boots)

/obj/machinery/suit_storage_unit/proc/dispense_tank(mob/user as mob)
	dispense_clothing(tank)

/obj/machinery/suit_storage_unit/proc/dispense_mask(mob/user as mob)
	dispense_clothing(mask)

/obj/machinery/suit_storage_unit/proc/dump_everything()
	islocked = 0 //locks go free
	dispense_clothing(suit)
	dispense_clothing(helmet)
	dispense_clothing(boots)
	dispense_clothing(tank)
	dispense_clothing(mask)
	if(occupant)
		eject_occupant(occupant)
	return

#undef dispense_clothing

/obj/machinery/suit_storage_unit/proc/toggle_open(mob/user as mob)
	if(stat & NOPOWER)
		to_chat(user, "<span class='warning'>The unit is offline.</span>")
		return
	if(islocked || isUV)
		to_chat(user, "<span class='warning'>Unable to open unit.</span>")
		return
	if(occupant)
		eject_occupant(user)
		return  // eject_occupant opens the door, so we need to return
	isopen = !isopen
	return


/obj/machinery/suit_storage_unit/proc/toggle_lock(mob/user as mob)
	if(stat & NOPOWER)
		to_chat(user, "<span class='warning'>The unit is offline.</span>")
		return
	if(!allowed(user))
		to_chat(user, FEEDBACK_ACCESS_DENIED)
		return
	if(occupant && safetieson)
		to_chat(user, "<span class='warning'>The Unit's safety protocols disallow locking when a biological form is detected inside its compartments.</span>")
		return
	if(isopen)
		return
	islocked = !islocked
	return


/obj/machinery/suit_storage_unit/proc/start_UV(mob/user as mob)
	if(isUV || isopen) //I'm bored of all these sanity checks
		return
	if(stat & NOPOWER)
		to_chat(user, "<span class='warning'>The unit is offline.</span>")
		return
	if(occupant && safetieson)
		to_chat(user, "<span class='danger'>WARNING:</span><span class='warning'> Biological entity detected in the confines of the Unit's storage. Cannot initiate cycle.</span>")
		return
	if(!helmet  && !mask && !suit && !boots && !tank && !occupant ) //shit's empty yo
		to_chat(user, "<span class='warning'>Unit storage bays empty. Nothing to disinfect -- Aborting.</span>")
		return
	to_chat(user, "You start the Unit's cauterisation cycle.")
	cycletime_left = 20
	isUV = 1
	if(occupant && !islocked)
		islocked = 1 //Let's lock it for good measure
	update_icon()
	updateUsrDialog()

	var/i //our counter
	for(i=0,i<4,i++)
		sleep(50)
		if(occupant)
			occupant.apply_effect(50, IRRADIATE, blocked = occupant.getarmor(null, "rad"))
			var/obj/item/organ/internal/diona/nutrients/rad_organ = locate() in occupant.internal_organs
			if (!rad_organ)
				if (occupant.can_feel_pain())
					occupant.emote("scream")
				if(issuperUV)
					var/burndamage = rand(40,60)
					occupant.take_organ_damage(0,burndamage)
				else
					var/burndamage = rand(10,15)
					occupant.take_organ_damage(0,burndamage)
		if(i==3) //End of the cycle
			if(!issuperUV)
				if(helmet )
					helmet.clean_blood()
				if(suit)
					suit.clean_blood()
				if(boots)
					boots.clean_blood()
				if(tank)
					tank.clean_blood()
				if(mask)
					mask.clean_blood()
			else //It was supercycling, destroy everything
				if(helmet )
					helmet  = null
				if(suit)
					suit = null
				if(boots)
					boots = null
				if(tank)
					tank = null
				if(mask)
					mask = null
				visible_message("<span class='warning'>With a loud whining noise, the Suit Storage Unit's door grinds open. Puffs of ashen smoke come out of its chamber.</span>", 3)
				isbroken = 1
				isopen = 1
				islocked = 0
				eject_occupant(occupant) //Mixing up these two lines causes bug. DO NOT DO IT.
			isUV = 0 //Cycle ends
	update_icon()
	updateUsrDialog()
	return

/obj/machinery/suit_storage_unit/proc/cycletimeleft()
	if(cycletime_left >= 1)
		cycletime_left--
	return cycletime_left


/obj/machinery/suit_storage_unit/proc/eject_occupant(mob/user as mob)
	if (islocked)
		return

	if (!occupant)
		return

	if (occupant.client)
		if(user != occupant)
			to_chat(occupant, "<span class='notice'>The machine kicks you out!</span>")
		if(user.loc != loc)
			to_chat(occupant, "<span class='notice'>You leave the not-so-cozy confines of the SSU.</span>")

		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE
	occupant.dropInto(loc)
	occupant = null
	if(!isopen)
		isopen = 1
	update_icon()
	return


/obj/machinery/suit_storage_unit/verb/get_out()
	set name = "Eject Suit Storage Unit"
	set category = "Object"
	set src in oview(1)

	if (usr.stat != 0)
		return
	eject_occupant(usr)
	add_fingerprint(usr)
	updateUsrDialog()
	update_icon()
	return


/obj/machinery/suit_storage_unit/verb/move_inside()
	set name = "Hide in Suit Storage Unit"
	set category = "Object"
	set src in oview(1)

	if (usr.stat != 0)
		return
	if (!isopen)
		to_chat(usr, "<span class='warning'>The unit's doors are shut.</span>")
		return
	if ((stat & NOPOWER) || isbroken)
		to_chat(usr, "<span class='warning'>The unit is not operational.</span>")
		return
	if ( (occupant) || (helmet ) || (suit) )
		to_chat(usr, "<span class='warning'>It's too cluttered inside for you to fit in!</span>")
		return
	visible_message("\The [usr] starts squeezing into the suit storage unit!", 3)
	if(do_after(usr, 10, src))
		usr.stop_pulling()
		usr.client.perspective = EYE_PERSPECTIVE
		usr.client.eye = src
		usr.loc = src
		occupant = usr
		isopen = 0 //Close the thing after the guy gets inside
		update_icon()
		add_fingerprint(usr)
		updateUsrDialog()
		return
	else
		occupant = null //Testing this as a backup sanity test
	return


/obj/machinery/suit_storage_unit/attackby(obj/item/I as obj, mob/user as mob)
	if(isScrewdriver(I))
		panelopen = !panelopen
		playsound(loc, 'sound/items/Screwdriver.ogg', 100, 1)
		to_chat(user, text("<span class='notice'>You [panelopen ? "open" : "close"] the unit's maintenance panel.</span>"))
		updateUsrDialog()
		update_icon()
		return
	if(isCrowbar(I))
		if((stat & NOPOWER) && !islocked && !isopen)
			to_chat(user, "<span class='warning'>You begin prying the unit open.</span>")
			if(do_after(user, 50, src))
				isopen = 1
				to_chat(user, "<span class='warning'>You pry the unit open.</span>")
				update_icon()
		else if(islocked)
			to_chat(user, "<span class='warning'>You can't pry the unit open, it's locked!</span>")
		return
	if(istype(I, /obj/item/grab) )
		var/obj/item/grab/G = I
		if( !(ismob(G.affecting)) )
			return
		if (!isopen)
			to_chat(user, "<span class='warning'>The unit's doors are shut.</span>")
			return
		if ((stat & NOPOWER) || isbroken)
			to_chat(user, "<span class='warning'>The unit is not operational.</span>")
			return
		if ( (occupant) || (helmet ) || (suit) || (boots) || (tank) || (mask)) //Unit needs to be absolutely empty
			to_chat(user, "<span class='warning'>The unit's storage area is too cluttered.</span>")
			return
		visible_message("[user] starts putting [G.affecting.name] into the Suit Storage Unit.", 3)
		if(do_after(user, 20, src))
			if(!G || !G.affecting) return //derpcheck
			var/mob/M = G.affecting
			if (M.client)
				M.client.perspective = EYE_PERSPECTIVE
				M.client.eye = src
			M.loc = src
			occupant = M
			isopen = 0 //close ittt
			add_fingerprint(user)
			qdel(G)
			updateUsrDialog()
			update_icon()
			return
		return
	if( istype(I,/obj/item/clothing/suit/space) )
		if(!isopen)
			return
		var/obj/item/clothing/suit/space/S = I
		if(suit)
			to_chat(user, "<span class='notice'>The unit already contains a suit.</span>")
			return
		to_chat(user, "You load the [S.name] into the storage compartment.")
		user.drop_item()
		S.forceMove(src)
		suit = S
		update_icon()
		updateUsrDialog()
		return
	if( istype(I,/obj/item/clothing/head/helmet/space) )
		if(!isopen)
			return
		var/obj/item/clothing/head/helmet/H = I
		if(helmet )
			to_chat(user, "<span class='notice'>The unit already contains a helmet.</span>")
			return
		to_chat(user, "You load the [H.name] into the storage compartment.")
		user.drop_item()
		H.forceMove(src)
		helmet  = H
		update_icon()
		updateUsrDialog()
		return
	if( istype(I,/obj/item/clothing/shoes/magboots) )
		if(!isopen)
			return
		var/obj/item/clothing/shoes/magboots/B = I
		if(boots)
			to_chat(user, "<span class='notice'>The unit already contains a pair of magboots.</span>")
			return
		to_chat(user, "You load the [B.name] into the storage compartment.")
		user.drop_item()
		B.forceMove(src)
		boots = B
		update_icon()
		updateUsrDialog()
		return
	if( istype(I,/obj/item/weapon/tank) )
		if(!isopen)
			return
		var/obj/item/weapon/tank/T = I
		if(tank)
			to_chat(user, "<span class='notice'>The unit already contains an air tank.</span>")
			return
		to_chat(user, "You load the [T.name] into the storage compartment.")
		user.drop_item()
		T.forceMove(src)
		tank = T
		update_icon()
		updateUsrDialog()
		return
	if( istype(I,/obj/item/clothing/mask) )
		if(!isopen)
			return
		var/obj/item/clothing/mask/M = I
		if(mask)
			to_chat(user, "<span class='notice'>The unit already contains a mask.</span>")
			return
		to_chat(user, "You load the [M.name] into the storage compartment.")
		user.drop_item()
		M.forceMove(src)
		mask = M
		update_icon()
		updateUsrDialog()
		return
	update_icon()
	updateUsrDialog()
	return


/obj/machinery/suit_storage_unit/attack_ai(mob/user as mob)
	return attack_hand(user)

//////////////////////////////REMINDER: Make it lock once you place some fucker inside.

//God this entire file is fucking awful
//Suit painter for Bay's special snowflake aliums.

/obj/machinery/suit_cycler

	name = "suit cycler"
	desc = "An industrial machine for painting and refitting voidsuits."
	anchored = 1
	density = 1

	icon = 'icons/obj/suitstorage.dmi'
	icon_state = "close"

	req_access = list(access_captain,access_heads)

	var/active = 0          // PLEASE HOLD.
	var/safeties = 1        // The cycler won't start with a living thing inside it unless safeties are off.
	var/irradiating = 0     // If this is > 0, the cycler is decontaminating whatever is inside it.
	var/radiation_level = 2 // 1 is removing germs, 2 is removing blood, 3 is removing phoron.
	var/model_text = ""     // Some flavour text for the topic box.
	var/locked = 1          // If locked, nothing can be taken from or added to the cycler.
	var/can_repair          // If set, the cycler can repair voidsuits.
	var/electrified = 0

	//Departments that the cycler can paint suits to look like.
	var/list/departments = list("Engineering","Mining","Medical","Security","Atmos","Science","Pilot")
	//Species that the suits can be configured to fit.
	var/list/species = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI,SPECIES_TAJARA)

	var/target_department
	var/target_species

	var/mob/living/carbon/human/occupant = null
	var/obj/item/clothing/suit/space/void/suit = null
	var/obj/item/clothing/head/helmet/space/helmet = null

	var/datum/wires/suit_storage_unit/wires = null

/obj/machinery/suit_cycler/New()
	..()

	wires = new(src)
	target_department = departments[1]
	target_species = species[1]
	if(!target_department || !target_species) qdel(src)

/obj/machinery/suit_cycler/Destroy()
	qdel(wires)
	wires = null
	return ..()

/obj/machinery/suit_cycler/engineering
	name = "Engineering suit cycler"
	model_text = "Engineering"
	req_access = list(access_construction)
	departments = list("Engineering","Atmos")
	species = list(SPECIES_HUMAN,SPECIES_TAJARA,SPECIES_SKRELL,SPECIES_UNATHI) //Add Unathi when sprites exist for their suits.

/obj/machinery/suit_cycler/mining
	name = "Mining suit cycler"
	model_text = "Mining"
	req_access = list(access_mining)
	departments = list("Mining")
	species = list(SPECIES_HUMAN,SPECIES_TAJARA,SPECIES_SKRELL,SPECIES_UNATHI)

/obj/machinery/suit_cycler/science
	name = "Excavation suit cycler"
	model_text = "Excavation"
	req_access = list(access_xenoarch)
	departments = list("Science")
	species = list(SPECIES_HUMAN,SPECIES_TAJARA,SPECIES_SKRELL,SPECIES_UNATHI)

/obj/machinery/suit_cycler/security
	name = "Security suit cycler"
	model_text = "Security"
	req_access = list(access_security)
	departments = list("Security")
	species = list(SPECIES_HUMAN,SPECIES_TAJARA,SPECIES_SKRELL,SPECIES_UNATHI)

/obj/machinery/suit_cycler/medical
	name = "Medical suit cycler"
	model_text = "Medical"
	req_access = list(access_medical)
	departments = list("Medical")
	species = list(SPECIES_HUMAN,SPECIES_TAJARA,SPECIES_SKRELL,SPECIES_UNATHI)

/obj/machinery/suit_cycler/syndicate
	name = "Nonstandard suit cycler"
	model_text = "Nonstandard"
	req_access = list(access_syndicate)
	departments = list("Mercenary")
	species = list(SPECIES_HUMAN,SPECIES_TAJARA,SPECIES_SKRELL,SPECIES_UNATHI)
	can_repair = 1

/obj/machinery/suit_cycler/pilot
	name = "Pilot suit cycler"
	model_text = "Pilot"
	req_access = list(access_mining_office)
	departments = list("Pilot")
	species = list(SPECIES_HUMAN,SPECIES_TAJARA,SPECIES_SKRELL,SPECIES_UNATHI)

/obj/machinery/suit_cycler/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/suit_cycler/attackby(obj/item/I as obj, mob/user as mob)

	if(electrified != 0)
		if(shock(user, 100))
			return

	//Hacking init.
	if(isMultitool(I) || isWirecutter(I))
		if(panel_open)
			attack_hand(user)
		return
	//Other interface stuff.
	if(istype(I, /obj/item/grab))
		var/obj/item/grab/G = I

		if(!(ismob(G.affecting)))
			return

		if(locked)
			to_chat(user, "<span class='danger'>The suit cycler is locked.</span>")
			return

		if(contents.len > 0)
			to_chat(user, "<span class='danger'>There is no room inside the cycler for [G.affecting.name].</span>")
			return

		visible_message("<span class='notice'>[user] starts putting [G.affecting.name] into the suit cycler.</span>", 3)

		if(do_after(user, 20, src))
			if(!G || !G.affecting) return
			var/mob/M = G.affecting
			if (M.client)
				M.client.perspective = EYE_PERSPECTIVE
				M.client.eye = src
			M.loc = src
			occupant = M

			add_fingerprint(user)
			qdel(G)

			updateUsrDialog()

			return
	else if(isScrewdriver(I))

		panel_open = !panel_open
		to_chat(user, "You [panel_open ?  "open" : "close"] the maintenance panel.")
		updateUsrDialog()
		return

	else if(istype(I,/obj/item/clothing/head/helmet/space) && !istype(I, /obj/item/clothing/head/helmet/space/rig))

		if(locked)
			to_chat(user, "<span class='danger'>The suit cycler is locked.</span>")
			return

		if(helmet)
			to_chat(user, "<span class='danger'>The cycler already contains a helmet.</span>")
			return

		if(I.icon_override == CUSTOM_ITEM_MOB)
			to_chat(user, "You cannot refit a customised voidsuit.")
			return

		to_chat(user, "You fit \the [I] into the suit cycler.")
		user.drop_item()
		I.loc = src
		helmet = I

		update_icon()
		updateUsrDialog()
		return

	else if(istype(I,/obj/item/clothing/suit/space/void))

		if(locked)
			to_chat(user, "<span class='danger'>The suit cycler is locked.</span>")
			return

		if(suit)
			to_chat(user, "<span class='danger'>The cycler already contains a voidsuit.</span>")
			return

		if(I.icon_override == CUSTOM_ITEM_MOB)
			to_chat(user, "You cannot refit a customised voidsuit.")
			return

		to_chat(user, "You fit \the [I] into the suit cycler.")
		user.drop_item()
		I.loc = src
		suit = I

		update_icon()
		updateUsrDialog()
		return

	..()

/obj/machinery/suit_cycler/emag_act(var/remaining_charges, var/mob/user)
	if(emagged)
		to_chat(user, "<span class='danger'>The cycler has already been subverted.</span>")
		return

	//Clear the access reqs, disable the safeties, and open up all paintjobs.
	to_chat(user, "<span class='danger'>You run the sequencer across the interface, corrupting the operating protocols.</span>")
	departments = list("Engineering","Mining","Medical","Security","Atmos","^%###^%$")
	emagged = 1
	safeties = 0
	req_access = list()
	updateUsrDialog()
	return 1

/obj/machinery/suit_cycler/attack_hand(mob/user as mob)
	if(..() || stat & (BROKEN|NOPOWER))
		return

	if(!user.IsAdvancedToolUser())
		return 0

	if(electrified != 0)
		if(shock(user, 100))
			return

	user.set_machine(src)

	var/dat = "<HEAD><TITLE>Suit Cycler Interface</TITLE></HEAD>"

	if(active)
		dat+= "<br><font color='red'><B>The [model_text ? "[model_text] " : ""]suit cycler is currently in use. Please wait...</b></font>"

	else if(locked)
		dat += "<br><font color='red'><B>The [model_text ? "[model_text] " : ""]suit cycler is currently locked. Please contact your system administrator.</b></font>"
		if(allowed(user))
			dat += "<br><a href='?src=\ref[src];toggle_lock=1'>\[unlock unit\]</a>"
	else
		dat += "<h1>Suit cycler</h1>"
		dat += "<B>Welcome to the [model_text ? "[model_text] " : ""]suit cycler control panel. <a href='?src=\ref[src];toggle_lock=1'>\[lock unit\]</a></B><HR>"

		dat += "<h2>Maintenance</h2>"
		dat += "<b>Helmet: </b> [helmet ? "\the [helmet]" : "no helmet stored" ]. <A href='?src=\ref[src];eject_helmet=1'>\[eject\]</a><br/>"
		dat += "<b>Suit: </b> [suit ? "\the [suit]" : "no suit stored" ]. <A href='?src=\ref[src];eject_suit=1'>\[eject\]</a>"

		if(can_repair && suit && istype(suit))
			dat += "[(suit.damage ? " <A href='?src=\ref[src];repair_suit=1'>\[repair\]</a>" : "")]"

		dat += "<br/><b>UV decontamination systems:</b> <font color = '[emagged ? "red'>SYSTEM ERROR" : "green'>READY"]</font><br>"
		dat += "Output level: [radiation_level]<br>"
		dat += "<A href='?src=\ref[src];select_rad_level=1'>\[select power level\]</a> <A href='?src=\ref[src];begin_decontamination=1'>\[begin decontamination cycle\]</a><br><hr>"

		dat += "<h2>Customisation</h2>"
		dat += "<b>Target product:</b> <A href='?src=\ref[src];select_department=1'>[target_department]</a>, <A href='?src=\ref[src];select_species=1'>[target_species]</a>."
		dat += "<A href='?src=\ref[src];apply_paintjob=1'><br>\[apply customisation routine\]</a><br><hr>"

	if(panel_open)
		wires.Interact(user)

	user << browse(dat, "window=suit_cycler")
	onclose(user, "suit_cycler")
	return

/obj/machinery/suit_cycler/Topic(href, href_list)
	if(href_list["eject_suit"])
		if(!suit) return
		suit.loc = get_turf(src)
		suit = null
	else if(href_list["eject_helmet"])
		if(!helmet) return
		helmet.loc = get_turf(src)
		helmet = null
	else if(href_list["select_department"])
		var/choice = input("Please select the target department paintjob.","Suit cycler",null) as null|anything in departments
		if(choice) target_department = choice
	else if(href_list["select_species"])
		var/choice = input("Please select the target species configuration.","Suit cycler",null) as null|anything in species
		if(choice) target_species = choice
	else if(href_list["select_rad_level"])
		var/choices = list(1,2,3)
		if(emagged)
			choices = list(1,2,3,4,5)
		radiation_level = input("Please select the desired radiation level.","Suit cycler",null) as null|anything in choices
	else if(href_list["repair_suit"])

		if(!suit || !can_repair) return
		active = 1
		spawn(100)
			repair_suit()
			finished_job()

	else if(href_list["apply_paintjob"])

		if(!suit && !helmet) return
		active = 1
		spawn(100)
			apply_paintjob()
			finished_job()

	else if(href_list["toggle_safties"])
		safeties = !safeties

	else if(href_list["toggle_lock"])

		if(allowed(usr))
			locked = !locked
			to_chat(usr, "You [locked ? "lock" : "unlock"] [src].")
		else
			to_chat(usr, FEEDBACK_ACCESS_DENIED)

	else if(href_list["begin_decontamination"])

		if(safeties && occupant)
			to_chat(usr, "<span class='danger'>The cycler has detected an occupant. Please remove the occupant before commencing the decontamination cycle.</span>")
			return

		active = 1
		irradiating = 10
		updateUsrDialog()

		sleep(10)

		if(helmet)
			if(radiation_level > 2)
				helmet.decontaminate()
			if(radiation_level > 1)
				helmet.clean_blood()

		if(suit)
			if(radiation_level > 2)
				suit.decontaminate()
			if(radiation_level > 1)
				suit.clean_blood()

	updateUsrDialog()
	return

/obj/machinery/suit_cycler/Process()

	if(electrified > 0)
		electrified--

	if(!active)
		return

	if(active && stat & (BROKEN|NOPOWER))
		active = 0
		irradiating = 0
		electrified = 0
		return

	if(irradiating == 1)
		finished_job()
		irradiating = 0
		return

	irradiating--

	if(occupant)
		if(prob(radiation_level*2)) occupant.emote("scream")
		if(radiation_level > 2)
			occupant.take_organ_damage(0,radiation_level*2 + rand(1,3))
		if(radiation_level > 1)
			occupant.take_organ_damage(0,radiation_level + rand(1,3))
		occupant.apply_effect(radiation_level*10, IRRADIATE, blocked = occupant.getarmor(null, "rad"))

/obj/machinery/suit_cycler/proc/finished_job()
	var/turf/T = get_turf(src)
	T.visible_message("\icon[src]<span class='notice'>The [src] pings loudly.</span>")
	icon_state = initial(icon_state)
	active = 0
	updateUsrDialog()

/obj/machinery/suit_cycler/proc/repair_suit()
	if(!suit || !suit.damage || !suit.can_breach)
		return

	suit.breaches = list()
	suit.calc_breach_damage()

	return

/obj/machinery/suit_cycler/verb/leave()
	set name = "Eject Cycler"
	set category = "Object"
	set src in oview(1)

	if (usr.stat != 0)
		return

	eject_occupant(usr)

/obj/machinery/suit_cycler/proc/eject_occupant(mob/user as mob)

	if(locked || active)
		to_chat(user, "<span class='warning'>The cycler is locked.</span>")
		return

	if (!occupant)
		return

	if (occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE

	occupant.loc = get_turf(occupant)
	occupant = null

	add_fingerprint(user)
	updateUsrDialog()
	update_icon()

	return

//There HAS to be a less bloated way to do this. TODO: some kind of table/icon name coding? ~Z
/obj/machinery/suit_cycler/proc/apply_paintjob()

	if(!target_species || !target_department)
		return

	if(target_species)
		if(helmet) helmet.refit_for_species(target_species)
		if(suit) suit.refit_for_species(target_species)

	switch(target_department)
		if("Engineering")
			if(helmet)
				helmet.name = "engineering voidsuit helmet"
				helmet.icon_state = "rig0-engineering"
				helmet.item_state = "eng_helm"
			if(suit)
				suit.name = "engineering voidsuit"
				suit.icon_state = "rig-engineering"
				suit.item_state_slots = list(
					slot_l_hand_str = "eng_voidsuit",
					slot_r_hand_str = "eng_voidsuit",
				)
		if("Mining")
			if(helmet)
				helmet.name = "mining voidsuit helmet"
				helmet.icon_state = "rig0-mining"
				helmet.item_state = "mining_helm"
			if(suit)
				suit.name = "mining voidsuit"
				suit.icon_state = "rig-mining"
				suit.item_state_slots = list(
					slot_l_hand_str = "mining_voidsuit",
					slot_r_hand_str = "mining_voidsuit",
				)
		if("Science")
			if(helmet)
				helmet.name = "excavation voidsuit helmet"
				helmet.icon_state = "rig0-excavation"
				helmet.item_state = "excavation_helm"
			if(suit)
				suit.name = "excavation voidsuit"
				suit.icon_state = "rig-excavation"
				suit.item_state_slots = list(
					slot_l_hand_str = "excavation_voidsuit",
					slot_r_hand_str = "excavation_voidsuit",
				)
		if("Medical")
			if(helmet)
				helmet.name = "medical voidsuit helmet"
				helmet.icon_state = "rig0-medical"
				helmet.item_state = "medical_helm"
			if(suit)
				suit.name = "medical voidsuit"
				suit.icon_state = "rig-medical"
				suit.item_state_slots = list(
					slot_l_hand_str = "medical_voidsuit",
					slot_r_hand_str = "medical_voidsuit",
				)
		if("Security")
			if(helmet)
				helmet.name = "security voidsuit helmet"
				helmet.icon_state = "rig0-sec"
				helmet.item_state = "sec_helm"
			if(suit)
				suit.name = "security voidsuit"
				suit.icon_state = "rig-sec"
				suit.item_state_slots = list(
					slot_l_hand_str = "sec_voidsuit",
					slot_r_hand_str = "sec_voidsuit",
				)
		if("Atmos")
			if(helmet)
				helmet.name = "atmospherics voidsuit helmet"
				helmet.icon_state = "rig0-atmos"
				helmet.item_state = "atmos_helm"
			if(suit)
				suit.name = "atmospherics voidsuit"
				suit.icon_state = "rig-atmos"
				suit.item_state_slots = list(
					slot_l_hand_str = "atmos_voidsuit",
					slot_r_hand_str = "atmos_voidsuit",
				)
		if("Explorer")
			if(helmet)
				helmet.name = "exploration voidsuit helmet"
				helmet.icon_state = "helm_explorer"
				helmet.item_state = "helm_explorer"
			if(suit)
				suit.name = "exploration voidsuit"
				suit.icon_state = "void_explorer"

		if("^%###^%$" || "Mercenary")
			if(helmet)
				helmet.name = "blood-red voidsuit helmet"
				helmet.icon_state = "rig0-syndie"
				helmet.item_state = "syndie_helm"
			if(suit)
				suit.name = "blood-red voidsuit"
				suit.icon_state = "rig-syndie"
				suit.item_state_slots = list(
					slot_l_hand_str = "syndie_voidsuit",
					slot_r_hand_str = "syndie_voidsuit",
				)
		if("Pilot")
			if(helmet)
				helmet.name = "pilot voidsuit helmet"
				helmet.icon_state = "rig0_pilot"
				helmet.item_state = "pilot_helm"
			if(suit)
				suit.name = "pilot voidsuit"
				suit.icon_state = "rig-pilot"

	if(helmet) helmet.name = "refitted [helmet.name]"
	if(suit) suit.name = "refitted [suit.name]"