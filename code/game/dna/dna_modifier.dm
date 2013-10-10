/////////////////////////// DNA MACHINES
/obj/machinery/dna_scannernew
	name = "\improper DNA modifier"
	desc = "It scans DNA structures."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "scanner_0"
	density = 1
	var/locked = 0.0
	var/mob/occupant = null
	anchored = 1.0
	use_power = 1
	idle_power_usage = 50
	active_power_usage = 300

/obj/machinery/dna_scannernew/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/clonescanner(src)
	component_parts += new /obj/item/weapon/stock_parts/scanning_module(src)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src)
	component_parts += new /obj/item/weapon/stock_parts/micro_laser(src)
	component_parts += new /obj/item/weapon/stock_parts/console_screen(src)
	component_parts += new /obj/item/weapon/cable_coil(src)
	component_parts += new /obj/item/weapon/cable_coil(src)
	RefreshParts()

/obj/machinery/dna_scannernew/allow_drop()
	return 0

/obj/machinery/dna_scannernew/relaymove(mob/user as mob)
	if (user.stat)
		return
	src.go_out()
	return

/obj/machinery/dna_scannernew/verb/eject()
	set src in oview(1)
	set category = "Object"
	set name = "Eject DNA Scanner"

	if (usr.stat != 0)
		return
	src.go_out()
	for(var/obj/O in src)
		if((!istype(O,/obj/item/weapon/circuitboard/clonescanner)) && (!istype(O,/obj/item/weapon/stock_parts)) && (!istype(O,/obj/item/weapon/cable_coil)))
			O.loc = get_turf(src)//Ejects items that manage to get in there (exluding the components)
	if(!occupant)
		for(var/mob/M in src)//Failsafe so you can get mobs out
			M.loc = get_turf(src)
	add_fingerprint(usr)
	return

/obj/machinery/dna_scannernew/verb/move_inside()
	set src in oview(1)
	set category = "Object"
	set name = "Enter DNA Scanner"

	if (usr.stat != 0)
		return
	if (!ishuman(usr) && !ismonkey(usr)) //Make sure they're a mob that has dna
		usr << "\blue Try as you might, you can not climb up into the scanner."
		return
	if (src.occupant)
		usr << "\blue <B>The scanner is already occupied!</B>"
		return
	if (usr.abiotic())
		usr << "\blue <B>Subject cannot have abiotic items on.</B>"
		return
	usr.stop_pulling()
	usr.client.perspective = EYE_PERSPECTIVE
	usr.client.eye = src
	usr.loc = src
	src.occupant = usr
	src.icon_state = "scanner_1"
	/*
	for(var/obj/O in src)    // THIS IS P. STUPID -- LOVE, DOOHL
		//O = null
		del(O)
		//Foreach goto(124)
	*/
	src.add_fingerprint(usr)
	return

/obj/machinery/dna_scannernew/attackby(obj/item/weapon/grab/G as obj, user as mob)
	if ((!( istype(G, /obj/item/weapon/grab) ) || !( ismob(G.affecting) )))
		return
	if (src.occupant)
		user << "\blue <B>The scanner is already occupied!</B>"
		return
	if (G.affecting.abiotic())
		user << "\blue <B>Subject cannot have abiotic items on.</B>"
		return
	var/mob/M = G.affecting
	if(M.client)
		M.client.perspective = EYE_PERSPECTIVE
		M.client.eye = src
	M.loc = src
	src.occupant = M
	src.icon_state = "scanner_1"

	src.add_fingerprint(user)

	// search for ghosts, if the corpse is empty and the scanner is connected to a cloner
	if(locate(/obj/machinery/computer/cloning, get_step(src, NORTH)) \
		|| locate(/obj/machinery/computer/cloning, get_step(src, SOUTH)) \
		|| locate(/obj/machinery/computer/cloning, get_step(src, EAST)) \
		|| locate(/obj/machinery/computer/cloning, get_step(src, WEST)))

		if(!M.client && M.mind)
			for(var/mob/dead/observer/ghost in player_list)
				if(ghost.mind == M.mind)
					ghost << "<b><font color = #330033><font size = 3>Your corpse has been placed into a cloning scanner. Return to your body if you want to be resurrected/cloned!</b> (Verbs -> Ghost -> Re-enter corpse)</font color>"
					break
	del(G)
	return

/obj/machinery/dna_scannernew/proc/go_out()
	if ((!( src.occupant ) || src.locked))
		return
/*
//	it's like this was -just- here to break constructed dna scanners -Pete
//	if that's not the case, slap my shit and uncomment this.
//	for(var/obj/O in src)
//		O.loc = src.loc
*/
		//Foreach goto(30)
	if (src.occupant.client)
		src.occupant.client.eye = src.occupant.client.mob
		src.occupant.client.perspective = MOB_PERSPECTIVE
	src.occupant.loc = src.loc
	src.occupant = null
	src.icon_state = "scanner_0"
	return

/obj/machinery/dna_scannernew/ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/atom/movable/A as mob|obj in src)
				A.loc = src.loc
				ex_act(severity)
				//Foreach goto(35)
			//SN src = null
			del(src)
			return
		if(2.0)
			if (prob(50))
				for(var/atom/movable/A as mob|obj in src)
					A.loc = src.loc
					ex_act(severity)
					//Foreach goto(108)
				//SN src = null
				del(src)
				return
		if(3.0)
			if (prob(25))
				for(var/atom/movable/A as mob|obj in src)
					A.loc = src.loc
					ex_act(severity)
					//Foreach goto(181)
				//SN src = null
				del(src)
				return
		else
	return


/obj/machinery/dna_scannernew/blob_act()
	if(prob(75))
		for(var/atom/movable/A as mob|obj in src)
			A.loc = src.loc
		del(src)


/obj/machinery/computer/scan_consolenew/ex_act(severity)

	switch(severity)
		if(1.0)
			//SN src = null
			del(src)
			return
		if(2.0)
			if (prob(50))
				//SN src = null
				del(src)
				return
		else
	return

/obj/machinery/computer/scan_consolenew/blob_act()

	if(prob(75))
		del(src)

/obj/machinery/computer/scan_consolenew/power_change()
	if(stat & BROKEN)
		icon_state = "broken"
	else if(powered())
		icon_state = initial(icon_state)
		stat &= ~NOPOWER
	else
		spawn(rand(0, 15))
			src.icon_state = "c_unpowered"
			stat |= NOPOWER

