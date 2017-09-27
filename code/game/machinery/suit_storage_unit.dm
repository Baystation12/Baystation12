//////////////////////////////////////
// SUIT STORAGE UNIT /////////////////
//////////////////////////////////////


/obj/machinery/suit_storage_unit
	name = "Suit Storage Unit"
	desc = "An industrial U-Stor-It Storage unit designed to accomodate all kinds of space suits. Its on-board equipment also allows the user to decontaminate the contents through a UV-ray purging cycle. There's a warning label dangling from the control pad, reading \"STRICTLY NO BIOLOGICALS IN THE CONFINES OF THE UNIT\"."
	icon = 'icons/obj/suitstorage.dmi'
	icon_state = "suitstorage000000100" //order is: [has helmet][has suit][has human][is open][is locked][is UV cycling][is powered][is dirty/broken] [is superUVcycling]
	anchored = 1
	density = 1
	req_access = list()
	var/mob/living/carbon/human/OCCUPANT = null
	var/obj/item/clothing/suit/space/SUIT = null
	var/SUIT_TYPE = null
	var/obj/item/clothing/head/helmet/space/HELMET = null
	var/HELMET_TYPE = null
	var/obj/item/clothing/shoes/magboots/BOOTS = null
	var/BOOTS_TYPE = null
	var/obj/item/weapon/tank/TANK = null
	var/TANK_TYPE = null
	var/obj/item/clothing/mask/MASK = null  //All the stuff that's gonna be stored insiiiiiiiiiiiiiiiiiiide, nyoro~n
	var/MASK_TYPE = null //Erro's idea on standarising SSUs whle keeping creation of other SSU types easy: Make a child SSU, name it something then set the TYPE vars to your desired suit output. New() should take it from there by itself.
	var/isopen = 0
	var/islocked = 0
	var/isUV = 0
	var/ispowered = 1 //starts powered
	var/isbroken = 0
	var/issuperUV = 0
	var/panelopen = 0
	var/safetieson = 1
	var/cycletime_left = 0

//The units themselves/////////////////

/obj/machinery/suit_storage_unit/standard_unit
	SUIT_TYPE = /obj/item/clothing/suit/space
	HELMET_TYPE = /obj/item/clothing/head/helmet/space
	TANK_TYPE = /obj/item/weapon/tank/oxygen
	MASK_TYPE = /obj/item/clothing/mask/breath
	req_access = list(access_eva)

/obj/machinery/suit_storage_unit/atmos
	name = "Atmospherics Voidsuit Storage Unit"
	SUIT_TYPE = /obj/item/clothing/suit/space/void/atmos
	HELMET_TYPE = /obj/item/clothing/head/helmet/space/void/atmos
	BOOTS_TYPE = /obj/item/clothing/shoes/magboots
	TANK_TYPE = /obj/item/weapon/tank/oxygen
	MASK_TYPE = /obj/item/clothing/mask/breath
	req_access = list(access_atmospherics)
	islocked = 1

/obj/machinery/suit_storage_unit/atmos/alt
	SUIT_TYPE = /obj/item/clothing/suit/space/void/atmos/alt
	HELMET_TYPE = /obj/item/clothing/head/helmet/space/void/atmos/alt

/obj/machinery/suit_storage_unit/engineering
	name = "Engineering Voidsuit Storage Unit"
	SUIT_TYPE = /obj/item/clothing/suit/space/void/engineering
	HELMET_TYPE = /obj/item/clothing/head/helmet/space/void/engineering
	BOOTS_TYPE = /obj/item/clothing/shoes/magboots
	TANK_TYPE = /obj/item/weapon/tank/oxygen
	MASK_TYPE = /obj/item/clothing/mask/breath
	req_access = list(access_engine)
	islocked = 1

/obj/machinery/suit_storage_unit/engineering/alt
	SUIT_TYPE = /obj/item/clothing/suit/space/void/engineering/alt
	HELMET_TYPE = /obj/item/clothing/head/helmet/space/void/engineering/alt
	MASK_TYPE = /obj/item/clothing/mask/breath

/obj/machinery/suit_storage_unit/engineering/salvage
	SUIT_TYPE = /obj/item/clothing/suit/space/void/engineering/salvage
	HELMET_TYPE = /obj/item/clothing/head/helmet/space/void/engineering/salvage
	MASK_TYPE = /obj/item/clothing/mask/breath

