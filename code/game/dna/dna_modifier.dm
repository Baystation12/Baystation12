#define DNA_BLOCK_SIZE 3

// Buffer datatype flags.
#define DNA2_BUF_UI 1
#define DNA2_BUF_UE 2
#define DNA2_BUF_SE 4

//list("data" = null, "owner" = null, "label" = null, "type" = null, "ue" = 0),
/datum/dna2/record
	var/datum/dna/dna = null
	var/types=0
	var/name="Empty"

	// Stuff for cloners
	var/id=null
	var/implant=null
	var/ckey=null
	var/mind=null
	var/languages=null
	var/list/flavor=null

/datum/dna2/record/proc/GetData()
	var/list/ser=list("data" = null, "owner" = null, "label" = null, "type" = null, "ue" = 0)
	if(dna)
		ser["ue"] = (types & DNA2_BUF_UE) == DNA2_BUF_UE
		if(types & DNA2_BUF_SE)
			ser["data"] = dna.SE
		else
			ser["data"] = dna.UI
		ser["owner"] = src.dna.real_name
		ser["label"] = name
		if(types & DNA2_BUF_UI)
			ser["type"] = "ui"
		else
			ser["type"] = "se"
	return ser

/////////////////////////// DNA MACHINES
/obj/machinery/dna_scannernew
	name = "\improper DNA modifier"
	desc = "It scans DNA structures."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "scanner_0"
	density = 1
	anchored = 1.0
	use_power = 1
	idle_power_usage = 50
	active_power_usage = 300
	interact_offline = 1
	var/locked = 0
	var/mob/living/carbon/occupant = null
	var/obj/item/weapon/reagent_containers/glass/beaker = null
	var/opened = 0

/obj/machinery/dna_scannernew/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/clonescanner(src)
	component_parts += new /obj/item/weapon/stock_parts/scanning_module(src)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src)
	component_parts += new /obj/item/weapon/stock_parts/micro_laser(src)
	component_parts += new /obj/item/weapon/stock_parts/console_screen(src)
	component_parts += new /obj/item/stack/cable_coil(src)
	component_parts += new /obj/item/stack/cable_coil(src)
	RefreshParts()

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

	eject_occupant()

	add_fingerprint(usr)
	return

/obj/machinery/dna_scannernew/proc/eject_occupant()
	src.go_out()
	for(var/obj/O in src)
		if((!istype(O,/obj/item/weapon/reagent_containers)) && (!istype(O,/obj/item/weapon/circuitboard/clonescanner)) && (!istype(O,/obj/item/weapon/stock_parts)) && (!istype(O,/obj/item/stack/cable_coil)))
			O.loc = get_turf(src)//Ejects items that manage to get in there (exluding the components)
	if(!occupant)
		for(var/mob/M in src)//Failsafe so you can get mobs out
			M.loc = get_turf(src)

/obj/machinery/dna_scannernew/verb/move_inside()
	set src in oview(1)
	set category = "Object"
	set name = "Enter DNA Scanner"

	if (usr.stat != 0)
		return
	if (!ishuman(usr) && !issmall(usr)) //Make sure they're a mob that has dna
		to_chat(usr, "<span class='notice'>Try as you might, you can not climb up into the scanner.</span>")
		return
	if (src.occupant)
		to_chat(usr, "<span class='warning'>The scanner is already occupied!</span>")
		return
	if (usr.abiotic())
		to_chat(usr, "<span class='warning'>The subject cannot have abiotic items on.</span>")
		return
	usr.stop_pulling()
	usr.reset_view(src)
	usr.loc = src
	src.occupant = usr
	src.icon_state = "scanner_1"
	src.add_fingerprint(usr)
	return

/obj/machinery/dna_scannernew/attackby(var/obj/item/weapon/item as obj, var/mob/user as mob)
	if(istype(item, /obj/item/weapon/reagent_containers/glass))
		if(beaker)
			to_chat(user, "<span class='warning'>A beaker is already loaded into the machine.</span>")
			return

		beaker = item
		user.drop_item()
		item.loc = src
		user.visible_message("\The [user] adds \a [item] to \the [src]!", "You add \a [item] to \the [src]!")
		return
	else if (!istype(item, /obj/item/weapon/grab))
		return
	var/obj/item/weapon/grab/G = item
	if (!ismob(G.affecting))
		return
	if (src.occupant)
		to_chat(user, "<span class='warning'>The scanner is already occupied!</span>")
		return
	if (G.affecting.abiotic())
		to_chat(user, "<span class='warning'>The subject cannot have abiotic items on.</span>")
		return
	put_in(G.affecting)
	src.add_fingerprint(user)
	qdel(G)
	return

