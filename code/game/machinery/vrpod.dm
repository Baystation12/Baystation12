// Pretty much everything here is stolen from the dna scanner FYI
var/vrpads = list()
var/VRPadItems = list()

/obj/machinery/vrpod
	var/turfOn
	var/locked
	var/mob/living/carbon/vrbody
	var/vrloc
	var/zPlane = 2
	var/mob/living/carbon/lastoccupant
	var/savedkey
	var/backupMind
	var/foundMind
	var/storedName
	var/mob/living/carbon/human/occupant
	name = "VR Pod"
	desc = "A very advanced machine. It appears to be pulsating."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "vrpod_00"
	density = 1
	anchored = 1

/obj/machinery/vrpod/New(var/loc)
	vrloc = src
	..()

/obj/machinery/vrpod/Del()
	if (src.occupant)
		src.go_out()
	..()


/*/obj/machinery/vrpod/allow_drop()
	return 0*/

/obj/machinery/vrpod/relaymove(mob/user as mob)
	if (user.stat)
		return
	src.go_out()
	return

/obj/machinery/vrpod/verb/eject()
	set src in oview(1)
	set category = "Object"
	set name = "Eject VR Pod"

	if (usr.stat != 0)
		return
	src.go_out()
	src.visible_message("\red \icon[src] GAME SESSION HALTED.", 2)
	playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 50, 0)
	add_fingerprint(usr)
	return

/obj/machinery/vrpod/verb/move_inside()
	set src in oview(1)
	set category = "Object"
	set name = "Enter VR Pod"

	if (usr.stat != 0)
		return
	if (src.occupant)
		usr << "\blue <B>The pod is already occupied!</B>"
		return
	if (usr.abiotic())
		usr << "\blue <B>Subject cannot have abiotic items on.</B>"
		return
	usr.pulling = null
	usr.client.perspective = EYE_PERSPECTIVE
	usr.client.eye = src
	usr.loc = src
	src.occupant = usr
	src.icon_state = "vrpod_1[src.emagged]"
	for(var/obj/O in src)
		//O = null
		del(O)
		//Foreach goto(124)
	src.add_fingerprint(usr)

	src.go_in()
	return


/obj/machinery/vrpod/proc/go_out()
	src.foundMind = 0
	if ((!( src.occupant ) || src.locked))
		return
	for(var/obj/O in src)
		O.loc = src.loc
		//Foreach goto(30)
	if (src.vrbody)
		if (src.vrbody.ckey)
			src.occupant.ckey = src.vrbody.ckey
			if (src.vrbody.mind)
				src.vrbody.mind.transfer_to(src.occupant)
				src.foundMind = 1
			//Drop all items where they stand. So that people don't eat the valuables.
			for(var/obj/item/W in src.vrbody)
				src.vrbody.drop_from_inventory(W)
				W.loc = src.vrbody.loc

				if(W.contents.len) //Make sure we catch anything not handled by del() on the items.
					for(var/obj/item/O in W.contents)
						O.loc = src
				if (istype(W, /obj/item/clothing/under))
					del(W)
				if (istype(W, /obj/item/clothing/shoes))
					del(W)
		del(src.vrbody)
	else
		src.occupant.ckey = src.savedkey // Done outside the loop JUST incase we can't find a guy.
		for(var/mob/M in player_list)
			if (!M.client)
				continue
			if (M.ckey == src.savedkey)
				M.mind.transfer_to(src.occupant)
				src.foundMind = 1
				break
			// How to save a life!
	if (src.foundMind==0)
		if(src.backupMind)
			if(istype(src.backupMind, /datum/mind))
				var/datum/mind/M = src.backupMind
				M.transfer_to(src.occupant)
				src.foundMind = 1
	if (src.occupant.client)
		src.occupant.client.eye = src.occupant.client.mob
		src.occupant.client.perspective = MOB_PERSPECTIVE
	src.occupant.loc = src.loc
	src.occupant.suiciding = 0 // IT COULD HAPPEN!
	src.lastoccupant = src.occupant
	if (src.foundMind==0)
		src.occupant << "\red<b>As the pod bursts open you realise you can't remember much of anything.</b>"
	if(src.storedName)
		src.occupant.real_name = src.storedName
		if(src.occupant.dna)
			src.occupant.dna.real_name = src.storedName
		src.storedName = null
	src.occupant = null
	src.icon_state = "vrpod_0[src.emagged]"
	return