/obj/machinery/suit_storage_unit/medical
	name = "Medical Voidsuit Storage Unit"
	SUIT_TYPE = /obj/item/clothing/suit/space/void/medical
	HELMET_TYPE = /obj/item/clothing/head/helmet/space/void/medical
	BOOTS_TYPE = /obj/item/clothing/shoes/magboots
	TANK_TYPE = /obj/item/weapon/tank/oxygen
	MASK_TYPE = /obj/item/clothing/mask/breath
	req_access = list(access_medical)
	islocked = 1

/obj/machinery/suit_storage_unit/medical/alt
	SUIT_TYPE = /obj/item/clothing/suit/space/void/medical/alt
	HELMET_TYPE = /obj/item/clothing/head/helmet/space/void/medical/alt
	MASK_TYPE = /obj/item/clothing/mask/breath

/obj/machinery/suit_storage_unit/mining
	name = "Mining Voidsuit Storage Unit"
	SUIT_TYPE = /obj/item/clothing/suit/space/void/mining
	HELMET_TYPE = /obj/item/clothing/head/helmet/space/void/mining
	BOOTS_TYPE = /obj/item/clothing/shoes/magboots
	TANK_TYPE = /obj/item/weapon/tank/oxygen
	MASK_TYPE = /obj/item/clothing/mask/breath
	req_access = list(access_mining)
	islocked = 1

/obj/machinery/suit_storage_unit/mining/alt
	SUIT_TYPE = /obj/item/clothing/suit/space/void/mining/alt
	HELMET_TYPE = /obj/item/clothing/head/helmet/space/void/mining/alt
	MASK_TYPE = /obj/item/clothing/mask/breath

/obj/machinery/suit_storage_unit/science
	name = "Excavation Voidsuit Storage Unit"
	SUIT_TYPE = /obj/item/clothing/suit/space/void/excavation
	HELMET_TYPE = /obj/item/clothing/head/helmet/space/void/excavation
	BOOTS_TYPE = /obj/item/clothing/shoes/magboots
	TANK_TYPE = /obj/item/weapon/tank/oxygen
	MASK_TYPE = /obj/item/clothing/mask/breath
	req_access = list(access_xenoarch)
	islocked = 1

/obj/machinery/suit_storage_unit/security
	name = "Security Voidsuit Storage Unit"
	SUIT_TYPE = /obj/item/clothing/suit/space/void/security
	HELMET_TYPE = /obj/item/clothing/head/helmet/space/void/security
	BOOTS_TYPE = /obj/item/clothing/shoes/magboots
	TANK_TYPE = /obj/item/weapon/tank/oxygen
	MASK_TYPE = /obj/item/clothing/mask/breath
	req_access = list(access_security)
	islocked = 1

/obj/machinery/suit_storage_unit/security/alt
	SUIT_TYPE = /obj/item/clothing/suit/space/void/security/alt
	HELMET_TYPE = /obj/item/clothing/head/helmet/space/void/security/alt
	MASK_TYPE = /obj/item/clothing/mask/breath

/obj/machinery/suit_storage_unit/merc
	name = "Nonstandard Voidsuit Storage Unit"
	SUIT_TYPE = /obj/item/clothing/suit/space/void/merc
	HELMET_TYPE = /obj/item/clothing/head/helmet/space/void/merc
	BOOTS_TYPE = /obj/item/clothing/shoes/magboots
	TANK_TYPE = /obj/item/weapon/tank/oxygen
	MASK_TYPE = /obj/item/clothing/mask/breath
	req_access = list(access_syndicate)
	islocked = 1



/obj/machinery/suit_storage_unit/New()
	src.update_icon()
	if(SUIT_TYPE)
		SUIT = new SUIT_TYPE(src)
	if(HELMET_TYPE)
		HELMET = new HELMET_TYPE(src)
	if(BOOTS_TYPE)
		BOOTS = new BOOTS_TYPE(src)
	if(TANK_TYPE)
		TANK = new TANK_TYPE(src)
	if(MASK_TYPE)
		MASK = new MASK_TYPE(src)