//Like grab-putting, but for mouse-drop.
/obj/machinery/dna_scannernew/MouseDrop_T(var/mob/target, var/mob/user)
	if(!istype(target))
		return
	if (!CanMouseDrop(target, user))
		return
	if (src.occupant)
		to_chat(user, "<span class='warning'>The scanner is already occupied!</span>")
		return
	if (target.abiotic())
		to_chat(user, "<span class='warning'>The subject cannot have abiotic items on.</span>")
		return
	if (target.buckled)
		to_chat(user, "<span class='warning'>Unbuckle the subject before attempting to move them.</span>")
		return
	user.visible_message("<span class='notice'>\The [user] begins placing \the [target] into \the [src].</span>", "<span class='notice'>You start placing \the [target] into \the [src].</span>")
	if(!do_after(user, 30, src))
		return
	put_in(target)
	src.add_fingerprint(user)

/obj/machinery/dna_scannernew/proc/put_in(var/mob/M)
	if(M.client)
		M.client.perspective = EYE_PERSPECTIVE
		M.client.eye = src
	M.loc = src
	src.occupant = M
	src.icon_state = "scanner_1"

	// search for ghosts, if the corpse is empty and the scanner is connected to a cloner
	if(!config.use_cortical_stacks)
		if(locate(/obj/machinery/computer/cloning, get_step(src, NORTH)) \
			|| locate(/obj/machinery/computer/cloning, get_step(src, SOUTH)) \
			|| locate(/obj/machinery/computer/cloning, get_step(src, EAST)) \
			|| locate(/obj/machinery/computer/cloning, get_step(src, WEST)))

			if(!M.client && M.mind)
				for(var/mob/observer/ghost/ghost in player_list)
					if(ghost.mind == M.mind)
						to_chat(ghost, "<b><font color = #330033><font size = 3>Your corpse has been placed into a cloning scanner. Return to your body if you want to be resurrected/cloned!</b> (Verbs -> Ghost -> Re-enter corpse)</font></font>")
						break
	return

/obj/machinery/dna_scannernew/proc/go_out()
	if ((!( src.occupant ) || src.locked))
		return
	src.occupant.reset_view(null)
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
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				for(var/atom/movable/A as mob|obj in src)
					A.loc = src.loc
					ex_act(severity)
					//Foreach goto(108)
				//SN src = null
				qdel(src)
				return
		if(3.0)
			if (prob(25))
				for(var/atom/movable/A as mob|obj in src)
					A.loc = src.loc
					ex_act(severity)
					//Foreach goto(181)
				//SN src = null
				qdel(src)
				return
		else
	return

/obj/machinery/computer/scan_consolenew
	name = "DNA Modifier Access Console"
	desc = "Scan DNA."
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "med_key"
	icon_screen = "dna"
	density = 1
	circuit = /obj/item/weapon/circuitboard/scan_consolenew
	var/selected_ui_block = 1.0
	var/selected_ui_subblock = 1.0
	var/selected_se_block = 1.0
	var/selected_se_subblock = 1.0
	var/selected_ui_target = 1
	var/selected_ui_target_hex = 1
	var/radiation_duration = 2.0
	var/radiation_intensity = 1.0
	var/list/datum/dna2/record/buffers[3]
	var/irradiating = 0
	var/injector_ready = 0	//Quick fix for issue 286 (screwdriver the screen twice to restore injector)	-Pete
	var/obj/machinery/dna_scannernew/connected = null
	var/obj/item/weapon/disk/data/disk = null
	var/selected_menu_key = null
	anchored = 1
	use_power = 1
	idle_power_usage = 10
	active_power_usage = 400
	var/waiting_for_user_input=0 // Fix for #274 (Mash create block injector without answering dialog to make unlimited injectors) - N3X