/obj/machinery/computer/scan_consolenew/New()
	..()
	spawn(5)
		for(dir in list(NORTH,EAST,SOUTH,WEST))
			connected = locate(/obj/machinery/dna_scannernew, get_step(src, dir))
			if(!isnull(connected))
				break
		spawn(250)
			src.injectorready = 1
		return
	return

/obj/machinery/computer/scan_consolenew/attackby(obj/item/W as obj, mob/user as mob)
	if ((istype(W, /obj/item/weapon/disk/data)) && (!src.diskette))
		user.drop_item()
		W.loc = src
		src.diskette = W
		user << "You insert [W]."
		src.updateUsrDialog()
/*
/obj/machinery/computer/scan_consolenew/process() //not really used right now
	if(stat & (NOPOWER|BROKEN))
		return
	if (!( src.status )) //remove this
		return
	return
*/
/obj/machinery/computer/scan_consolenew/attack_paw(user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/scan_consolenew/attack_ai(user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/scan_consolenew/attack_hand(user as mob)
	if(..())
		return
	var/dat
	if (src.delete && src.temphtml) //Window in buffer but its just simple message, so nothing
		src.delete = src.delete

	else if (!src.delete && src.temphtml) //Window in buffer - its a menu, dont add clear message
		dat = text("[]<BR><BR><A href='?src=\ref[];clear=1'>Main Menu</A>", src.temphtml, src)
	else
		if (src.connected) //Is something connected?
			var/mob/living/occupant = src.connected.occupant
			dat = "<font color='blue'><B>Occupant Statistics:</B></FONT><BR>" //Blah obvious
			if(occupant && occupant.dna) //is there REALLY someone in there?
				if(NOCLONE in occupant.mutations)
					dat += "The occupant's DNA structure is ruined beyond recognition, please insert a subject with an intact DNA structure.<BR><BR>" //NOPE. -Pete
					dat += text("<A href='?src=\ref[];buffermenu=1'>View/Edit/Transfer Buffer</A><BR><BR>", src)
					dat += text("<A href='?src=\ref[];radset=1'>Radiation Emitter Settings</A><BR><BR>", src)
				else
					if (!istype(occupant,/mob/living/carbon/human))
						sleep(1)
					var/t1
					switch(occupant.stat) // obvious, see what their status is
						if(0)
							t1 = "Conscious"
						if(1)
							t1 = "Unconscious"
						else
							t1 = "*dead*"
					dat += text("[]\tHealth %: [] ([])</FONT><BR>", (occupant.health > 50 ? "<font color='blue'>" : "<font color='red'>"), occupant.health, t1)
					dat += text("<font color='green'>Radiation Level: []%</FONT><BR><BR>", occupant.radiation)
					dat += text("Unique Enzymes : <font color='blue'>[]</FONT><BR>", uppertext(occupant.dna.unique_enzymes))
					dat += text("Unique Identifier: <font color='blue'>[]</FONT><BR>", occupant.dna.uni_identity)
					dat += text("Structural Enzymes: <font color='blue'>[]</FONT><BR><BR>", occupant.dna.struc_enzymes)
					dat += text("<A href='?src=\ref[];unimenu=1'>Modify Unique Identifier</A><BR>", src)
					dat += text("<A href='?src=\ref[];strucmenu=1'>Modify Structural Enzymes</A><BR><BR>", src)
					dat += text("<A href='?src=\ref[];buffermenu=1'>View/Edit/Transfer Buffer</A><BR><BR>", src)
					dat += text("<A href='?src=\ref[];genpulse=1'>Pulse Radiation</A><BR>", src)
					dat += text("<A href='?src=\ref[];radset=1'>Radiation Emitter Settings</A><BR><BR>", src)
					dat += text("<A href='?src=\ref[];rejuv=1'>Inject Rejuvenators</A><BR><BR>", src)
			else
				dat += "The scanner is empty.<BR><BR>"
				dat += text("<A href='?src=\ref[];buffermenu=1'>View/Edit/Transfer Buffer</A><BR><BR>", src)
				dat += text("<A href='?src=\ref[];radset=1'>Radiation Emitter Settings</A><BR><BR>", src)
			if (!( src.connected.locked ))
				dat += text("<A href='?src=\ref[];locked=1'>Lock (Unlocked)</A><BR>", src)
			else
				dat += text("<A href='?src=\ref[];locked=1'>Unlock (Locked)</A><BR>", src)
				//Other stuff goes here
			if (!isnull(src.diskette))
				dat += text("<A href='?src=\ref[];eject_disk=1'>Eject Disk</A><BR>", src)
			dat += text("<BR><BR><A href='?src=\ref[];mach_close=scannernew'>Close</A>", user)
		else
			dat = "<font color='red'> Error: No DNA Modifier connected. </FONT>"
	user << browse(dat, "window=scannernew;size=550x625")
	onclose(user, "scannernew")
	return

/obj/machinery/computer/scan_consolenew/proc/all_dna_blocks(var/buffer)
	var/list/arr = list()
	for(var/i = 1, i <= length(buffer)/3, i++)
		arr += "[i]:[copytext(buffer,i*3-2,i*3+1)]"
	return arr

/obj/machinery/computer/scan_consolenew/proc/setInjectorBlock(var/obj/item/weapon/dnainjector/I, var/blk, var/buffer)
	var/pos = findtext(blk,":")
	if(!pos) return 0
	var/id = text2num(copytext(blk,1,pos))
	if(!id) return 0
	I.block = id
	I.dna = copytext(buffer,id*3-2,id*3+1)
	return 1

/obj/machinery/computer/scan_consolenew/Topic(href, href_list)
	if(..())
		return
	if(!istype(usr.loc, /turf))
		return
	if(!src || !src.connected)
		return
	if ((usr.contents.Find(src) || in_range(src, usr) && istype(src.loc, /turf)) || (istype(usr, /mob/living/silicon)))
		usr.set_machine(src)
		if (href_list["locked"])
			if ((src.connected && src.connected.occupant))
				src.connected.locked = !( src.connected.locked )
		////////////////////////////////////////////////////////
		if (href_list["genpulse"])
			if(!src.connected.occupant || !src.connected.occupant.dna)//Makes sure someone is in there (And valid) before trying anything
				src.temphtml = text("No viable occupant detected.")//More than anything, this just acts as a sanity check in case the option DOES appear for whatever reason
				usr << browse(temphtml, "window=scannernew;size=550x650")
				onclose(usr, "scannernew")
			else
				src.delete = 1
				src.temphtml = text("Working ... Please wait ([] Seconds)", src.radduration)
				usr << browse(temphtml, "window=scannernew;size=550x650")
				onclose(usr, "scannernew")
				var/lock_state = src.connected.locked
				src.connected.locked = 1//lock it
				sleep(10*src.radduration)
				if (!src.connected.occupant)
					temphtml = null
					delete = 0
					return null
				if (prob(95))
					if(prob(75))
						randmutb(src.connected.occupant)
					else
						randmuti(src.connected.occupant)
				else
					if(prob(95))
						randmutg(src.connected.occupant)
					else
						randmuti(src.connected.occupant)
				src.connected.occupant.radiation += ((src.radstrength*3)+src.radduration*3)
				src.connected.locked = lock_state
				temphtml = null
				delete = 0
		if (href_list["radset"])
			src.temphtml = text("Radiation Duration: <B><font color='green'>[]</B></FONT><BR>", src.radduration)
			src.temphtml += text("Radiation Intensity: <font color='green'><B>[]</B></FONT><BR><BR>", src.radstrength)
			src.temphtml += text("<A href='?src=\ref[];radleminus=1'>--</A> Duration <A href='?src=\ref[];radleplus=1'>++</A><BR>", src, src)
			src.temphtml += text("<A href='?src=\ref[];radinminus=1'>--</A> Intesity <A href='?src=\ref[];radinplus=1'>++</A><BR>", src, src)
			src.delete = 0
		if (href_list["radleplus"])
			if(!src.connected.occupant || !src.connected.occupant.dna)
				src.temphtml = text("No viable occupant detected.")
				usr << browse(temphtml, "window=scannernew;size=550x650")
				onclose(usr, "scannernew")
			if (src.radduration < 20)
				src.radduration++
				src.radduration++
			dopage(src,"radset")
		if (href_list["radleminus"])
			if(!src.connected.occupant || !src.connected.occupant.dna)
				src.temphtml = text("No viable occupant detected.")
				usr << browse(temphtml, "window=scannernew;size=550x650")
				onclose(usr, "scannernew")
			if (src.radduration > 2)
				src.radduration--
				src.radduration--
			dopage(src,"radset")
		if (href_list["radinplus"])
			if (src.radstrength < 10)
				src.radstrength++
			dopage(src,"radset")
		if (href_list["radinminus"])
			if (src.radstrength > 1)
				src.radstrength--
			dopage(src,"radset")
		////////////////////////////////////////////////////////
		if (href_list["unimenu"])
			if(!src.connected.occupant || !src.connected.occupant.dna)
				src.temphtml = text("No viable occupant detected.")
				usr << browse(temphtml, "window=scannernew;size=550x650")
				onclose(usr, "scannernew")
			else
				//src.temphtml = text("Unique Identifier: <font color='blue'>[]</FONT><BR><BR>", src.connected.occupant.dna.uni_identity)
				//src.temphtml = text("Unique Identifier: <font color='blue'>[getleftblocks(src.connected.occupant.dna.uni_identity,uniblock,3)][src.subblock == 1 ? "<U><B>"+getblock(getblock(src.connected.occupant.dna.uni_identity,src.uniblock,3),1,1)+"</U></B>" : getblock(getblock(src.connected.occupant.dna.uni_identity,src.uniblock,3),1,1)][src.subblock == 2 ? "<U><B>"+getblock(getblock(src.connected.occupant.dna.uni_identity,src.uniblock,3),2,1)+"</U></B>" : getblock(getblock(src.connected.occupant.dna.uni_identity,src.uniblock,3),2,1)][src.subblock == 3 ? "<U><B>"+getblock(getblock(src.connected.occupant.dna.uni_identity,src.uniblock,3),3,1)+"</U></B>" : getblock(getblock(src.connected.occupant.dna.uni_identity,src.uniblock,3),3,1)][getrightblocks(src.connected.occupant.dna.uni_identity,uniblock,3)]</FONT><BR><BR>")

				// New way of displaying DNA blocks
				src.temphtml = text("Unique Identifier: <font color='blue'>[getblockstring(src.connected.occupant.dna.uni_identity,uniblock,subblock,3, src,1)]</FONT><br><br>")

				src.temphtml += text("Selected Block: <font color='blue'><B>[]</B></FONT><BR>", src.uniblock)
				src.temphtml += text("<A href='?src=\ref[];unimenuminus=1'><-</A> Block <A href='?src=\ref[];unimenuplus=1'>-></A><BR><BR>", src, src)
				src.temphtml += text("Selected Sub-Block: <font color='blue'><B>[]</B></FONT><BR>", src.subblock)
				src.temphtml += text("<A href='?src=\ref[];unimenusubminus=1'><-</A> Sub-Block <A href='?src=\ref[];unimenusubplus=1'>-></A><BR><BR>", src, src)
				src.temphtml += text("Selected Target: <font color='blue'><B>[]</B></FONT><BR>", src.unitargethex)
				src.temphtml += text("<A href='?src=\ref[];unimenutargetminus=1'><-</A> Target <A href='?src=\ref[];unimenutargetplus=1'>-></A><BR><BR>", src, src)
				src.temphtml += "<B>Modify Block:</B><BR>"
				src.temphtml += text("<A href='?src=\ref[];unipulse=1'>Irradiate</A><BR>", src)
				src.delete = 0
		if (href_list["unimenuplus"])
			if (src.uniblock < 13)
				src.uniblock++
			else
				src.uniblock = 1
			dopage(src,"unimenu")
		if (href_list["unimenuminus"])
			if (src.uniblock > 1)
				src.uniblock--
			else
				src.uniblock = 13
			dopage(src,"unimenu")
		if (href_list["unimenusubplus"])
			if (src.subblock < 3)
				src.subblock++
			else
				src.subblock = 1
			dopage(src,"unimenu")
		if (href_list["unimenusubminus"])
			if (src.subblock > 1)
				src.subblock--
			else
				src.subblock = 3
			dopage(src,"unimenu")
		if (href_list["unimenutargetplus"])
			if (src.unitarget < 15)
				src.unitarget++
				src.unitargethex = src.unitarget
				switch(unitarget)
					if(10)
						src.unitargethex = "A"
					if(11)
						src.unitargethex = "B"
					if(12)
						src.unitargethex = "C"
					if(13)
						src.unitargethex = "D"
					if(14)
						src.unitargethex = "E"
					if(15)
						src.unitargethex = "F"
			else
				src.unitarget = 0
				src.unitargethex = 0
			dopage(src,"unimenu")
		if (href_list["unimenutargetminus"])
			if (src.unitarget > 0)
				src.unitarget--
				src.unitargethex = src.unitarget
				switch(unitarget)
					if(10)
						src.unitargethex = "A"
					if(11)
						src.unitargethex = "B"
					if(12)
						src.unitargethex = "C"
					if(13)
						src.unitargethex = "D"
					if(14)
						src.unitargethex = "E"
			else
				src.unitarget = 15
				src.unitargethex = "F"
			dopage(src,"unimenu")
		if (href_list["uimenuset"] && href_list["uimenusubset"]) // This chunk of code updates selected block / sub-block based on click
			var/menuset = text2num(href_list["uimenuset"])
			var/menusubset = text2num(href_list["uimenusubset"])
			if ((menuset <= 13) && (menuset >= 1))
				src.uniblock = menuset
			if ((menusubset <= 3) && (menusubset >= 1))
				src.subblock = menusubset
			dopage(src, "unimenu")
		if (href_list["unipulse"])
			if(src.connected.occupant)
				var/block
				var/newblock
				var/tstructure2
				block = getblock(getblock(src.connected.occupant.dna.uni_identity,src.uniblock,3),src.subblock,1)
				src.delete = 1
				src.temphtml = text("Working ... Please wait ([] Seconds)", src.radduration)
				usr << browse(temphtml, "window=scannernew;size=550x650")
				onclose(usr, "scannernew")
				var/lock_state = src.connected.locked
				src.connected.locked = 1//lock it
				sleep(10*src.radduration)
				if (!src.connected.occupant)
					temphtml = null
					delete = 0
					return null
				///
				if (prob((80 + (src.radduration / 2))))
					block = miniscrambletarget(num2text(unitarget), src.radstrength, src.radduration)
					newblock = null
					if (src.subblock == 1) newblock = block + getblock(getblock(src.connected.occupant.dna.uni_identity,src.uniblock,3),2,1) + getblock(getblock(src.connected.occupant.dna.uni_identity,src.uniblock,3),3,1)
					if (src.subblock == 2) newblock = getblock(getblock(src.connected.occupant.dna.uni_identity,src.uniblock,3),1,1) + block + getblock(getblock(src.connected.occupant.dna.uni_identity,src.uniblock,3),3,1)
					if (src.subblock == 3) newblock = getblock(getblock(src.connected.occupant.dna.uni_identity,src.uniblock,3),1,1) + getblock(getblock(src.connected.occupant.dna.uni_identity,src.uniblock,3),2,1) + block
					tstructure2 = setblock(src.connected.occupant.dna.uni_identity, src.uniblock, newblock,3)
					src.connected.occupant.dna.uni_identity = tstructure2
					updateappearance(src.connected.occupant,src.connected.occupant.dna.uni_identity)
					src.connected.occupant.radiation += (src.radstrength+src.radduration)
				else
					if	(prob(20+src.radstrength))
						randmutb(src.connected.occupant)
						domutcheck(src.connected.occupant,src.connected)
					else
						randmuti(src.connected.occupant)
						updateappearance(src.connected.occupant,src.connected.occupant.dna.uni_identity)
					src.connected.occupant.radiation += ((src.radstrength*2)+src.radduration)
				src.connected.locked = lock_state
			dopage(src,"unimenu")
			src.delete = 0
		////////////////////////////////////////////////////////
		if (href_list["rejuv"])
			if(!src.connected.occupant || !src.connected.occupant.dna)
				src.temphtml = text("No viable occupant detected.")
				usr << browse(temphtml, "window=scannernew;size=550x650")
				onclose(usr, "scannernew")
			else
				var/mob/living/carbon/human/H = src.connected.occupant
				if(H)
					if (H.reagents.get_reagent_amount("inaprovaline") < 60)
						H.reagents.add_reagent("inaprovaline", 30)
					usr << text("Occupant now has [] units of rejuvenation in his/her bloodstream.", H.reagents.get_reagent_amount("inaprovaline"))
					src.delete = 0
		////////////////////////////////////////////////////////
		if (href_list["strucmenu"])
			if(!src.connected.occupant || !src.connected.occupant.dna)
				src.temphtml = text("No viable occupant detected.")
				usr << browse(temphtml, "window=scannernew;size=550x650")
				onclose(usr, "scannernew")
			else
				// Get this shit outta here it sucks
				//src.temphtml = text("Structural Enzymes: <font color='blue'>[getleftblocks(src.connected.occupant.dna.struc_enzymes,strucblock,3)][src.subblock == 1 ? "<U><B>"+getblock(getblock(src.connected.occupant.dna.struc_enzymes,src.strucblock,3),1,1)+"</U></B>" : getblock(getblock(src.connected.occupant.dna.struc_enzymes,src.strucblock,3),1,1)][src.subblock == 2 ? "<U><B>"+getblock(getblock(src.connected.occupant.dna.struc_enzymes,src.strucblock,3),2,1)+"</U></B>" : getblock(getblock(src.connected.occupant.dna.struc_enzymes,src.strucblock,3),2,1)][src.subblock == 3 ? "<U><B>"+getblock(getblock(src.connected.occupant.dna.struc_enzymes,src.strucblock,3),3,1)+"</U></B>" : getblock(getblock(src.connected.occupant.dna.struc_enzymes,src.strucblock,3),3,1)][getrightblocks(src.connected.occupant.dna.struc_enzymes,strucblock,3)]</FONT><BR><BR>")
				//src.temphtml = text("Structural Enzymes: <font color='blue'>[]</FONT><BR><BR>", src.connected.occupant.dna.struc_enzymes)

				// New shit, it doesn't suck (as much)
				src.temphtml = text("Structural Enzymes: <font color='blue'>[getblockstring(src.connected.occupant.dna.struc_enzymes,strucblock,subblock,3,src,0)]</FONT><br><br>")
																							// SE of occupant,	selected block,	selected subblock,	block size (3 subblocks)

				src.temphtml += text("Selected Block: <font color='blue'><B>[]</B></FONT><BR>", src.strucblock)
				src.temphtml += text("<A href='?src=\ref[];strucmenuminus=1'><-</A> Block <A href='?src=\ref[];strucmenuplus=1'>-></A><BR><BR>", src, src)
				src.temphtml += text("Selected Sub-Block: <font color='blue'><B>[]</B></FONT><BR>", src.subblock)
				src.temphtml += text("<A href='?src=\ref[];strucmenusubminus=1'><-</A> Sub-Block <A href='?src=\ref[];strucmenusubplus=1'>-></A><BR><BR>", src, src)
				src.temphtml += "<B>Modify Block:</B><BR>"
				src.temphtml += text("<A href='?src=\ref[];strucpulse=1'>Irradiate</A><BR>", src)
				src.delete = 0
		if (href_list["strucmenuplus"])
			if (src.strucblock < STRUCDNASIZE)
				src.strucblock++
			else
				src.strucblock = 1
			dopage(src,"strucmenu")
		if (href_list["strucmenuminus"])
			if (src.strucblock > 1)
				src.strucblock--
			else
				src.strucblock = STRUCDNASIZE
			dopage(src,"strucmenu")
		if (href_list["strucmenusubplus"])
			if (src.subblock < 3)
				src.subblock++
			else
				src.subblock = 1
			dopage(src,"strucmenu")
		if (href_list["strucmenusubminus"])
			if (src.subblock > 1)
				src.subblock--
			else
				src.subblock = 3
			dopage(src,"strucmenu")
		if (href_list["semenuset"] && href_list["semenusubset"]) // This chunk of code updates selected block / sub-block based on click (se stands for strutural enzymes)
			var/menuset = text2num(href_list["semenuset"])
			var/menusubset = text2num(href_list["semenusubset"])
			if ((menuset <= STRUCDNASIZE) && (menuset >= 1))
				src.strucblock = menuset
			if ((menusubset <= 3) && (menusubset >= 1))
				src.subblock = menusubset
			dopage(src, "strucmenu")
		if (href_list["strucpulse"])
			var/block
			var/newblock
			var/tstructure2
			var/oldblock
			var/lock_state = src.connected.locked
			src.connected.locked = 1//lock it
			if (src.connected.occupant)
				block = getblock(getblock(src.connected.occupant.dna.struc_enzymes,src.strucblock,3),src.subblock,1)
				src.delete = 1
				src.temphtml = text("Working ... Please wait ([] Seconds)", src.radduration)
				usr << browse(temphtml, "window=scannernew;size=550x650")
				onclose(usr, "scannernew")
				sleep(10*src.radduration)
			else
				temphtml = null
				delete = 0
				return null
			///
			if(src.connected.occupant)
				if (prob((80 + (src.radduration / 2))))
					if ((src.strucblock != 2 || src.strucblock != 12 || src.strucblock != 8 || src.strucblock || 10) && prob (20))
						oldblock = src.strucblock
						block = miniscramble(block, src.radstrength, src.radduration)
						newblock = null
						if (src.strucblock > 1 && src.strucblock < STRUCDNASIZE/2)
							src.strucblock++
						else if (src.strucblock > STRUCDNASIZE/2 && src.strucblock < STRUCDNASIZE)
							src.strucblock--
						if (src.subblock == 1) newblock = block + getblock(getblock(src.connected.occupant.dna.struc_enzymes,src.strucblock,3),2,1) + getblock(getblock(src.connected.occupant.dna.struc_enzymes,src.strucblock,3),3,1)
						if (src.subblock == 2) newblock = getblock(getblock(src.connected.occupant.dna.struc_enzymes,src.strucblock,3),1,1) + block + getblock(getblock(src.connected.occupant.dna.struc_enzymes,src.strucblock,3),3,1)
						if (src.subblock == 3) newblock = getblock(getblock(src.connected.occupant.dna.struc_enzymes,src.strucblock,3),1,1) + getblock(getblock(src.connected.occupant.dna.struc_enzymes,src.strucblock,3),2,1) + block
						tstructure2 = setblock(src.connected.occupant.dna.struc_enzymes, src.strucblock, newblock,3)
						src.connected.occupant.dna.struc_enzymes = tstructure2
						domutcheck(src.connected.occupant,src.connected)
						src.connected.occupant.radiation += (src.radstrength+src.radduration)
						src.strucblock = oldblock
					else
					//
						block = miniscramble(block, src.radstrength, src.radduration)
						newblock = null
						if (src.subblock == 1) newblock = block + getblock(getblock(src.connected.occupant.dna.struc_enzymes,src.strucblock,3),2,1) + getblock(getblock(src.connected.occupant.dna.struc_enzymes,src.strucblock,3),3,1)
						if (src.subblock == 2) newblock = getblock(getblock(src.connected.occupant.dna.struc_enzymes,src.strucblock,3),1,1) + block + getblock(getblock(src.connected.occupant.dna.struc_enzymes,src.strucblock,3),3,1)
						if (src.subblock == 3) newblock = getblock(getblock(src.connected.occupant.dna.struc_enzymes,src.strucblock,3),1,1) + getblock(getblock(src.connected.occupant.dna.struc_enzymes,src.strucblock,3),2,1) + block
						tstructure2 = setblock(src.connected.occupant.dna.struc_enzymes, src.strucblock, newblock,3)
						src.connected.occupant.dna.struc_enzymes = tstructure2
						domutcheck(src.connected.occupant,src.connected)
						src.connected.occupant.radiation += (src.radstrength+src.radduration)
				else
					if	(prob(80-src.radduration))
						randmutb(src.connected.occupant)
						domutcheck(src.connected.occupant,src.connected)
					else
						randmuti(src.connected.occupant)
						updateappearance(src.connected.occupant,src.connected.occupant.dna.uni_identity)
					src.connected.occupant.radiation += ((src.radstrength*2)+src.radduration)
			src.connected.locked = lock_state
			///
			dopage(src,"strucmenu")
			src.delete = 0
		////////////////////////////////////////////////////////
		if (href_list["buffermenu"])
			src.temphtml = "<B>Buffer 1:</B><BR>"
			if (!(src.buffer1))
				src.temphtml += "Buffer Empty<BR>"
			else
				src.temphtml += text("Data: <font color='blue'>[]</FONT><BR>", src.buffer1)
				src.temphtml += text("By: <font color='blue'>[]</FONT><BR>", src.buffer1owner)
				src.temphtml += text("Label: <font color='blue'>[]</FONT><BR>", src.buffer1label)
			if (src.connected.occupant && !(NOCLONE in src.connected.occupant.mutations)) src.temphtml += text("Save : <A href='?src=\ref[];b1addui=1'>UI</A> - <A href='?src=\ref[];b1adduiue=1'>UI+UE</A> - <A href='?src=\ref[];b1addse=1'>SE</A><BR>", src, src, src)
			if (src.buffer1) src.temphtml += text("Transfer to: <A href='?src=\ref[];b1transfer=1'>Occupant</A> - <A href='?src=\ref[];b1injector=1'>Full Injector</A> - <A href='?src=\ref[];b1injector=2'>Iso Injector</A><BR>", src, src, src)
			//if (src.buffer1) src.temphtml += text("<A href='?src=\ref[];b1iso=1'>Isolate Block</A><BR>", src)
			if (src.buffer1) src.temphtml += "Disk: <A href='?src=\ref[src];save_disk=1'>Save To</a> | <A href='?src=\ref[src];load_disk=1'>Load From</a><br>"
			if (src.buffer1) src.temphtml += text("<A href='?src=\ref[];b1label=1'>Edit Label</A><BR>", src)
			if (src.buffer1) src.temphtml += text("<A href='?src=\ref[];b1clear=1'>Clear Buffer</A><BR><BR>", src)
			if (!src.buffer1) src.temphtml += "<BR>"
			src.temphtml += "<B>Buffer 2:</B><BR>"
			if (!(src.buffer2))
				src.temphtml += "Buffer Empty<BR>"
			else
				src.temphtml += text("Data: <font color='blue'>[]</FONT><BR>", src.buffer2)
				src.temphtml += text("By: <font color='blue'>[]</FONT><BR>", src.buffer2owner)
				src.temphtml += text("Label: <font color='blue'>[]</FONT><BR>", src.buffer2label)
			if (src.connected.occupant && !(NOCLONE in src.connected.occupant.mutations)) src.temphtml += text("Save : <A href='?src=\ref[];b2addui=1'>UI</A> - <A href='?src=\ref[];b2adduiue=1'>UI+UE</A> - <A href='?src=\ref[];b2addse=1'>SE</A><BR>", src, src, src)
			if (src.buffer2) src.temphtml += text("Transfer to: <A href='?src=\ref[];b2transfer=1'>Occupant</A> - <A href='?src=\ref[];b2injector=1'>Full Injector</A> - <A href='?src=\ref[];b2injector=2'>Iso Injector</A><BR>", src, src, src)
			//if (src.buffer2) src.temphtml += text("<A href='?src=\ref[];b2iso=1'>Isolate Block</A><BR>", src)
			if (src.buffer2) src.temphtml += "Disk: <A href='?src=\ref[src];save_disk=2'>Save To</a> | <A href='?src=\ref[src];load_disk=2'>Load From</a><br>"
			if (src.buffer2) src.temphtml += text("<A href='?src=\ref[];b2label=1'>Edit Label</A><BR>", src)
			if (src.buffer2) src.temphtml += text("<A href='?src=\ref[];b2clear=1'>Clear Buffer</A><BR><BR>", src)
			if (!src.buffer2) src.temphtml += "<BR>"
			src.temphtml += "<B>Buffer 3:</B><BR>"
			if (!(src.buffer3))
				src.temphtml += "Buffer Empty<BR>"
			else
				src.temphtml += text("Data: <font color='blue'>[]</FONT><BR>", src.buffer3)
				src.temphtml += text("By: <font color='blue'>[]</FONT><BR>", src.buffer3owner)
				src.temphtml += text("Label: <font color='blue'>[]</FONT><BR>", src.buffer3label)
			if (src.connected.occupant && !(NOCLONE in src.connected.occupant.mutations)) src.temphtml += text("Save : <A href='?src=\ref[];b3addui=1'>UI</A> - <A href='?src=\ref[];b3adduiue=1'>UI+UE</A> - <A href='?src=\ref[];b3addse=1'>SE</A><BR>", src, src, src)
			if (src.buffer3) src.temphtml += text("Transfer to: <A href='?src=\ref[];b3transfer=1'>Occupant</A> - <A href='?src=\ref[];b3injector=1'>Full Injector</A> - <A href='?src=\ref[];b3injector=2'>Iso Injector</A><BR>", src, src, src)
			//if (src.buffer3) src.temphtml += text("<A href='?src=\ref[];b3iso=1'>Isolate Block</A><BR>", src)
			if (src.buffer3) src.temphtml += "Disk: <A href='?src=\ref[src];save_disk=3'>Save To</a> | <A href='?src=\ref[src];load_disk=3'>Load From</a><br>"
			if (src.buffer3) src.temphtml += text("<A href='?src=\ref[];b3label=1'>Edit Label</A><BR>", src)
			if (src.buffer3) src.temphtml += text("<A href='?src=\ref[];b3clear=1'>Clear Buffer</A><BR><BR>", src)
			if (!src.buffer3) src.temphtml += "<BR>"
		if (href_list["b1addui"])
			if(src.connected.occupant && src.connected.occupant.dna)
				src.buffer1iue = 0
				src.buffer1 = src.connected.occupant.dna.uni_identity
				if (!istype(src.connected.occupant,/mob/living/carbon/human))
					src.buffer1owner = src.connected.occupant.name
				else
					src.buffer1owner = src.connected.occupant.real_name
				src.buffer1label = "Unique Identifier"
				src.buffer1type = "ui"
				dopage(src,"buffermenu")
		if (href_list["b1adduiue"])
			if(src.connected.occupant && src.connected.occupant.dna)
				src.buffer1 = src.connected.occupant.dna.uni_identity
				if (!istype(src.connected.occupant,/mob/living/carbon/human))
					src.buffer1owner = src.connected.occupant.name
				else
					src.buffer1owner = src.connected.occupant.real_name
				src.buffer1label = "Unique Identifier & Unique Enzymes"
				src.buffer1type = "ui"
				src.buffer1iue = 1
				dopage(src,"buffermenu")
		if (href_list["b2adduiue"])
			if(src.connected.occupant && src.connected.occupant.dna)
				src.buffer2 = src.connected.occupant.dna.uni_identity
				if (!istype(src.connected.occupant,/mob/living/carbon/human))
					src.buffer2owner = src.connected.occupant.name
				else
					src.buffer2owner = src.connected.occupant.real_name
				src.buffer2label = "Unique Identifier & Unique Enzymes"
				src.buffer2type = "ui"
				src.buffer2iue = 1
				dopage(src,"buffermenu")
		if (href_list["b3adduiue"])
			if(src.connected.occupant && src.connected.occupant.dna)
				src.buffer3 = src.connected.occupant.dna.uni_identity
				if (!istype(src.connected.occupant,/mob/living/carbon/human))
					src.buffer3owner = src.connected.occupant.name
				else
					src.buffer3owner = src.connected.occupant.real_name
				src.buffer3label = "Unique Identifier & Unique Enzymes"
				src.buffer3type = "ui"
				src.buffer3iue = 1
				dopage(src,"buffermenu")
		if (href_list["b2addui"])
			if(src.connected.occupant && src.connected.occupant.dna)
				src.buffer2iue = 0
				src.buffer2 = src.connected.occupant.dna.uni_identity
				if (!istype(src.connected.occupant,/mob/living/carbon/human))
					src.buffer2owner = src.connected.occupant.name
				else
					src.buffer2owner = src.connected.occupant.real_name
				src.buffer2label = "Unique Identifier"
				src.buffer2type = "ui"
				dopage(src,"buffermenu")
		if (href_list["b3addui"])
			if(src.connected.occupant && src.connected.occupant.dna)
				src.buffer3iue = 0
				src.buffer3 = src.connected.occupant.dna.uni_identity
				if (!istype(src.connected.occupant,/mob/living/carbon/human))
					src.buffer3owner = src.connected.occupant.name
				else
					src.buffer3owner = src.connected.occupant.real_name
				src.buffer3label = "Unique Identifier"
				src.buffer3type = "ui"
				dopage(src,"buffermenu")
		if (href_list["b1addse"])
			if(src.connected.occupant && src.connected.occupant.dna)
				src.buffer1iue = 0
				src.buffer1 = src.connected.occupant.dna.struc_enzymes
				if (!istype(src.connected.occupant,/mob/living/carbon/human))
					src.buffer1owner = src.connected.occupant.name
				else
					src.buffer1owner = src.connected.occupant.real_name
				src.buffer1label = "Structural Enzymes"
				src.buffer1type = "se"
				dopage(src,"buffermenu")
		if (href_list["b2addse"])
			if(src.connected.occupant && src.connected.occupant.dna)
				src.buffer2iue = 0
				src.buffer2 = src.connected.occupant.dna.struc_enzymes
				if (!istype(src.connected.occupant,/mob/living/carbon/human))
					src.buffer2owner = src.connected.occupant.name
				else
					src.buffer2owner = src.connected.occupant.real_name
				src.buffer2label = "Structural Enzymes"
				src.buffer2type = "se"
				dopage(src,"buffermenu")
		if (href_list["b3addse"])
			if(src.connected.occupant && src.connected.occupant.dna)
				src.buffer3iue = 0
				src.buffer3 = src.connected.occupant.dna.struc_enzymes
				if (!istype(src.connected.occupant,/mob/living/carbon/human))
					src.buffer3owner = src.connected.occupant.name
				else
					src.buffer3owner = src.connected.occupant.real_name
				src.buffer3label = "Structural Enzymes"
				src.buffer3type = "se"
				dopage(src,"buffermenu")
		if (href_list["b1clear"])
			src.buffer1 = null
			src.buffer1owner = null
			src.buffer1label = null
			src.buffer1iue = null
			dopage(src,"buffermenu")
		if (href_list["b2clear"])
			src.buffer2 = null
			src.buffer2owner = null
			src.buffer2label = null
			src.buffer2iue = null
			dopage(src,"buffermenu")
		if (href_list["b3clear"])
			src.buffer3 = null
			src.buffer3owner = null
			src.buffer3label = null
			src.buffer3iue = null
			dopage(src,"buffermenu")
		if (href_list["b1label"])
			src.buffer1label = sanitize(input("New Label:","Edit Label","Infos here"))
			dopage(src,"buffermenu")
		if (href_list["b2label"])
			src.buffer2label = sanitize(input("New Label:","Edit Label","Infos here"))
			dopage(src,"buffermenu")
		if (href_list["b3label"])
			src.buffer3label = sanitize(input("New Label:","Edit Label","Infos here"))
			dopage(src,"buffermenu")
		if (href_list["b1transfer"])
			if (!src.connected.occupant || (NOCLONE in src.connected.occupant.mutations) || !src.connected.occupant.dna)
				return
			if (src.buffer1type == "ui")
				if (src.buffer1iue)
					src.connected.occupant.real_name = src.buffer1owner
					src.connected.occupant.name = src.buffer1owner
				src.connected.occupant.dna.uni_identity = src.buffer1
				updateappearance(src.connected.occupant,src.connected.occupant.dna.uni_identity)
			else if (src.buffer1type == "se")
				src.connected.occupant.dna.struc_enzymes = src.buffer1
				domutcheck(src.connected.occupant,src.connected)
			src.temphtml = "Transfered."
			src.connected.occupant.radiation += rand(20,50)
			src.delete = 0
		if (href_list["b2transfer"])
			if (!src.connected.occupant || (NOCLONE in src.connected.occupant.mutations) || !src.connected.occupant.dna)
				return
			if (src.buffer2type == "ui")
				if (src.buffer2iue)
					src.connected.occupant.real_name = src.buffer2owner
					src.connected.occupant.name = src.buffer2owner
				src.connected.occupant.dna.uni_identity = src.buffer2
				updateappearance(src.connected.occupant,src.connected.occupant.dna.uni_identity)
			else if (src.buffer2type == "se")
				src.connected.occupant.dna.struc_enzymes = src.buffer2
				domutcheck(src.connected.occupant,src.connected)
			src.temphtml = "Transfered."
			src.connected.occupant.radiation += rand(20,50)
			src.delete = 0
		if (href_list["b3transfer"])
			if (!src.connected.occupant || (NOCLONE in src.connected.occupant.mutations) || !src.connected.occupant.dna)
				return
			if (src.buffer3type == "ui")
				if (src.buffer3iue)
					src.connected.occupant.real_name = src.buffer3owner
					src.connected.occupant.name = src.buffer3owner
				src.connected.occupant.dna.uni_identity = src.buffer3
				updateappearance(src.connected.occupant,src.connected.occupant.dna.uni_identity)
			else if (src.buffer3type == "se")
				src.connected.occupant.dna.struc_enzymes = src.buffer3
				domutcheck(src.connected.occupant,src.connected)
			src.temphtml = "Transfered."
			src.connected.occupant.radiation += rand(20,50)
			src.delete = 0
		if (href_list["b1injector"])
			if (src.injectorready)
				var/success = 1
				var/obj/item/weapon/dnainjector/I = new /obj/item/weapon/dnainjector
				I.dnatype = src.buffer1type
				if(href_list["b1injector"]=="2")
					var/blk = input(usr,"Select Block","Block") in all_dna_blocks(src.buffer1)
					success = setInjectorBlock(I,blk,src.buffer1)
				else
					I.dna = src.buffer1
				if(success)
					I.loc = src.loc
					I.name += " ([src.buffer1label])"
					if (src.buffer1iue) I.ue = src.buffer1owner //lazy haw haw
					src.temphtml = "Injector created."
					src.delete = 0
					src.injectorready = 0
					spawn(300)
						src.injectorready = 1
				else
					src.temphtml = "Error in injector creation."
					src.delete = 0
			else
				src.temphtml = "Replicator not ready yet."
				src.delete = 0
		if (href_list["b2injector"])
			if (src.injectorready)
				var/success = 1
				var/obj/item/weapon/dnainjector/I = new /obj/item/weapon/dnainjector
				I.dnatype = src.buffer2type
				if(href_list["b2injector"]=="2")
					var/blk = input(usr,"Select Block","Block") in all_dna_blocks(src.buffer2)
					success = setInjectorBlock(I,blk,src.buffer2)
				else
					I.dna = src.buffer2
				if(success)
					I.loc = src.loc
					I.name += " ([src.buffer2label])"
					if (src.buffer2iue) I.ue = src.buffer2owner //lazy haw haw
					src.temphtml = "Injector created."
					src.delete = 0
					src.injectorready = 0
					spawn(300)
						src.injectorready = 1
				else
					src.temphtml = "Error in injector creation."
					src.delete = 0
			else
				src.temphtml = "Replicator not ready yet."
				src.delete = 0
		if (href_list["b3injector"])
			if (src.injectorready)
				var/success = 1
				var/obj/item/weapon/dnainjector/I = new /obj/item/weapon/dnainjector
				I.dnatype = src.buffer3type
				if(href_list["b3injector"]=="2")
					var/blk = input(usr,"Select Block","Block") in all_dna_blocks(src.buffer3)
					success = setInjectorBlock(I,blk,src.buffer3)
				else
					I.dna = src.buffer3
				if(success)
					I.loc = src.loc
					I.name += " ([src.buffer3label])"
					if (src.buffer3iue) I.ue = src.buffer3owner //lazy haw haw
					src.temphtml = "Injector created."
					src.delete = 0
					src.injectorready = 0
					spawn(300)
						src.injectorready = 1
				else
					src.temphtml = "Error in injector creation."
					src.delete = 0
			else
				src.temphtml = "Replicator not ready yet."
				src.delete = 0
		////////////////////////////////////////////////////////
		if (href_list["load_disk"])
			var/buffernum = text2num(href_list["load_disk"])
			if ((buffernum > 3) || (buffernum < 1))
				return
			if ((isnull(src.diskette)) || (!src.diskette.data) || (src.diskette.data == ""))
				return
			switch(buffernum)
				if(1)
					src.buffer1 = src.diskette.data
					src.buffer1type = src.diskette.data_type
					src.buffer1iue = src.diskette.ue
					src.buffer1owner = src.diskette.owner
				if(2)
					src.buffer2 = src.diskette.data
					src.buffer2type = src.diskette.data_type
					src.buffer2iue = src.diskette.ue
					src.buffer2owner = src.diskette.owner
				if(3)
					src.buffer3 = src.diskette.data
					src.buffer3type = src.diskette.data_type
					src.buffer3iue = src.diskette.ue
					src.buffer3owner = src.diskette.owner
			src.temphtml = "Data loaded."

		if (href_list["save_disk"])
			var/buffernum = text2num(href_list["save_disk"])
			if ((buffernum > 3) || (buffernum < 1))
				return
			if ((isnull(src.diskette)) || (src.diskette.read_only))
				return
			switch(buffernum)
				if(1)
					src.diskette.data = buffer1
					src.diskette.data_type = src.buffer1type
					src.diskette.ue = src.buffer1iue
					src.diskette.owner = src.buffer1owner
					src.diskette.name = "data disk - '[src.buffer1owner]'"
				if(2)
					src.diskette.data = buffer2
					src.diskette.data_type = src.buffer2type
					src.diskette.ue = src.buffer2iue
					src.diskette.owner = src.buffer2owner
					src.diskette.name = "data disk - '[src.buffer2owner]'"
				if(3)
					src.diskette.data = buffer3
					src.diskette.data_type = src.buffer3type
					src.diskette.ue = src.buffer3iue
					src.diskette.owner = src.buffer3owner
					src.diskette.name = "data disk - '[src.buffer3owner]'"
			src.temphtml = "Data saved."
		if (href_list["eject_disk"])
			if (!src.diskette)
				return
			src.diskette.loc = get_turf(src)
			src.diskette = null
		////////////////////////////////////////////////////////
		if (href_list["clear"])
			src.temphtml = null
			src.delete = 0
		if (href_list["update"]) //ignore
			src.temphtml = src.temphtml
		src.add_fingerprint(usr)
		src.updateUsrDialog()
	return
/////////////////////////// DNA MACHINES