/obj/machinery/suit_storage_unit/update_icon()
	var/hashelmet = 0
	var/hassuit = 0
	var/hashuman = 0
	if(HELMET)
		hashelmet = 1
	if(SUIT)
		hassuit = 1
	if(OCCUPANT)
		hashuman = 1
	icon_state = text("suitstorage[][][][][][][][][]",hashelmet,hassuit,hashuman,src.isopen,src.islocked,src.isUV,src.ispowered,src.isbroken,src.issuperUV)


/obj/machinery/suit_storage_unit/power_change()
	. = ..()
	if(.)
		if( !(stat & NOPOWER) )
			src.ispowered = 1
			src.update_icon()
		else
			spawn(rand(0, 15))
				src.ispowered = 0
				src.islocked = 0
				src.isopen = 1
				src.dump_everything()
				src.update_icon()


/obj/machinery/suit_storage_unit/ex_act(severity)
	switch(severity)
		if(1.0)
			if(prob(50))
				src.dump_everything() //So suits dont survive all the time
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				src.dump_everything()
				qdel(src)
			return
		else
			return
	return


/obj/machinery/suit_storage_unit/attack_hand(mob/user as mob)
	var/dat
	if(..())
		return
	if(stat & NOPOWER)
		return
	if(!user.IsAdvancedToolUser())
		return 0
	if(src.panelopen) //The maintenance panel is open. Time for some shady stuff
		dat+= "<HEAD><TITLE>Suit storage unit: Maintenance panel</TITLE></HEAD>"
		dat+= "<Font color ='black'><B>Maintenance panel controls</B></font><HR>"
		dat+= "<font color ='grey'>The panel is ridden with controls, button and meters, labeled in strange signs and symbols that <BR>you cannot understand. Probably the manufactoring world's language.<BR> Among other things, a few controls catch your eye.</font><BR><BR>"
		dat+= text("<font color ='black'>A small dial with a small lambda symbol on it. It's pointing towards a gauge that reads []</font>.<BR> <font color='blue'><A href='?src=\ref[];toggleUV=1'> Turn towards []</A></font><BR>",(src.issuperUV ? "15nm" : "185nm"),src,(src.issuperUV ? "185nm" : "15nm") )
		dat+= text("<font color ='black'>A thick old-style button, with 2 grimy LED lights next to it. The [] LED is on.</font><BR><font color ='blue'><A href='?src=\ref[];togglesafeties=1'>Press button</a></font>",(src.safetieson? "<font color='green'><B>GREEN</B></font>" : "<font color='red'><B>RED</B></font>"),src)
		dat+= text("<HR><BR><A href='?src=\ref[];mach_close=suit_storage_unit'>Close panel</A>", user)
		//user << browse(dat, "window=ssu_m_panel;size=400x500")
		//onclose(user, "ssu_m_panel")
	else if(src.isUV) //The thing is running its cauterisation cycle. You have to wait.
		dat += "<HEAD><TITLE>Suit storage unit</TITLE></HEAD>"
		dat+= "<font color ='red'><B>Unit is cauterising contents with selected UV ray intensity. Please wait.</font></B><BR>"
		//dat+= "<font colr='black'><B>Cycle end in: [src.cycletimeleft()] seconds. </font></B>"
		//user << browse(dat, "window=ssu_cycling_panel;size=400x500")
		//onclose(user, "ssu_cycling_panel")

	else
		if(!src.isbroken)
			dat+= "<HEAD><TITLE>Suit storage unit</TITLE></HEAD>"
			dat+= "<font color='blue'><font size = 4><B>U-Stor-It Suit Storage Unit, model DS1900</B></FONT><BR>"
			dat+= "<B>Welcome to the Unit control panel.</B></FONT><HR>"
			dat+= text("<font color='black'>Helmet storage compartment: <B>[]</B></font><BR>",(src.HELMET ? HELMET.name : "</font><font color ='grey'>No helmet detected.") )
			if(HELMET && src.isopen)
				dat+=text("<A href='?src=\ref[];dispense_helmet=1'>Dispense helmet</A><BR>",src)
			dat+= text("<font color='black'>Suit storage compartment: <B>[]</B></font><BR>",(src.SUIT ? SUIT.name : "</font><font color ='grey'>No suit detected.") )
			if(SUIT && src.isopen)
				dat+=text("<A href='?src=\ref[];dispense_suit=1'>Dispense suit</A><BR>",src)
			dat+= text("<font color='black'>Footwear storage compartment: <B>[]</B></font><BR>",(src.BOOTS ? BOOTS.name : "</font><font color ='grey'>No footwear detected.") )
			if(BOOTS && src.isopen)
				dat+=text("<A href='?src=\ref[];dispense_boots=1'>Dispense footwear</A><BR>",src)
			dat+= text("<font color='black'>Tank storage compartment: <B>[]</B></font><BR>",(src.TANK ? TANK.name : "</font><font color ='grey'>No air tank detected.") )
			if(TANK && src.isopen)
				dat+=text("<A href='?src=\ref[];dispense_tank=1'>Dispense air tank</A><BR>",src)
			dat+= text("<font color='black'>Breathmask storage compartment: <B>[]</B></font><BR>",(src.MASK ? MASK.name : "</font><font color ='grey'>No breathmask detected.") )
			if(MASK && src.isopen)
				dat+=text("<A href='?src=\ref[];dispense_mask=1'>Dispense mask</A><BR>",src)
			if(src.OCCUPANT)
				dat+= "<HR><B><font color ='red'>WARNING: Biological entity detected inside the Unit's storage. Please remove.</B></font><BR>"
				dat+= "<A href='?src=\ref[src];eject_guy=1'>Eject extra load</A>"
			dat+= text("<HR><font color='black'>Unit is: [] - <A href='?src=\ref[];toggle_open=1'>[] Unit</A></font> ",(src.isopen ? "Open" : "Closed"),src,(src.isopen ? "Close" : "Open"))
			if(src.isopen)
				dat+="<HR>"
			else
				dat+= text(" - <A href='?src=\ref[];toggle_lock=1'><font color ='orange'>*[] Unit*</A></font><HR>",src,(src.islocked ? "Unlock" : "Lock") )
			dat+= text("Unit status: []",(src.islocked? "<font color ='red'><B>**LOCKED**</B></font><BR>" : "<font color ='green'><B>**UNLOCKED**</B></font><BR>") )
			dat+= text("<A href='?src=\ref[];start_UV=1'>Start Disinfection cycle</A><BR>",src)
			dat += text("<BR><BR><A href='?src=\ref[];mach_close=suit_storage_unit'>Close control panel</A>", user)
			//user << browse(dat, "window=Suit Storage Unit;size=400x500")
			//onclose(user, "Suit Storage Unit")
		else //Ohhhh shit it's dirty or broken! Let's inform the guy.
			dat+= "<HEAD><TITLE>Suit storage unit</TITLE></HEAD>"
			dat+= "<font color='maroon'><B>Unit chamber is too contaminated to continue usage. Please call for a qualified individual to perform maintenance.</font></B><BR><BR>"
			dat+= text("<HR><A href='?src=\ref[];mach_close=suit_storage_unit'>Close control panel</A>", user)
			//user << browse(dat, "window=suit_storage_unit;size=400x500")
			//onclose(user, "suit_storage_unit")

	user << browse(dat, "window=suit_storage_unit;size=400x500")
	onclose(user, "suit_storage_unit")
	return