/obj/machinery/computer/scan_consolenew/attackby(obj/item/I as obj, mob/user as mob)
	if (istype(I, /obj/item/weapon/disk/data)) //INSERT SOME diskS
		if (!src.disk)
			user.drop_item()
			I.loc = src
			src.disk = I
			to_chat(user, "You insert \the [I].")
			nanomanager.update_uis(src) // update all UIs attached to src
			return
	else
		..()
	return

/obj/machinery/computer/scan_consolenew/ex_act(severity)

	switch(severity)
		if(1.0)
			//SN src = null
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				//SN src = null
				qdel(src)
				return
		else
	return

/obj/machinery/computer/scan_consolenew/New()
	..()
	for(var/i=0;i<3;i++)
		buffers[i+1]=new /datum/dna2/record
	spawn(5)
		for(dir in list(NORTH,EAST,SOUTH,WEST))
			connected = locate(/obj/machinery/dna_scannernew, get_step(src, dir))
			if(!isnull(connected))
				break
		spawn(250)
			src.injector_ready = 1
		return
	return

/obj/machinery/computer/scan_consolenew/proc/all_dna_blocks(var/list/buffer)
	var/list/arr = list()
	for(var/i = 1, i <= buffer.len, i++)
		arr += "[i]:[EncodeDNABlock(buffer[i])]"
	return arr

/obj/machinery/computer/scan_consolenew/proc/setInjectorBlock(var/obj/item/weapon/dnainjector/I, var/blk, var/datum/dna2/record/buffer)
	var/pos = findtext(blk,":")
	if(!pos) return 0
	var/id = text2num(copytext(blk,1,pos))
	if(!id) return 0
	I.block = id
	I.buf = buffer
	return 1

/*
/obj/machinery/computer/scan_consolenew/process() //not really used right now
	if(stat & (NOPOWER|BROKEN))
		return
	if (!( src.status )) //remove this
		return
	return
*/

/obj/machinery/computer/scan_consolenew/attack_ai(user as mob)
	src.add_hiddenprint(user)
	ui_interact(user)

/obj/machinery/computer/scan_consolenew/attack_hand(user as mob)
	if(!..())
		ui_interact(user)

 /**
  * The ui_interact proc is used to open and update Nano UIs
  * If ui_interact is not used then the UI will not update correctly
  * ui_interact is currently defined for /atom/movable (which is inherited by /obj and /mob)
  *
  * @param user /mob The mob who is interacting with this ui
  * @param ui_key string A string key to use for this ui. Allows for multiple unique uis on one obj/mob (defaut value "main")
  * @param ui /datum/nanoui This parameter is passed by the nanoui process() proc when updating an open ui
  *
  * @return nothing
  */
