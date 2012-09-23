//Cloning revival method.
//The pod handles the actual cloning while the computer manages the clone profiles

//Potential replacement for genetics revives or something I dunno (?)

/obj/machinery/clonepod
	anchored = 1
	name = "cloning pod"
	desc = "An electronically-lockable pod for growing organic tissue."
	density = 1
	icon = 'icons/obj/cloning.dmi'
	icon_state = "pod_0"
	req_access = list(access_genetics) //For premature unlocking.
	var/mob/living/occupant
	var/heal_level = 90 //The clone is released once its health reaches this level.
	var/locked = 0
	var/obj/machinery/computer/cloning/connected = null //So we remember the connected clone machine.
	var/mess = 0 //Need to clean out it if it's full of exploded clone.
	var/attempting = 0 //One clone attempt at a time thanks
	var/eject_wait = 0 //Don't eject them as soon as they are created fuckkk

//The return of data disks?? Just for transferring between genetics machine/cloning machine.
//TO-DO: Make the genetics machine accept them.
/obj/item/weapon/disk/data
	name = "Cloning Data Disk"
	icon = 'icons/obj/cloning.dmi'
	icon_state = "datadisk0" //Gosh I hope syndies don't mistake them for the nuke disk.
	item_state = "card-id"
	w_class = 1.0
	var/data = ""
	var/ue = 0
	var/data_type = "ui" //ui|se
	var/owner = "God Emperor of Mankind"
	var/read_only = 0 //Well,it's still a floppy disk

/obj/item/weapon/disk/data/demo
	name = "data disk - 'God Emperor of Mankind'"
	data = "066000033000000000AF00330660FF4DB002690"
	//data = "0C80C80C80C80C80C8000000000000161FBDDEF" - Farmer Jeff
	ue = 1
	read_only = 1

/obj/item/weapon/disk/data/monkey
	name = "data disk - 'Mr. Muggles'"
	data_type = "se"
	data = "0983E840344C39F4B059D5145FC5785DC6406A4FFF"
	read_only = 1

//Find a dead mob with a brain and client.
/proc/find_dead_player(var/find_key)
	if (isnull(find_key))
		return

	var/mob/selected = null
	for(var/mob/M in player_list)
		//Dead people only thanks!
		if ((M.stat != 2) || (!M.client))
			continue
		//They need a brain!
		if ((istype(M, /mob/living/carbon/human)) && (M:brain_op_stage >= 4.0))
			continue

		if (M.ckey == find_key)
			selected = M
			break
	return selected

//Disk stuff.
/obj/item/weapon/disk/data/New()
	..()
	var/diskcolor = pick(0,1,2)
	src.icon_state = "datadisk[diskcolor]"

/obj/item/weapon/disk/data/attack_self(mob/user as mob)
	src.read_only = !src.read_only
	user << "You flip the write-protect tab to [src.read_only ? "protected" : "unprotected"]."

/obj/item/weapon/disk/data/examine()
	set src in oview(5)
	..()
	usr << text("The write-protect tab is set to [src.read_only ? "protected" : "unprotected"].")
	return

//Health Tracker Implant

/obj/item/weapon/implant/health
	name = "health implant"
	var/healthstring = ""

/obj/item/weapon/implant/health/proc/sensehealth()
	if (!src.implanted)
		return "ERROR"
	else
		if(isliving(src.implanted))
			var/mob/living/L = src.implanted
			src.healthstring = "[round(L.getOxyLoss())] - [round(L.getFireLoss())] - [round(L.getToxLoss())] - [round(L.getBruteLoss())]"
		if (!src.healthstring)
			src.healthstring = "ERROR"
		return src.healthstring

/obj/machinery/clonepod/attack_ai(mob/user as mob)
	return attack_hand(user)
/obj/machinery/clonepod/attack_paw(mob/user as mob)
	return attack_hand(user)
/obj/machinery/clonepod/attack_hand(mob/user as mob)
	if ((isnull(src.occupant)) || (stat & NOPOWER))
		return
	if ((!isnull(src.occupant)) && (src.occupant.stat != 2))
		var/completion = (100 * ((src.occupant.health + 100) / (src.heal_level + 100)))
		user << "Current clone cycle is [round(completion)]% complete."
	return

//Clonepod