/obj/machinery/suit_storage_unit/Topic(href, href_list) //I fucking HATE this proc
	if(..())
		return
	if ((usr.contents.Find(src) || ((get_dist(src, usr) <= 1) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon/ai)))
		usr.set_machine(src)
		if (href_list["toggleUV"])
			src.toggleUV(usr)
			src.updateUsrDialog()
			src.update_icon()
		if (href_list["togglesafeties"])
			src.togglesafeties(usr)
			src.updateUsrDialog()
			src.update_icon()
		if (href_list["dispense_helmet"])
			src.dispense_helmet(usr)
			src.updateUsrDialog()
			src.update_icon()
		if (href_list["dispense_suit"])
			src.dispense_suit(usr)
			src.updateUsrDialog()
			src.update_icon()
		if (href_list["dispense_boots"])
			src.dispense_boots(usr)
			src.updateUsrDialog()
			src.update_icon()
		if (href_list["dispense_tank"])
			src.dispense_tank(usr)
			src.updateUsrDialog()
			src.update_icon()
		if (href_list["dispense_mask"])
			src.dispense_mask(usr)
			src.updateUsrDialog()
			src.update_icon()
		if (href_list["toggle_open"])
			src.toggle_open(usr)
			src.updateUsrDialog()
			src.update_icon()
		if (href_list["toggle_lock"])
			src.toggle_lock(usr)
			src.updateUsrDialog()
			src.update_icon()
		if (href_list["start_UV"])
			src.start_UV(usr)
			src.updateUsrDialog()
			src.update_icon()
		if (href_list["eject_guy"])
			src.eject_occupant(usr)
			src.updateUsrDialog()
			src.update_icon()
	/*if (href_list["refresh"])
		src.updateUsrDialog()*/
	src.add_fingerprint(usr)
	return