/obj/machinery/computer/scan_consolenew/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)

	if(user == connected.occupant || user.stat)
		return

	// this is the data which will be sent to the ui
	var/data[0]
	data["selectedMenuKey"] = selected_menu_key
	data["locked"] = src.connected.locked
	data["hasOccupant"] = connected.occupant ? 1 : 0

	data["isInjectorReady"] = injector_ready

	data["hasDisk"] = disk ? 1 : 0

	var/diskData[0]
	if (!disk || !disk.buf)
		diskData["data"] = null
		diskData["owner"] = null
		diskData["label"] = null
		diskData["type"] = null
		diskData["ue"] = null
	else
		diskData = disk.buf.GetData()
	data["disk"] = diskData

	var/list/new_buffers = list()
	for(var/datum/dna2/record/buf in src.buffers)
		new_buffers += list(buf.GetData())
	data["buffers"]=new_buffers

	data["radiationIntensity"] = radiation_intensity
	data["radiationDuration"] = radiation_duration
	data["irradiating"] = irradiating

	data["dnaBlockSize"] = DNA_BLOCK_SIZE
	data["selectedUIBlock"] = selected_ui_block
	data["selectedUISubBlock"] = selected_ui_subblock
	data["selectedSEBlock"] = selected_se_block
	data["selectedSESubBlock"] = selected_se_subblock
	data["selectedUITarget"] = selected_ui_target
	data["selectedUITargetHex"] = selected_ui_target_hex

	var/occupantData[0]
	if (!src.connected.occupant || !src.connected.occupant.dna)
		occupantData["name"] = null
		occupantData["stat"] = null
		occupantData["isViableSubject"] = null
		occupantData["health"] = null
		occupantData["maxHealth"] = null
		occupantData["minHealth"] = null
		occupantData["uniqueEnzymes"] = null
		occupantData["uniqueIdentity"] = null
		occupantData["structuralEnzymes"] = null
		occupantData["radiationLevel"] = null
	else
		occupantData["name"] = connected.occupant.real_name
		occupantData["stat"] = connected.occupant.stat
		occupantData["isViableSubject"] = 1
		if (NOCLONE in connected.occupant.mutations || !src.connected.occupant.dna)
			occupantData["isViableSubject"] = 0
		occupantData["health"] = connected.occupant.health
		occupantData["maxHealth"] = connected.occupant.maxHealth
		occupantData["minHealth"] = config.health_threshold_dead
		occupantData["uniqueEnzymes"] = connected.occupant.dna.unique_enzymes
		occupantData["uniqueIdentity"] = connected.occupant.dna.uni_identity
		occupantData["structuralEnzymes"] = connected.occupant.dna.struc_enzymes
		occupantData["radiationLevel"] = connected.occupant.radiation
	data["occupant"] = occupantData;

	data["isBeakerLoaded"] = connected.beaker ? 1 : 0
	data["beakerLabel"] = null
	data["beakerVolume"] = 0
	if(connected.beaker)
		data["beakerLabel"] = connected.beaker.label_text ? connected.beaker.label_text : null
		if (connected.beaker.reagents && connected.beaker.reagents.reagent_list.len)
			for(var/datum/reagent/R in connected.beaker.reagents.reagent_list)
				data["beakerVolume"] += R.volume

	// update the ui if it exists, returns null if no ui is passed/found
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "dna_modifier.tmpl", "DNA Modifier Console", 660, 700)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
		// auto update every Master Controller tick
		ui.set_auto_update(1)

