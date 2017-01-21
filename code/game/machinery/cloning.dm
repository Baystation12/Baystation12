//Cloning revival method.
//The pod handles the actual cloning while the computer manages the clone profiles

//Potential replacement for genetics revives or something I dunno (?)

//Find a dead mob with a brain and client.
/proc/find_dead_player(var/find_key, var/include_observers = 0)
	if(isnull(find_key))
		return

	var/mob/selected = null

	if(include_observers)
		for(var/mob/M in player_list)
			if((M.stat != DEAD) || (!M.client))
				continue
			if(M.ckey == find_key)
				selected = M
				break
	else
		for(var/mob/living/M in player_list)
			//Dead people only thanks!
			if((M.stat != DEAD) || (!M.client))
				continue
			//They need a brain!
			if(istype(M, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = M
				if(H.should_have_organ(BP_BRAIN) && !H.has_brain())
					continue
			if(M.ckey == find_key)
				selected = M
				break
	return selected

#define CLONE_BIOMASS 150

/obj/machinery/clonepod
	name = "cloning pod"
	desc = "An electronically-lockable pod for growing organic tissue."
	density = 1
	anchored = 1
	icon = 'icons/obj/cloning.dmi'
	icon_state = "pod_0"
	req_access = list(access_genetics) //For premature unlocking.
	var/mob/living/occupant
	var/heal_level = 20 // The clone is released once its health reaches this percentage.
	var/heal_rate = 1
	var/locked = 0
	var/obj/machinery/computer/cloning/connected = null //So we remember the connected clone machine.
	var/mess = 0 //Need to clean out it if it's full of exploded clone.
	var/attempting = 0 //One clone attempt at a time thanks
	var/eject_wait = 0 //Don't eject them as soon as they are created fuckkk
	var/biomass = CLONE_BIOMASS * 3

/obj/machinery/clonepod/New()
	set_extension(src, /datum/extension/interactive/multitool, /datum/extension/interactive/multitool/store)
	..()
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/clonepod(src)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src)
	component_parts += new /obj/item/weapon/stock_parts/scanning_module(src)
	component_parts += new /obj/item/weapon/stock_parts/scanning_module(src)
	component_parts += new /obj/item/weapon/stock_parts/console_screen(src)
	component_parts += new /obj/item/stack/cable_coil(src, 2)

	RefreshParts()
	update_icon()

/obj/machinery/clonepod/RefreshParts()
	..()
	var/rating = 0
	for(var/obj/item/weapon/stock_parts/P in component_parts)
		if(istype(P, /obj/item/weapon/stock_parts/scanning_module) || istype(P, /obj/item/weapon/stock_parts/manipulator))
			rating += P.rating

	heal_level = rating * 10 - 20
	heal_rate = round(rating / 4)

/obj/machinery/clonepod/Destroy()
	if(connected)
		connected.release_pod(src)
	return ..()

/obj/machinery/clonepod/attack_ai(mob/user as mob)

	add_hiddenprint(user)
	return attack_hand(user)

/obj/machinery/clonepod/attack_hand(var/mob/user)
	if((stat & NOPOWER) || !occupant || occupant.stat == DEAD)
		return
	to_chat(user, "Current clone cycle is [round(GetCloneReadiness())]% complete.")

//Clonepod

//Start growing a human clone in the pod!
/obj/machinery/clonepod/proc/growclone(var/datum/dna2/record/R)
	if(mess || attempting)
		return 0
	var/datum/mind/clonemind

	if(!config.use_cortical_stacks)
		clonemind = locate(R.mind)
		if(!istype(clonemind, /datum/mind))	//not a mind
			return 0
	else
		for(var/mob/observer/ghost/G in player_list)
			if(G.ckey == R.ckey)
				if(G.can_reenter_corpse)
					break
				else
					return 0

	attempting = 1 //One at a time!!
	locked = 1

	eject_wait = 1
	spawn(30)
		eject_wait = 0

	var/mob/living/carbon/human/H = new /mob/living/carbon/human(src, R.dna.species)
	occupant = H

	if(!R.dna.real_name /*|| config.use_cortical_stacks*/)	//to prevent null names
		R.dna.real_name = "clone ([rand(0,999)])"
	H.real_name = R.dna.real_name

	//Get the clone body ready
	H.setCloneLoss(H.maxHealth * (100 - config.health_threshold_crit) / 100) // We want to put them exactly at the crit level, so we deal this much clone damage
	H.Paralyse(4)

	//Here let's calculate their health so the pod doesn't immediately eject them!!!
	H.updatehealth()

	if(clonemind)
		clonemind.transfer_to(H)
		if(R.ckey)
			H.ckey = R.ckey
			to_chat(H, "<span class='notice'><b>Consciousness slowly creeps over you as your body regenerates.</b><br><i>So this is what cloning feels like?</i></span>")

	// -- Mode/mind specific stuff goes here
	callHook("clone", list(H))
	update_antag_icons(H.mind)
	// -- End mode specific stuff

	if(!R.dna)
		H.dna = new /datum/dna()
		H.dna.real_name = H.real_name
	else
		H.dna = R.dna
	H.UpdateAppearance()
	H.sync_organ_dna()
	if(heal_level < 60)
		randmutb(H) //Sometimes the clones come out wrong.
		H.dna.UpdateSE()
		H.dna.UpdateUI()

	H.set_cloned_appearance()
	update_icon()

	for(var/datum/language/L in R.languages)
		H.add_language(L.name)
	H.flavor_texts = R.flavor.Copy()
	attempting = 0
	return 1

/obj/machinery/clonepod/proc/GetCloneReadiness() // Returns a number between 0 and 100
	if(!occupant)
		return

	if(occupant.getCloneLoss() == 0) // Rare case, but theoretically possible
		return 100

	return between(0, 100 * (occupant.health - occupant.maxHealth * config.health_threshold_crit / 100) / (occupant.maxHealth * (heal_level - config.health_threshold_crit) / 100), 100)

//Grow clones to maturity then kick them out.  FREELOADERS
/obj/machinery/clonepod/process()

	if(stat & NOPOWER) //Autoeject if power is lost
		if(occupant)
			locked = 0
			go_out()
		return

	if((occupant) && (occupant.loc == src))
		if((occupant.stat == DEAD))  //Autoeject corpses
			locked = 0
			go_out()
			connected_message("Clone Rejected: Deceased.")
			return

		if(GetCloneReadiness() >= 100 && !eject_wait)
			playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)
			src.audible_message("\The [src] signals that the cloning process is complete.")
			connected_message("Cloning Process Complete.")
			locked = 0
			go_out()
			return

		occupant.Paralyse(4)

		//Slowly get that clone healed and finished.
		occupant.adjustCloneLoss(-2 * heal_rate)

		//Premature clones may have brain damage.
		occupant.adjustBrainLoss(-(ceil(0.5*heal_rate)))

		//So clones don't die of oxyloss in a running pod.
		if(occupant.reagents.get_reagent_amount("inaprovaline") < 30)
			occupant.reagents.add_reagent("inaprovaline", 60)
		occupant.Sleeping(30)
		//Also heal some oxyloss ourselves because inaprovaline is so bad at preventing it!!
		occupant.adjustOxyLoss(-4)

		use_power(7500) //This might need tweaking.
		return

	else if((!occupant) || (occupant.loc != src))
		occupant = null
		if(locked)
			locked = 0
		return

	return