/obj/machinery/suit_storage_unit/proc/toggleUV(mob/user as mob)
//	var/protected = 0
//	var/mob/living/carbon/human/H = user
	if(!src.panelopen)
		return

	/*if(istype(H)) //Let's check if the guy's wearing electrically insulated gloves
		if(H.gloves)
			var/obj/item/clothing/gloves/G = H.gloves
			if(istype(G,/obj/item/clothing/gloves/insulated))
				protected = 1

	if(!protected)
		playsound(src.loc, "sparks", 75, 1, -1)
		to_chat(user, "<span class='warning'>You try to touch the controls but you get zapped. There must be a short circuit somewhere.</span>")
		return*/
	else  //welp, the guy is protected, we can continue
		if(src.issuperUV)
			to_chat(user, "You slide the dial back towards \"185nm\".")
			src.issuperUV = 0
		else
			to_chat(user, "You crank the dial all the way up to \"15nm\".")
			src.issuperUV = 1
		return


/obj/machinery/suit_storage_unit/proc/togglesafeties(mob/user as mob)
//	var/protected = 0
//	var/mob/living/carbon/human/H = user
	if(!src.panelopen) //Needed check due to bugs
		return

	/*if(istype(H)) //Let's check if the guy's wearing electrically insulated gloves
		if(H.gloves)
			var/obj/item/clothing/gloves/G = H.gloves
			if(istype(G,/obj/item/clothing/gloves/insulated) )
				protected = 1

	if(!protected)
		playsound(src.loc, "sparks", 75, 1, -1)
		to_chat(user, "<span class='warning'>You try to touch the controls but you get zapped. There must be a short circuit somewhere.</span>")
		return*/
	else
		to_chat(user, "You push the button. The coloured LED next to it changes.")
		src.safetieson = !src.safetieson

#define dispense_clothing(item) if(src.item){item.dropInto(loc); src.item = null}

/obj/machinery/suit_storage_unit/proc/dispense_helmet(mob/user as mob)
	dispense_clothing(HELMET)

/obj/machinery/suit_storage_unit/proc/dispense_suit(mob/user as mob)
	dispense_clothing(SUIT)

/obj/machinery/suit_storage_unit/proc/dispense_boots(mob/user as mob)
	dispense_clothing(BOOTS)

/obj/machinery/suit_storage_unit/proc/dispense_tank(mob/user as mob)
	dispense_clothing(TANK)

/obj/machinery/suit_storage_unit/proc/dispense_mask(mob/user as mob)
	dispense_clothing(MASK)


/obj/machinery/suit_storage_unit/proc/dump_everything()
	src.islocked = 0 //locks go free
	dispense_clothing(SUIT)
	dispense_clothing(HELMET)
	dispense_clothing(BOOTS)
	dispense_clothing(TANK)
	dispense_clothing(MASK)
	if(src.OCCUPANT)
		src.eject_occupant(OCCUPANT)
	return

#undef dispense_clothing

/obj/machinery/suit_storage_unit/proc/toggle_open(mob/user as mob)
	if(src.islocked || src.isUV)
		to_chat(user, "<span class='warning'>Unable to open unit.</span>")
		return
	if(src.OCCUPANT)
		src.eject_occupant(user)
		return  // eject_occupant opens the door, so we need to return
	src.isopen = !src.isopen
	return


/obj/machinery/suit_storage_unit/proc/toggle_lock(mob/user as mob)
	if(src.OCCUPANT && src.safetieson)
		to_chat(user, "<span class='warning'>The Unit's safety protocols disallow locking when a biological form is detected inside its compartments.</span>")
		return
	if(src.isopen)
		return
	src.islocked = !src.islocked
	return