/obj/machinery/computer/scan_consolenew/Topic(href, href_list)
	if(..())
		return 0 // don't update uis
	if(!istype(usr.loc, /turf))
		return 0 // don't update uis
	if(!src || !src.connected)
		return 0 // don't update uis
	if(irradiating) // Make sure that it isn't already irradiating someone...
		return 0 // don't update uis

	add_fingerprint(usr)

	if (href_list["selectMenuKey"])
		selected_menu_key = href_list["selectMenuKey"]
		return 1 // return 1 forces an update to all Nano uis attached to src

	if (href_list["toggleLock"])
		if ((src.connected && src.connected.occupant))
			src.connected.locked = !( src.connected.locked )
		return 1 // return 1 forces an update to all Nano uis attached to src

	if (href_list["pulseRadiation"])
		irradiating = src.radiation_duration
		var/lock_state = src.connected.locked
		src.connected.locked = 1//lock it
		nanomanager.update_uis(src) // update all UIs attached to src

		sleep(10*src.radiation_duration) // sleep for radiation_duration seconds

		irradiating = 0

		if (!src.connected.occupant)
			return 1 // return 1 forces an update to all Nano uis attached to src

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

		src.connected.occupant.apply_effect(((src.radiation_intensity*3)+src.radiation_duration*3), IRRADIATE, blocked = 0)
		src.connected.locked = lock_state
		return 1 // return 1 forces an update to all Nano uis attached to src

	if (href_list["radiationDuration"])
		if (text2num(href_list["radiationDuration"]) > 0)
			if (src.radiation_duration < 20)
				src.radiation_duration += 2
		else
			if (src.radiation_duration > 2)
				src.radiation_duration -= 2
		return 1 // return 1 forces an update to all Nano uis attached to src

	if (href_list["radiationIntensity"])
		if (text2num(href_list["radiationIntensity"]) > 0)
			if (src.radiation_intensity < 10)
				src.radiation_intensity++
		else
			if (src.radiation_intensity > 1)
				src.radiation_intensity--
		return 1 // return 1 forces an update to all Nano uis attached to src

	////////////////////////////////////////////////////////

	if (href_list["changeUITarget"] && text2num(href_list["changeUITarget"]) > 0)
		if (src.selected_ui_target < 15)
			src.selected_ui_target++
			src.selected_ui_target_hex = src.selected_ui_target
			switch(selected_ui_target)
				if(10)
					src.selected_ui_target_hex = "A"
				if(11)
					src.selected_ui_target_hex = "B"
				if(12)
					src.selected_ui_target_hex = "C"
				if(13)
					src.selected_ui_target_hex = "D"
				if(14)
					src.selected_ui_target_hex = "E"
				if(15)
					src.selected_ui_target_hex = "F"
		else
			src.selected_ui_target = 0
			src.selected_ui_target_hex = 0
		return 1 // return 1 forces an update to all Nano uis attached to src

	if (href_list["changeUITarget"] && text2num(href_list["changeUITarget"]) < 1)
		if (src.selected_ui_target > 0)
			src.selected_ui_target--
			src.selected_ui_target_hex = src.selected_ui_target
			switch(selected_ui_target)
				if(10)
					src.selected_ui_target_hex = "A"
				if(11)
					src.selected_ui_target_hex = "B"
				if(12)
					src.selected_ui_target_hex = "C"
				if(13)
					src.selected_ui_target_hex = "D"
				if(14)
					src.selected_ui_target_hex = "E"
		else
			src.selected_ui_target = 15
			src.selected_ui_target_hex = "F"
		return 1 // return 1 forces an update to all Nano uis attached to src

	if (href_list["selectUIBlock"] && href_list["selectUISubblock"]) // This chunk of code updates selected block / sub-block based on click
		var/select_block = text2num(href_list["selectUIBlock"])
		var/select_subblock = text2num(href_list["selectUISubblock"])
		if ((select_block <= DNA_UI_LENGTH) && (select_block >= 1))
			src.selected_ui_block = select_block
		if ((select_subblock <= DNA_BLOCK_SIZE) && (select_subblock >= 1))
			src.selected_ui_subblock = select_subblock
		return 1 // return 1 forces an update to all Nano uis attached to src

	if (href_list["pulseUIRadiation"])
		var/block = src.connected.occupant.dna.GetUISubBlock(src.selected_ui_block,src.selected_ui_subblock)

		irradiating = src.radiation_duration
		var/lock_state = src.connected.locked
		src.connected.locked = 1//lock it
		nanomanager.update_uis(src) // update all UIs attached to src

		sleep(10*src.radiation_duration) // sleep for radiation_duration seconds

		irradiating = 0

		if (!src.connected.occupant)
			return 1

		if (prob((80 + (src.radiation_duration / 2))))
			block = miniscrambletarget(num2text(selected_ui_target), src.radiation_intensity, src.radiation_duration)
			src.connected.occupant.dna.SetUISubBlock(src.selected_ui_block,src.selected_ui_subblock,block)
			src.connected.occupant.UpdateAppearance()
			src.connected.occupant.apply_effect((src.radiation_intensity+src.radiation_duration), IRRADIATE, blocked = 0)
		else
			if	(prob(20+src.radiation_intensity))
				randmutb(src.connected.occupant)
				domutcheck(src.connected.occupant,src.connected)
			else
				randmuti(src.connected.occupant)
				src.connected.occupant.UpdateAppearance()
			src.connected.occupant.apply_effect(((src.radiation_intensity*2)+src.radiation_duration), IRRADIATE, blocked = 0)
		src.connected.locked = lock_state
		return 1 // return 1 forces an update to all Nano uis attached to src

	////////////////////////////////////////////////////////

	if (href_list["injectRejuvenators"])
		if (!connected.occupant)
			return 0
		var/inject_amount = round(text2num(href_list["injectRejuvenators"]), 5) // round to nearest 5
		if (inject_amount < 0) // Since the user can actually type the commands himself, some sanity checking
			inject_amount = 0
		if (inject_amount > 50)
			inject_amount = 50
		connected.beaker.reagents.trans_to_mob(connected.occupant, inject_amount, CHEM_BLOOD)
		return 1 // return 1 forces an update to all Nano uis attached to src

	////////////////////////////////////////////////////////

	if (href_list["selectSEBlock"] && href_list["selectSESubblock"]) // This chunk of code updates selected block / sub-block based on click (se stands for strutural enzymes)
		var/select_block = text2num(href_list["selectSEBlock"])
		var/select_subblock = text2num(href_list["selectSESubblock"])
		if ((select_block <= DNA_SE_LENGTH) && (select_block >= 1))
			src.selected_se_block = select_block
		if ((select_subblock <= DNA_BLOCK_SIZE) && (select_subblock >= 1))
			src.selected_se_subblock = select_subblock
		//testing("User selected block [selected_se_block] (sent [select_block]), subblock [selected_se_subblock] (sent [select_block]).")
		return 1 // return 1 forces an update to all Nano uis attached to src

	if (href_list["pulseSERadiation"])
		var/block = src.connected.occupant.dna.GetSESubBlock(src.selected_se_block,src.selected_se_subblock)
		//var/original_block=block
		//testing("Irradiating SE block [src.selected_se_block]:[src.selected_se_subblock] ([block])...")

		irradiating = src.radiation_duration
		var/lock_state = src.connected.locked
		src.connected.locked = 1 //lock it
		nanomanager.update_uis(src) // update all UIs attached to src

		sleep(10*src.radiation_duration) // sleep for radiation_duration seconds

		irradiating = 0

		if(src.connected.occupant)
			if (prob((80 + (src.radiation_duration / 2))))
				// FIXME: Find out what these corresponded to and change them to the WHATEVERBLOCK they need to be.
				//if ((src.selected_se_block != 2 || src.selected_se_block != 12 || src.selected_se_block != 8 || src.selected_se_block || 10) && prob (20))
				var/real_SE_block=selected_se_block
				block = miniscramble(block, src.radiation_intensity, src.radiation_duration)
				if(prob(20))
					if (src.selected_se_block > 1 && src.selected_se_block < DNA_SE_LENGTH/2)
						real_SE_block++
					else if (src.selected_se_block > DNA_SE_LENGTH/2 && src.selected_se_block < DNA_SE_LENGTH)
						real_SE_block--

				//testing("Irradiated SE block [real_SE_block]:[src.selected_se_subblock] ([original_block] now [block]) [(real_SE_block!=selected_se_block) ? "(SHIFTED)":""]!")
				connected.occupant.dna.SetSESubBlock(real_SE_block,selected_se_subblock,block)
				src.connected.occupant.apply_effect((src.radiation_intensity+src.radiation_duration), IRRADIATE, blocked = 0)
				domutcheck(src.connected.occupant,src.connected)
			else
				src.connected.occupant.apply_effect(((src.radiation_intensity*2)+src.radiation_duration), IRRADIATE, blocked = 0)
				if	(prob(80-src.radiation_duration))
					//testing("Random bad mut!")
					randmutb(src.connected.occupant)
					domutcheck(src.connected.occupant,src.connected)
				else
					randmuti(src.connected.occupant)
					//testing("Random identity mut!")
					src.connected.occupant.UpdateAppearance()
		src.connected.locked = lock_state
		return 1 // return 1 forces an update to all Nano uis attached to src

	if(href_list["ejectBeaker"])
		if(connected.beaker)
			var/obj/item/weapon/reagent_containers/glass/B = connected.beaker
			B.loc = connected.loc
			connected.beaker = null
		return 1

	if(href_list["ejectOccupant"])
		connected.eject_occupant()
		return 1

	// Transfer Buffer Management
	if(href_list["bufferOption"])
		var/bufferOption = href_list["bufferOption"]

		// These bufferOptions do not require a bufferId
		if (bufferOption == "wipeDisk")
			if ((isnull(src.disk)) || (src.disk.read_only))
				//src.temphtml = "Invalid disk. Please try again."
				return 0

			src.disk.buf=null
			//src.temphtml = "Data saved."
			return 1

		if (bufferOption == "ejectDisk")
			if (!src.disk)
				return
			src.disk.loc = get_turf(src)
			src.disk = null
			return 1

		// All bufferOptions from here on require a bufferId
		if (!href_list["bufferId"])
			return 0

		var/bufferId = text2num(href_list["bufferId"])

		if (bufferId < 1 || bufferId > 3)
			return 0 // Not a valid buffer id

		if (bufferOption == "saveUI")
			if(src.connected.occupant && src.connected.occupant.dna)
				var/datum/dna2/record/databuf=new
				databuf.types = DNA2_BUF_UE
				databuf.dna = src.connected.occupant.dna.Clone()
				if(ishuman(connected.occupant))
					databuf.dna.real_name=connected.occupant.dna.real_name
				databuf.name = "Unique Identifier"
				src.buffers[bufferId] = databuf
			return 1

		if (bufferOption == "saveUIAndUE")
			if(src.connected.occupant && src.connected.occupant.dna)
				var/datum/dna2/record/databuf=new
				databuf.types = DNA2_BUF_UI|DNA2_BUF_UE
				databuf.dna = src.connected.occupant.dna.Clone()
				if(ishuman(connected.occupant))
					databuf.dna.real_name=connected.occupant.dna.real_name
				databuf.name = "Unique Identifier + Unique Enzymes"
				src.buffers[bufferId] = databuf
			return 1

		if (bufferOption == "saveSE")
			if(src.connected.occupant && src.connected.occupant.dna)
				var/datum/dna2/record/databuf=new
				databuf.types = DNA2_BUF_SE
				databuf.dna = src.connected.occupant.dna.Clone()
				if(ishuman(connected.occupant))
					databuf.dna.real_name=connected.occupant.dna.real_name
				databuf.name = "Structural Enzymes"
				src.buffers[bufferId] = databuf
			return 1

		if (bufferOption == "clear")
			src.buffers[bufferId]=new /datum/dna2/record()
			return 1

		if (bufferOption == "changeLabel")
			var/datum/dna2/record/buf = src.buffers[bufferId]
			var/text = sanitize(input(usr, "New Label:", "Edit Label", buf.name) as text|null, MAX_NAME_LEN)
			buf.name = text
			src.buffers[bufferId] = buf
			return 1

		if (bufferOption == "transfer")
			if (!src.connected.occupant || (NOCLONE in src.connected.occupant.mutations) || !src.connected.occupant.dna)
				return

			irradiating = 2
			var/lock_state = src.connected.locked
			src.connected.locked = 1//lock it
			nanomanager.update_uis(src) // update all UIs attached to src

			sleep(10*2) // sleep for 2 seconds

			irradiating = 0
			src.connected.locked = lock_state

			var/datum/dna2/record/buf = src.buffers[bufferId]

			if ((buf.types & DNA2_BUF_UI))
				if ((buf.types & DNA2_BUF_UE))
					src.connected.occupant.real_name = buf.dna.real_name
					src.connected.occupant.name = buf.dna.real_name
				src.connected.occupant.UpdateAppearance(buf.dna.UI.Copy())
			else if (buf.types & DNA2_BUF_SE)
				src.connected.occupant.dna.SE = buf.dna.SE
				src.connected.occupant.dna.UpdateSE()
				domutcheck(src.connected.occupant,src.connected)
			src.connected.occupant.apply_effect(rand(20,50), IRRADIATE, blocked = 0)
			return 1

		if (bufferOption == "createInjector")
			if (src.injector_ready || waiting_for_user_input)

				var/success = 1
				var/obj/item/weapon/dnainjector/I = new /obj/item/weapon/dnainjector
				var/datum/dna2/record/buf = src.buffers[bufferId]
				if(href_list["createBlockInjector"])
					waiting_for_user_input=1
					var/list/selectedbuf
					if(buf.types & DNA2_BUF_SE)
						selectedbuf=buf.dna.SE
					else
						selectedbuf=buf.dna.UI
					var/blk = input(usr,"Select Block","Block") in all_dna_blocks(selectedbuf)
					success = setInjectorBlock(I,blk,buf)
				else
					I.buf = buf
				waiting_for_user_input=0
				if(success)
					I.loc = src.loc
					I.name += " ([buf.name])"
					//src.temphtml = "Injector created."
					src.injector_ready = 0
					spawn(300)
						src.injector_ready = 1
				//else
					//src.temphtml = "Error in injector creation."
			//else
				//src.temphtml = "Replicator not ready yet."
			return 1

		if (bufferOption == "loadDisk")
			if ((isnull(src.disk)) || (!src.disk.buf))
				//src.temphtml = "Invalid disk. Please try again."
				return 0

			src.buffers[bufferId]=src.disk.buf
			//src.temphtml = "Data loaded."
			return 1

		if (bufferOption == "saveDisk")
			if ((isnull(src.disk)) || (src.disk.read_only))
				//src.temphtml = "Invalid disk. Please try again."
				return 0

			var/datum/dna2/record/buf = src.buffers[bufferId]

			src.disk.buf = buf
			src.disk.name = "data disk - '[buf.dna.real_name]'"
			//src.temphtml = "Data saved."
			return 1


/////////////////////////// DNA MACHINES