//Let's unlock this early I guess.  Might be too early, needs tweaking.
/obj/machinery/clonepod/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(isnull(occupant))
		if(default_deconstruction_screwdriver(user, W))
			return
		if(default_deconstruction_crowbar(user, W))
			return
		if(default_part_replacement(user, W))
			return
			
	var/id = W.GetIdCard()
	if(id)
		if(!check_access(id))
			to_chat(user, "<span class='warning'>Access Denied.</span>")
			return
		if((!locked) || (isnull(occupant)))
			return
		if((occupant.health < -20) && (occupant.stat != 2))
			to_chat(user, "<span class='warning'>Access Refused.</span>")
			return
		else
			locked = 0
			to_chat(user, "System unlocked.")
	else if(istype(W, /obj/item/weapon/reagent_containers/food/snacks/meat))
		to_chat(user, "<span class='notice'>\The [src] processes \the [W].</span>")
		biomass += 50
		user.drop_item()
		qdel(W)
		return
	else if(istype(W, /obj/item/weapon/wrench))
		if(locked && (anchored || occupant))
			to_chat(user, "<span class='warning'>Can not do that while [src] is in use.</span>")
		else
			if(anchored)
				anchored = 0
				connected.pods -= src
				connected = null
			else
				anchored = 1
			playsound(loc, 'sound/items/Ratchet.ogg', 100, 1)
			if(anchored)
				user.visible_message("[user] secures [src] to the floor.", "You secure [src] to the floor.")
			else
				user.visible_message("[user] unsecures [src] from the floor.", "You unsecure [src] from the floor.")
	else
		..()

/obj/machinery/clonepod/emag_act(var/remaining_charges, var/mob/user)
	if(isnull(occupant))
		return NO_EMAG_ACT
	to_chat(user, "You force an emergency ejection.")
	locked = 0
	go_out()
	return 1

//Put messages in the connected computer's temp var for display.
/obj/machinery/clonepod/proc/connected_message(var/message)
	if((isnull(connected)) || (!istype(connected, /obj/machinery/computer/cloning)))
		return 0
	if(!message)
		return 0

	connected.temp = "[name] : [message]"
	connected.updateUsrDialog()
	return 1

/obj/machinery/clonepod/verb/eject()
	set name = "Eject Cloner"
	set category = "Object"
	set src in oview(1)

	if(usr.stat != 0)
		return
	go_out()
	add_fingerprint(usr)
	return