/obj/machinery/suit_storage_unit/proc/start_UV(mob/user as mob)
	if(src.isUV || src.isopen) //I'm bored of all these sanity checks
		return
	if(src.OCCUPANT && src.safetieson)
		to_chat(user, "<span class='danger'>WARNING:</span><span class='warning'> Biological entity detected in the confines of the Unit's storage. Cannot initiate cycle.</span>")
		return
	if(!src.HELMET && !src.MASK && !src.SUIT && !src.BOOTS && !src.TANK && !src.OCCUPANT ) //shit's empty yo
		to_chat(user, "<span class='warning'>Unit storage bays empty. Nothing to disinfect -- Aborting.</span>")
		return
	to_chat(user, "You start the Unit's cauterisation cycle.")
	src.cycletime_left = 20
	src.isUV = 1
	if(src.OCCUPANT && !src.islocked)
		src.islocked = 1 //Let's lock it for good measure
	src.update_icon()
	src.updateUsrDialog()

	var/i //our counter
	for(i=0,i<4,i++)
		sleep(50)
		if(src.OCCUPANT)
			OCCUPANT.apply_effect(50, IRRADIATE, blocked = OCCUPANT.getarmor(null, "rad"))
			var/obj/item/organ/internal/diona/nutrients/rad_organ = locate() in OCCUPANT.internal_organs
			if (!rad_organ)
				if (OCCUPANT.can_feel_pain())
					OCCUPANT.emote("scream")
				if(src.issuperUV)
					var/burndamage = rand(28,35)
					OCCUPANT.take_organ_damage(0,burndamage)
				else
					var/burndamage = rand(6,10)
					OCCUPANT.take_organ_damage(0,burndamage)
		if(i==3) //End of the cycle
			if(!src.issuperUV)
				if(src.HELMET)
					HELMET.clean_blood()
				if(src.SUIT)
					SUIT.clean_blood()
				if(src.BOOTS)
					BOOTS.clean_blood()
				if(src.TANK)
					TANK.clean_blood()
				if(src.MASK)
					MASK.clean_blood()
			else //It was supercycling, destroy everything
				if(src.HELMET)
					src.HELMET = null
				if(src.SUIT)
					src.SUIT = null
				if(src.BOOTS)
					src.BOOTS = null
				if(src.TANK)
					src.TANK = null
				if(src.MASK)
					src.MASK = null
				visible_message("<font color='red'>With a loud whining noise, the Suit Storage Unit's door grinds open. Puffs of ashen smoke come out of its chamber.</font>", 3)
				src.isbroken = 1
				src.isopen = 1
				src.islocked = 0
				src.eject_occupant(OCCUPANT) //Mixing up these two lines causes bug. DO NOT DO IT.
			src.isUV = 0 //Cycle ends
	src.update_icon()
	src.updateUsrDialog()
	return

/*	spawn(200) //Let's clean dat shit after 20 secs  //Eh, this doesn't work
		if(src.HELMET)
			HELMET.clean_blood()
		if(src.SUIT)
			SUIT.clean_blood()
		if(src.MASK)
			MASK.clean_blood()
		src.isUV = 0 //Cycle ends
		src.update_icon()
		src.updateUsrDialog()

	var/i
	for(i=0,i<4,i++) //Gradually give the guy inside some damaged based on the intensity
		spawn(50)
			if(src.OCCUPANT)
				if(src.issuperUV)
					OCCUPANT.take_organ_damage(0,40)
					to_chat(user, "Test. You gave him 40 damage")
				else
					OCCUPANT.take_organ_damage(0,8)
					to_chat(user, "Test. You gave him 8 damage")
	return*/


/obj/machinery/suit_storage_unit/proc/cycletimeleft()
	if(src.cycletime_left >= 1)
		src.cycletime_left--
	return src.cycletime_left


/obj/machinery/suit_storage_unit/proc/eject_occupant(mob/user as mob)
	if (src.islocked)
		return

	if (!src.OCCUPANT)
		return
//	for(var/obj/O in src)
//		O.loc = src.loc

	if (src.OCCUPANT.client)
		if(user != OCCUPANT)
			to_chat(OCCUPANT, "<span class='notice'>The machine kicks you out!</span>")
		if(user.loc != src.loc)
			to_chat(OCCUPANT, "<span class='notice'>You leave the not-so-cozy confines of the SSU.</span>")

		src.OCCUPANT.client.eye = src.OCCUPANT.client.mob
		src.OCCUPANT.client.perspective = MOB_PERSPECTIVE
	src.OCCUPANT.loc = src.loc
	src.OCCUPANT = null
	if(!src.isopen)
		src.isopen = 1
	src.update_icon()
	return