/obj/machinery/vrpod/proc/go_in()
	// Make New body
	src.savedkey = null
	if (!src.occupant)
		return
	if (!src.occupant.ckey)
		return
	if (!src.occupant.client)
		return

	// LET'S FIND A PAD!
	// Very shitty way of doing it, but meh.
	src.vrloc = pick(vrpads)
	if(src.vrloc) //Make sure we found it~
		var/obj/machinery/pad = src.vrloc
		src.vrloc = pad.loc
	else
		return
	var/mob/living/carbon/human/VRbody = new /mob/living/carbon/human(src.vrloc, src.occupant.dna.species)
	src.vrbody = VRbody

	// Set its name.
	if(!src.occupant.real_name)	//to prevent null names
		src.occupant.real_name = "Virtual Guy([rand(0,999)])"
	VRbody.real_name = "Virtual [src.occupant.real_name]"
	VRbody.updatehealth()

	VRbody.ckey = src.occupant.ckey
	src.backupMind = src.occupant.mind
	src.occupant.mind.transfer_to(VRbody)
	src.savedkey = VRbody.ckey
	VRbody << "<span class='notice'><i>Your body feels momenterily numb as you awake in a new world.</i></span>"

	// Set its DNA to match
	if(!src.occupant.dna)
		VRbody.dna = new /datum/dna()
		VRbody.dna.real_name = VRbody.real_name
	else
		VRbody.dna=src.occupant.dna
		VRbody.dna.real_name = VRbody.real_name

	VRbody.UpdateAppearance()
	VRbody.dna.UpdateSE()
	VRbody.dna.UpdateUI()

	// Give it languages to speak.
	for(var/datum/language/L in src.occupant.languages)
		VRbody.add_language(L.name)

	VRbody.equip_to_slot_or_del(new /obj/item/clothing/under/color/grey(VRbody), slot_w_uniform)
	VRbody.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(VRbody), slot_shoes)
	return

/obj/machinery/vrpod/attackby(obj/item/D as obj, user as mob)
	if (src.occupant)
		user << "\blue <B>The pod is already occupied!</B>"
		return
	if(istype(D, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = D
		if(!ismob(G.affecting))
			return
		if (G.affecting.abiotic())
			user << "\blue <B>Subject cannot have abiotic items on.</B>"
			return
		var/mob/M = G.affecting
		if (M.client)
			M.client.perspective = EYE_PERSPECTIVE
			M.client.eye = src
		M.loc = src
		src.occupant = M
		src.icon_state = "vrpod_1[src.emagged]"
		src.go_in()
		for(var/obj/O in src)
			O.loc = src.loc
			//Foreach goto(154)
		src.add_fingerprint(user)
		//G = null
		del(G)
		return
	if(istype(D, /obj/item/weapon/wrench))
		if(src.anchored)
			user << "You unwrench the [src] from the floor"
		else
			user << "You wrench the [src] to the floor"
		src.anchored = 1-src.anchored
		playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
		return
	if(istype(D, /obj/item/weapon/card/emag))
		if(!src.emagged)
			if (src.occupant)
				src.icon_state = "vrpod_11"
			else
				src.icon_state = "vrpod_01"
			src.emagged = 1
			user << "You fry the [src]'s safties!"
		return

	return

/obj/machinery/vrpod/process()
	// Log out the dead! Because it'd suck if they stuck.
	if (src.occupant)
		if (!src.vrbody)
			src.go_out()
			src.visible_message("\red \icon[src] GAME SESSION HALTED.", 2)
			playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 50, 0)
			return
		if (!(src.vrbody.ckey&&src.vrbody.client)) // No body? No problem.
			src.visible_message("\red \icon[src] ERROR; CONNECTION TO VR BODY SEVERED.", 2)
			playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 50, 0)
			src.go_out()
			return
		if (src.occupant.stat & DEAD)
			src.go_out() // If this didn't happen, they'd be in VR forever.
			src.visible_message("\red \icon[src] ERROR; BRAIN FUNCTIONS HALTED.", 2)
			playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 50, 0)
			return
		if (src.vrbody.stat & DEAD)
			src.vrbody << "\red <B>The VR pod bursts open, the thrill of death still sweeping over you.</B>"
			src.go_out()
			src.visible_message("\red \icon[src] GAME SESSION HALTED.", 2)
			playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 50, 0)
			return
		if (stat & NOPOWER)
			src.go_out()
			return