//Start growing a human clone in the pod!
/obj/machinery/clonepod/proc/growclone(var/ckey, var/clonename, var/ui, var/se, var/mindref, var/mrace, var/UI)
	if(mess || attempting)
		return 0
	var/datum/mind/clonemind = locate(mindref)
	if(!istype(clonemind,/datum/mind))	//not a mind
		return 0
	if( clonemind.current && clonemind.current.stat != DEAD )	//mind is associated with a non-dead body
		return 0
	if(clonemind.active)	//somebody is using that mind
		if( ckey(clonemind.key)!=ckey )
			return 0
	else
		for(var/mob/dead/observer/G in player_list)
			if(G.ckey == ckey)
				if(G.can_reenter_corpse)
					break
				else
					return 0


	src.heal_level = rand(75,100) //Randomizes what health the clone is when ejected

	src.attempting = 1 //One at a time!!
	src.locked = 1

	src.eject_wait = 1
	spawn(30)
		src.eject_wait = 0

	var/mob/living/carbon/human/H = new /mob/living/carbon/human(src)
	occupant = H
	H.UI = UI // set interface preference

	if(!clonename)	//to prevent null names
		clonename = "clone ([rand(0,999)])"
	H.real_name = clonename

	src.icon_state = "pod_1"
	//Get the clone body ready
	H.adjustCloneLoss(190) //new damage var so you can't eject a clone early then stab them to abuse the current damage system --NeoFite
	H.adjustBrainLoss(heal_level)
	H.Paralyse(4)

	//Here let's calculate their health so the pod doesn't immediately eject them!!!
	H.updatehealth()

	clonemind.transfer_to(H)
	H.ckey = ckey
	H << "<span class='notice'><b>Consciousness slowly creeps over you as your body regenerates.</b><br><i>So this is what cloning feels like?</i></span>"

	// -- Mode/mind specific stuff goes here

	switch(ticker.mode.name)
		if("revolution")
			if((H.mind in ticker.mode:revolutionaries) || (H.mind in ticker.mode:head_revolutionaries))
				ticker.mode.update_all_rev_icons() //So the icon actually appears
		if("nuclear emergency")
			if(H.mind in ticker.mode.syndicates)
				ticker.mode.update_all_synd_icons()
		if("cult")
			if (H.mind in ticker.mode.cult)
				ticker.mode.add_cultist(src.occupant.mind)
				ticker.mode.update_all_cult_icons() //So the icon actually appears

	// -- End mode specific stuff

	if(!H.dna)
		H.dna = new /datum/dna()
		H.dna.real_name = H.real_name
	if(ui)
		H.dna.uni_identity = ui
		updateappearance(H, ui)
	if(se)
		H.dna.struc_enzymes = se
		randmutb(H) //Sometimes the clones come out wrong.

	H.f_style = "Shaved"
	H.h_style = pick("Bedhead", "Bedhead 2", "Bedhead 3")

	if(H.dna)
		H.dna.mutantrace = mrace
		H.update_mutantrace()
	H.suiciding = 0
	src.attempting = 0
	return 1

//Grow clones to maturity then kick them out.  FREELOADERS
/obj/machinery/clonepod/process()

	if(stat & NOPOWER) //Autoeject if power is lost
		if (src.occupant)
			src.locked = 0
			src.go_out()
		return

	if((src.occupant) && (src.occupant.loc == src))
		if((src.occupant.stat == DEAD) || (src.occupant.suiciding) || !occupant.key)  //Autoeject corpses and suiciding dudes.
			src.locked = 0
			src.go_out()
			src.connected_message("Clone Rejected: Deceased.")
			return

		else if(src.occupant.health < src.heal_level)
			src.occupant.Paralyse(4)

			 //Slowly get that clone healed and finished.
			src.occupant.adjustCloneLoss(-2)

			//Premature clones may have brain damage.
			src.occupant.adjustBrainLoss(-1)

			//So clones don't die of oxyloss in a running pod.
			if (src.occupant.reagents.get_reagent_amount("inaprovaline") < 30)
				src.occupant.reagents.add_reagent("inaprovaline", 60)

			//Also heal some oxyloss ourselves because inaprovaline is so bad at preventing it!!
			src.occupant.adjustOxyLoss(-4)

			use_power(7500) //This might need tweaking.
			return

		else if((src.occupant.health >= src.heal_level) && (!src.eject_wait))
			src.connected_message("Cloning Process Complete.")
			src.locked = 0
			src.go_out()
			return

	else if ((!src.occupant) || (src.occupant.loc != src))
		src.occupant = null
		if (src.locked)
			src.locked = 0
		if (!src.mess)
			icon_state = "pod_0"
		use_power(200)
		return

	return

//Let's unlock this early I guess.  Might be too early, needs tweaking.
/obj/machinery/clonepod/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/card/id)||istype(W, /obj/item/device/pda))
		if (!src.check_access(W))
			user << "\red Access Denied."
			return
		if ((!src.locked) || (isnull(src.occupant)))
			return
		if ((src.occupant.health < -20) && (src.occupant.stat != 2))
			user << "\red Access Refused."
			return
		else
			src.locked = 0
			user << "System unlocked."
	else if (istype(W, /obj/item/weapon/card/emag))
		if (isnull(src.occupant))
			return
		user << "You force an emergency ejection."
		src.locked = 0
		src.go_out()
		return
	else
		..()

//Put messages in the connected computer's temp var for display.
/obj/machinery/clonepod/proc/connected_message(var/message)
	if ((isnull(src.connected)) || (!istype(src.connected, /obj/machinery/computer/cloning)))
		return 0
	if (!message)
		return 0

	src.connected.temp = message
	src.connected.updateUsrDialog()
	return 1