/obj/machinery/suit_storage_unit/verb/get_out()
	set name = "Eject Suit Storage Unit"
	set category = "Object"
	set src in oview(1)

	if (usr.stat != 0)
		return
	src.eject_occupant(usr)
	add_fingerprint(usr)
	src.updateUsrDialog()
	src.update_icon()
	return


/obj/machinery/suit_storage_unit/verb/move_inside()
	set name = "Hide in Suit Storage Unit"
	set category = "Object"
	set src in oview(1)

	if (usr.stat != 0)
		return
	if (!src.isopen)
		to_chat(usr, "<span class='warning'>The unit's doors are shut.</span>")
		return
	if (!src.ispowered || src.isbroken)
		to_chat(usr, "<span class='warning'>The unit is not operational.</span>")
		return
	if ( (src.OCCUPANT) || (src.HELMET) || (src.SUIT) )
		to_chat(usr, "<span class='warning'>It's too cluttered inside for you to fit in!</span>")
		return
	visible_message("\The [usr] starts squeezing into the suit storage unit!", 3)
	if(do_after(usr, 10, src))
		usr.stop_pulling()
		usr.client.perspective = EYE_PERSPECTIVE
		usr.client.eye = src
		usr.loc = src
//		usr.metabslow = 1
		src.OCCUPANT = usr
		src.isopen = 0 //Close the thing after the guy gets inside
		src.update_icon()

//		for(var/obj/O in src)
//			qdel(O)

		src.add_fingerprint(usr)
		src.updateUsrDialog()
		return
	else
		src.OCCUPANT = null //Testing this as a backup sanity test
	return


/obj/machinery/suit_storage_unit/attackby(obj/item/I as obj, mob/user as mob)
	if(!src.ispowered)
		return
	if(istype(I, /obj/item/weapon/screwdriver))
		src.panelopen = !src.panelopen
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 100, 1)
		to_chat(user, text("<span class='notice'>You [] the unit's maintenance panel.</span>",(src.panelopen ? "open up" : "close") ))
		src.updateUsrDialog()
		return
	if ( istype(I, /obj/item/grab) )
		var/obj/item/grab/G = I
		if( !(ismob(G.affecting)) )
			return
		if (!src.isopen)
			to_chat(usr, "<span class='warning'>The unit's doors are shut.</span>")
			return
		if (!src.ispowered || src.isbroken)
			to_chat(usr, "<span class='warning'>The unit is not operational.</span>")
			return
		if ( (src.OCCUPANT) || (src.HELMET) || (src.SUIT) || (src.BOOTS) || (src.TANK) || (src.MASK)) //Unit needs to be absolutely empty
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
			src.OCCUPANT = M
			src.isopen = 0 //close ittt

			//for(var/obj/O in src)
			//	O.loc = src.loc
			src.add_fingerprint(user)
			qdel(G)
			src.updateUsrDialog()
			src.update_icon()
			return
		return
	if( istype(I,/obj/item/clothing/suit/space) )
		if(!src.isopen)
			return
		var/obj/item/clothing/suit/space/S = I
		if(src.SUIT)
			to_chat(user, "<span class='notice'>The unit already contains a suit.</span>")
			return
		to_chat(user, "You load the [S.name] into the storage compartment.")
		user.drop_item()
		S.forceMove(src)
		src.SUIT = S
		src.update_icon()
		src.updateUsrDialog()
		return
	if( istype(I,/obj/item/clothing/head/helmet/space) )
		if(!src.isopen)
			return
		var/obj/item/clothing/head/helmet/H = I
		if(src.HELMET)
			to_chat(user, "<span class='notice'>The unit already contains a helmet.</span>")
			return
		to_chat(user, "You load the [H.name] into the storage compartment.")
		user.drop_item()
		H.forceMove(src)
		src.HELMET = H
		src.update_icon()
		src.updateUsrDialog()
		return
	if( istype(I,/obj/item/clothing/shoes/magboots) )
		if(!src.isopen)
			return
		var/obj/item/clothing/shoes/magboots/B = I
		if(src.BOOTS)
			to_chat(user, "<span class='notice'>The unit already contains a pair of magboots.</span>")
			return
		to_chat(user, "You load the [B.name] into the storage compartment.")
		user.drop_item()
		B.forceMove(src)
		src.BOOTS = B
		src.update_icon()
		src.updateUsrDialog()
		return
	if( istype(I,/obj/item/weapon/tank) )
		if(!src.isopen)
			return
		var/obj/item/weapon/tank/T = I
		if(src.TANK)
			to_chat(user, "<span class='notice'>The unit already contains an air tank.</span>")
			return
		to_chat(user, "You load the [T.name] into the storage compartment.")
		user.drop_item()
		T.forceMove(src)
		src.TANK = T
		src.update_icon()
		src.updateUsrDialog()
		return
	if( istype(I,/obj/item/clothing/mask) )
		if(!src.isopen)
			return
		var/obj/item/clothing/mask/M = I
		if(src.MASK)
			to_chat(user, "<span class='notice'>The unit already contains a mask.</span>")
			return
		to_chat(user, "You load the [M.name] into the storage compartment.")
		user.drop_item()
		M.forceMove(src)
		src.MASK = M
		src.update_icon()
		src.updateUsrDialog()
		return
	src.update_icon()
	src.updateUsrDialog()
	return