/obj/machinery/vrpod/ex_act(severity)
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

/obj/machinery/vrpod/blob_act()
	if(prob(50))
		for(var/atom/movable/A as mob|obj in src)
			A.loc = src.loc
		del(src)


// VR POD ENTRY PADS, YEEE.
/obj/machinery/vrpad
	var/turfOn
	name = "VR Pad"
	desc = "A pulsating machine."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "vrpad"
	anchored = 1

/obj/machinery/vrpad/New()
	vrpads+=src // So that we can find it later. Probably a better way to do this, but meh.
	..()

/obj/machinery/vrpad/ex_act(severity)
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

/obj/machinery/vrpad/blob_act()
	if(prob(50))
		for(var/atom/movable/A as mob|obj in src)
			A.loc = src.loc
		del(src)

/obj/machinery/vrpad/attack_hand(mob/user)
	if(!user)
		return
	src.add_fingerprint(user)

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		var/confirm = alert("Do you wish to leave the VR Realm?", "Confirm Log Out", "Yes", "No")

		if(confirm=="Yes")
			H << "\red <B>You feel a jolt of pain as you touch the device.</B>"
			H.gib()

/obj/machinery/vrpad/process()
	..()

/obj/machinery/computer/vr
	name = "VRPod Control Console"
	desc = "Used to manipulate and manage the VR world."
	icon_state = "vrconsole"
	use_power = 1
	idle_power_usage = 250
	active_power_usage = 500
	//circuit = "/obj/item/weapon/circuitboard/crew"
	var/list/tracked = list(  )


/obj/machinery/computer/crew/New()
	..()


/obj/machinery/computer/vr/attack_ai(mob/user)
	attack_hand(user)
	interact(user)


/obj/machinery/computer/vr/attack_hand(mob/user)
	add_fingerprint(user)
	if(stat & (BROKEN|NOPOWER))
		return
	interact(user)


/obj/machinery/computer/vr/update_icon()

	if(stat & BROKEN)
		icon_state = "vrconsole_broken"
	else
		if(stat & NOPOWER)
			src.icon_state = "vrconsole_unpowered"
			stat |= NOPOWER
		else
			icon_state = initial(icon_state)
			stat &= ~NOPOWER


/obj/machinery/computer/vr/proc/regenerateVR()
	..()