/obj/machinery/clonepod/proc/go_out()
	if(locked)
		return

	if(mess) //Clean that mess and dump those gibs!
		mess = 0
		gibs(loc)
		update_icon()
		return

	if(!(occupant))
		return

	if(occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE
	occupant.forceMove(loc)
	eject_wait = 0 //If it's still set somehow.
	domutcheck(occupant) //Waiting until they're out before possible transforming.
	occupant = null

	biomass -= CLONE_BIOMASS
	update_icon()
	return

/obj/machinery/clonepod/proc/malfunction()
	if(occupant)
		connected_message("Critical Error!")
		mess = 1
		update_icon()
		occupant.ghostize()
		spawn(5)
			qdel(occupant)
	return

/obj/machinery/clonepod/relaymove(mob/user as mob)
	if(user.stat)
		return
	go_out()
	return

/obj/machinery/clonepod/emp_act(severity)
	if(prob(100/severity))
		malfunction()
	..()

/obj/machinery/clonepod/ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/atom/movable/A as mob|obj in src)
				A.dropInto(loc)
				ex_act(severity)
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				for(var/atom/movable/A as mob|obj in src)
					A.dropInto(loc)
					ex_act(severity)
				qdel(src)
				return
		if(3.0)
			if(prob(25))
				for(var/atom/movable/A as mob|obj in src)
					A.dropInto(loc)
					ex_act(severity)
				qdel(src)
				return
		else
	return

/obj/machinery/clonepod/update_icon()
	..()
	icon_state = "pod_0"
	if (occupant && !(stat & NOPOWER))
		icon_state = "pod_1"
	else if (mess)
		icon_state = "pod_g"

//Health Tracker Implant

/obj/item/weapon/implant/health
	name = "health implant"
	var/healthstring = ""

/obj/item/weapon/implant/health/proc/sensehealth()
	if(!implanted)
		return "ERROR"
	else
		if(isliving(implanted))
			var/mob/living/L = implanted
			healthstring = "[round(L.getOxyLoss())] - [round(L.getFireLoss())] - [round(L.getToxLoss())] - [round(L.getBruteLoss())]"
		if(!healthstring)
			healthstring = "ERROR"
		return healthstring

//Disk stuff.
//The return of data disks?? Just for transferring between genetics machine/cloning machine.
//TO-DO: Make the genetics machine accept them.
/obj/item/weapon/disk/data
	name = "Cloning Data Disk"
	icon = 'icons/obj/cloning.dmi'
	icon_state = "datadisk0" //Gosh I hope syndies don't mistake them for the nuke disk.
	item_state = "card-id"
	w_class = ITEM_SIZE_SMALL
	var/datum/dna2/record/buf = null
	var/read_only = 0 //Well,it's still a floppy disk

/obj/item/weapon/disk/data/proc/initializeDisk()
	buf = new
	buf.dna=new

/obj/item/weapon/disk/data/demo
	name = "data disk - 'God Emperor of Mankind'"
	read_only = 1

	New()
		..()
		initializeDisk()
		buf.types=DNA2_BUF_UE|DNA2_BUF_UI
		//data = "066000033000000000AF00330660FF4DB002690"
		//data = "0C80C80C80C80C80C8000000000000161FBDDEF" - Farmer Jeff
		buf.dna.real_name="God Emperor of Mankind"
		buf.dna.unique_enzymes = md5(buf.dna.real_name)
		buf.dna.UI=list(0x066,0x000,0x033,0x000,0x000,0x000,0xAF0,0x033,0x066,0x0FF,0x4DB,0x002,0x690)
		//buf.dna.UI=list(0x0C8,0x0C8,0x0C8,0x0C8,0x0C8,0x0C8,0x000,0x000,0x000,0x000,0x161,0xFBD,0xDEF) // Farmer Jeff
		buf.dna.UpdateUI()

/obj/item/weapon/disk/data/monkey
	name = "data disk - 'Mr. Muggles'"
	read_only = 1

	New()
		..()
		initializeDisk()
		buf.types=DNA2_BUF_SE
		var/list/new_SE=list(0x098,0x3E8,0x403,0x44C,0x39F,0x4B0,0x59D,0x514,0x5FC,0x578,0x5DC,0x640,0x6A4)
		for(var/i=new_SE.len;i<=DNA_SE_LENGTH;i++)
			new_SE += rand(1,1024)
		buf.dna.SE=new_SE
		buf.dna.SetSEValueRange(MONKEYBLOCK,0xDAC, 0xFFF)

/obj/item/weapon/disk/data/New()
	..()
	var/diskcolor = pick(0,1,2)
	icon_state = "datadisk[diskcolor]"

/obj/item/weapon/disk/data/attack_self(mob/user as mob)
	read_only = !read_only
	to_chat(user, "You flip the write-protect tab to [read_only ? "protected" : "unprotected"].")

/obj/item/weapon/disk/data/examine(mob/user)
	..(user)
	to_chat(user, text("The write-protect tab is set to [read_only ? "protected" : "unprotected"]."))
	return

/*
 *	Diskette Box
 */

/obj/item/weapon/storage/box/disks
	name = "Diskette Box"
	icon_state = "disk_kit"

/obj/item/weapon/storage/box/disks/New()
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
	name = "H-87 Cloning Apparatus Manual"
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