/obj/machinery/suit_storage_unit/attack_ai(mob/user as mob)
	return src.attack_hand(user)

//////////////////////////////REMINDER: Make it lock once you place some fucker inside.

//God this entire file is fucking awful
//Suit painter for Bay's special snowflake aliums.

/obj/machinery/suit_cycler

	name = "suit cycler"
	desc = "An industrial machine for painting and refitting voidsuits."
	anchored = 1
	density = 1

	icon = 'icons/obj/suitstorage.dmi'
	icon_state = "suitstorage000000100"

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
	return src.attack_hand(user)

/obj/machinery/suit_cycler/attackby(obj/item/I as obj, mob/user as mob)

	if(electrified != 0)
		if(src.shock(user, 100))
			return

	//Hacking init.
	if(istype(I, /obj/item/device/multitool) || istype(I, /obj/item/weapon/wirecutters))
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

		if(src.contents.len > 0)
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
			src.occupant = M

			src.add_fingerprint(user)
			qdel(G)

			src.updateUsrDialog()

			return
	else if(istype(I,/obj/item/weapon/screwdriver))

		panel_open = !panel_open
		to_chat(user, "You [panel_open ?  "open" : "close"] the maintenance panel.")
		src.updateUsrDialog()
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

		src.update_icon()
		src.updateUsrDialog()
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

		src.update_icon()
		src.updateUsrDialog()
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
	src.updateUsrDialog()
	return 1

/obj/machinery/suit_cycler/attack_hand(mob/user as mob)

	add_fingerprint(user)

	if(..() || stat & (BROKEN|NOPOWER))
		return

	if(!user.IsAdvancedToolUser())
		return 0

	if(electrified != 0)
		if(src.shock(user, 100))
			return

	usr.set_machine(src)

	var/dat = "<HEAD><TITLE>Suit Cycler Interface</TITLE></HEAD>"

	if(src.active)
		dat+= "<br><font color='red'><B>The [model_text ? "[model_text] " : ""]suit cycler is currently in use. Please wait...</b></font>"

	else if(locked)
		dat += "<br><font color='red'><B>The [model_text ? "[model_text] " : ""]suit cycler is currently locked. Please contact your system administrator.</b></font>"
		if(src.allowed(usr))
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

		if(src.allowed(usr))
			locked = !locked
			to_chat(usr, "You [locked ? "" : "un"]lock \the [src].")
		else
			to_chat(usr, "<span class='danger'>Access denied.</span>")

	else if(href_list["begin_decontamination"])

		if(safeties && occupant)
			to_chat(usr, "<span class='danger'>The cycler has detected an occupant. Please remove the occupant before commencing the decontamination cycle.</span>")
			return

		active = 1
		irradiating = 10
		src.updateUsrDialog()

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

	src.updateUsrDialog()
	return

/obj/machinery/suit_cycler/process()

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
	src.updateUsrDialog()

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

	add_fingerprint(usr)
	src.updateUsrDialog()
	src.update_icon()

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