/obj/machinery/computer/vr/Topic(href, href_list)
	if(..()) return
	if( href_list["close"] )
		usr << browse(null, "window=vrpodcomp")
		usr.unset_machine()
		return
	if(href_list["update"])
		src.updateDialog()
		return
	if(href_list["resetvr"])
		src.regenerateVR()
		return
	if(href_list["eject"])
		if(href_list["podx"]&&href_list["pody"]&&href_list["podz"])
			for(var/obj/machinery/vrpod/pod in world)
				if(pod.x==text2num(href_list["podx"])&&pod.y==text2num(href_list["pody"])&&pod.z==text2num(href_list["podz"]))
					pod.go_out()
					pod.visible_message("\red \icon[pod] GAME SESSION HALTED.", 2)
					playsound(pod.loc, 'sound/machines/buzz-sigh.ogg', 50, 0)
		return
	if(href_list["heal"])
		if(href_list["podx"]&&href_list["pody"]&&href_list["podz"])
			for(var/obj/machinery/vrpod/pod in world)
				if(pod.x==text2num(href_list["podx"])&&pod.y==text2num(href_list["pody"])&&pod.z==text2num(href_list["podz"]))
					if(pod.vrbody)
						var/mob/living/carbon/human/H = pod.vrbody
						H.rejuvenate()
						H << "\blue You suddenly feel fresh, and ready for anything!"
		return
	if(href_list["paralyze"])
		if(href_list["podx"]&&href_list["pody"]&&href_list["podz"])
			for(var/obj/machinery/vrpod/pod in world)
				if(pod.x==text2num(href_list["podx"])&&pod.y==text2num(href_list["pody"])&&pod.z==text2num(href_list["podz"]))
					if(pod.vrbody)
						var/mob/living/carbon/human/H = pod.vrbody
						H.Paralyse(30)
						H << "\red Your entire body locks up, You can't move!"
		return



/obj/machinery/computer/vr/interact(mob/user)
	if(stat & (BROKEN|NOPOWER))
		return
	if(!istype(user, /mob/living/silicon) && get_dist(src, user) > 1)
		user.unset_machine()
		user << browse(null, "window=vrpodcomp")
		return
	user.set_machine(src)
	var/t = "<TT><B>VR Pod Console</B><HR>" // A LOT of this is pinched from the Crew Monitoring Console.
	t += "<BR><A href='?src=\ref[src];update=1'>Refresh</A> "
	t += "<A href='?src=\ref[src];close=1'>Close</A><BR>"
	t += "<table><tr><td width='30%'>Name</td><td width='10%'>Vitals</td><td width='30%'>Position</td><td width = '30%'>Functions</td></tr>"
	for(var/obj/machinery/vrpod/pod in world)
		var/PodName = pod.name
		if(pod.emagged)
			PodName = "P0#3RR0%#%"
		if (pod.vrbody)
			var/mob/living/carbon/human/H = pod.vrbody
			var/dam1 = round(H.getOxyLoss(),1)
			var/dam2 = round(H.getToxLoss(),1)
			var/dam3 = round(H.getFireLoss(),1)
			var/dam4 = round(H.getBruteLoss(),1)

			var/damage_report = "(<font color='blue'>[dam1]</font>/<font color='green'>[dam2]</font>/<font color='orange'>[dam3]</font>/<font color='red'>[dam4]</font>)"
			var/area/player_area = get_area(H)
			t += "<tr><td width='20%'>([PodName]) [H.name]</td>"
			t += "<td width='10%'>[damage_report]</td><td width='30%'>[player_area.name] ([H.x], [H.y])</td>"
			t += "<td width='20%'>"
			t += "<A href='?src=\ref[src];eject=1;podx=[pod.x];pody=[pod.y];podz=[pod.z]'>\[EJECT\]</A> "
			t += "<A href='?src=\ref[src];heal=1;podx=[pod.x];pody=[pod.y];podz=[pod.z]'>\[HEAL\]</A> "
			if(pod.emagged)
				t += "<A href='?src=\ref[src];paralyze=1;podx=[pod.x];pody=[pod.y];podz=[pod.z]'>\red \[PARALYZE\]\black </A> "
			t += "</td></tr>"
		else
			t += "<tr><td width='20%'>([PodName]) EMPTYPOD</td><td width='10%'>N/A</td><td width='30%'>N/A</td><td width='30%'>N/A</td></tr>"
	t += "</table>"
	t += "<A href='?src=\ref[src];resetvr=1'>RESET VR WORLD</A><BR>"
	t += "</FONT></PRE></TT>"
	user << browse(t, "window=vrpodcomp;size=800x400")
	onclose(user, "vrpodcomp")