/obj/machinery/clonepod/verb/eject()
	set name = "Eject Cloner"
	set category = "Object"
	set src in oview(1)

	if (usr.stat != 0)
		return
	src.go_out()
	add_fingerprint(usr)
	return

/obj/machinery/clonepod/proc/go_out()
	if (src.locked)
		return

	if (src.mess) //Clean that mess and dump those gibs!
		src.mess = 0
		gibs(src.loc)
		src.icon_state = "pod_0"

		/*
		for(var/obj/O in src)
			O.loc = src.loc
		*/
		return

	if (!(src.occupant))
		return

	/*
	for(var/obj/O in src)
		O.loc = src.loc
	*/

	if (src.occupant.client)
		src.occupant.client.eye = src.occupant.client.mob
		src.occupant.client.perspective = MOB_PERSPECTIVE
	src.occupant.loc = src.loc
	src.icon_state = "pod_0"
	src.eject_wait = 0 //If it's still set somehow.
	domutcheck(src.occupant) //Waiting until they're out before possible monkeyizing.
	src.occupant = null
	return

/obj/machinery/clonepod/proc/malfunction()
	if(src.occupant)
		src.connected_message("Critical Error!")
		src.mess = 1
		src.icon_state = "pod_g"
		src.occupant.ghostize()
		spawn(5)
			del(src.occupant)
	return

/obj/machinery/clonepod/relaymove(mob/user as mob)
	if (user.stat)
		return
	src.go_out()
	return

/obj/machinery/clonepod/emp_act(severity)
	if(prob(100/severity)) malfunction()
	..()

/obj/machinery/clonepod/ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/atom/movable/A as mob|obj in src)
				A.loc = src.loc
				ex_act(severity)
			del(src)
			return
		if(2.0)
			if (prob(50))
				for(var/atom/movable/A as mob|obj in src)
					A.loc = src.loc
					ex_act(severity)
				del(src)
				return
		if(3.0)
			if (prob(25))
				for(var/atom/movable/A as mob|obj in src)
					A.loc = src.loc
					ex_act(severity)
				del(src)
				return
		else
	return

/*
 *	Diskette Box
 */
/obj/item/weapon/storage/diskbox
	name = "Diskette Box"
	icon_state = "disk_kit"
	item_state = "syringe_kit"
	foldable = /obj/item/stack/sheet/cardboard	//BubbleWrap

/obj/item/weapon/storage/diskbox/New()
	..()
	new /obj/item/weapon/disk/data(src)
	new /obj/item/weapon/disk/data(src)
	new /obj/item/weapon/disk/data(src)
	new /obj/item/weapon/disk/data(src)
	new /obj/item/weapon/disk/data(src)
	new /obj/item/weapon/disk/data(src)
	new /obj/item/weapon/disk/data(src)

/*
 *	Manual -- A big ol' manual.
 */

/obj/item/weapon/paper/Cloning
	name = "paper - 'H-87 Cloning Apparatus Manual"
	info = {"<h4>Getting Started</h4>
	Congratulations, your station has purchased the H-87 industrial cloning device!<br>
	Using the H-87 is almost as simple as brain surgery! Simply insert the target humanoid into the scanning chamber and select the scan option to create a new profile!<br>
	<b>That's all there is to it!</b><br>
	<i>Notice, cloning system cannot scan inorganic life or small primates.  Scan may fail if subject has suffered extreme brain damage.</i><br>
	<p>Clone profiles may be viewed through the profiles menu. Scanning implants a complementary HEALTH MONITOR IMPLANT into the subject, which may be viewed from each profile.
	Profile Deletion has been restricted to \[Station Head\] level access.</p>
	<h4>Cloning from a profile</h4>
	Cloning is as simple as pressing the CLONE option at the bottom of the desired profile.<br>
	Per your company's EMPLOYEE PRIVACY RIGHTS agreement, the H-87 has been blocked from cloning crewmembers while they are still alive.<br>
	<br>
	<p>The provided CLONEPOD SYSTEM will produce the desired clone.  Standard clone maturation times (With SPEEDCLONE technology) are roughly 90 seconds.
	The cloning pod may be unlocked early with any \[Medical Researcher\] ID after initial maturation is complete.</p><br>
	<i>Please note that resulting clones may have a small DEVELOPMENTAL DEFECT as a result of genetic drift.</i><br>
	<h4>Profile Management</h4>
	<p>The H-87 (as well as your station's standard genetics machine) can accept STANDARD DATA DISKETTES.
	These diskettes are used to transfer genetic information between machines and profiles.
	A load/save dialog will become available in each profile if a disk is inserted.</p><br>
	<i>A good diskette is a great way to counter aforementioned genetic drift!</i><br>
	<br>
	<font size=1>This technology produced under license from Thinktronic Systems, LTD.</font>"}

//SOME SCRAPS I GUESS
/* EMP grenade/spell effect
		if(istype(A, /obj/machinery/clonepod))
			A:malfunction()
*/