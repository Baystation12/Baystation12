/mob/living/silicon/robot/drone
	name = "drone"
	real_name = "drone"
	icon = 'icons/mob/robots.dmi'
	icon_state = "repairbot"
	maxHealth = 35
	health = 35
	cell_emp_mult = 1
	universal_speak = 0
	universal_understand = 1
	gender = NEUTER
	pass_flags = PASSTABLE
	braintype = "Robot"
	lawupdate = 0
	density = 1
	req_access = list(access_engine, access_robotics)
	integrated_light_power = 3
	local_transmit = 1

	mob_bump_flag = SIMPLE_ANIMAL
	mob_swap_flags = SIMPLE_ANIMAL
	mob_push_flags = SIMPLE_ANIMAL
	mob_always_swap = 1

	//Used for self-mailing.
	var/mail_destination = ""
	var/obj/machinery/drone_fabricator/master_fabricator
	var/law_type = /datum/ai_laws/drone
	var/module_type = /obj/item/weapon/robot_module/drone
	var/can_pull_size = 2
	var/can_pull_mobs

	holder_type = /obj/item/weapon/holder/drone

/mob/living/silicon/robot/drone/New()

	..()

	verbs += /mob/living/proc/hide
	remove_language("Robot Talk")
	add_language("Robot Talk", 0)
	add_language("Drone Talk", 1)

	//They are unable to be upgraded, so let's give them a bit of a better battery.
	cell.maxcharge = 10000
	cell.charge = 10000

	// NO BRAIN.
	mmi = null

	//We need to screw with their HP a bit. They have around one fifth as much HP as a full borg.
	for(var/V in components) if(V != "power cell")
		var/datum/robot_component/C = components[V]
		C.max_damage = 10

	verbs -= /mob/living/silicon/robot/verb/Namepick
	updateicon()

/mob/living/silicon/robot/drone/init()
	aiCamera = new/obj/item/device/camera/siliconcam/drone_camera(src)

	if(!laws) laws = new law_type
	if(!module) module = new module_type(src)

	flavor_text = "It's a tiny little repair drone. The casing is stamped with an NT logo and the subscript: 'NanoTrasen Recursive Repair Systems: Fixing Tomorrow's Problem, Today!'"
	playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 0)

//Redefining some robot procs...
/mob/living/silicon/robot/drone/SetName(pickedName as text)
	// Would prefer to call the grandparent proc but this isn't possible, so..
	real_name = pickedName
	name = real_name

/mob/living/silicon/robot/drone/updatename()
	real_name = "maintenance drone ([rand(100,999)])"
	name = real_name

/mob/living/silicon/robot/drone/updateicon()

	overlays.Cut()
	if(stat == 0)
		overlays += "eyes-[icon_state]"
	else
		overlays -= "eyes"

/mob/living/silicon/robot/drone/choose_icon()
	return

/mob/living/silicon/robot/drone/pick_module()
	return

//Drones cannot be upgraded with borg modules so we need to catch some items before they get used in ..().
/mob/living/silicon/robot/drone/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if(istype(W, /obj/item/borg/upgrade/))
		user << "<span class='danger'>\The [src] is not compatible with \the [W].</span>"
		return

	else if (istype(W, /obj/item/weapon/crowbar))
		user << "<span class='danger'>\The [src] is hermetically sealed. You can't open the case.</span>"
		return

	else if (istype(W, /obj/item/weapon/card/emag))

		if(!client || stat == 2)
			user << "<span class='danger'>There's not much point subverting this heap of junk.</span>"
			return

		if(emagged)
			src << "<span class='danger'>\The [user] attempts to load subversive software into you, but your hacked subroutines ignore the attempt.</span>"
			user << "<span class='danger'>You attempt to subvert [src], but the sequencer has no effect.</span>"
			return

		user << "<span class='danger'>You swipe the sequencer across [src]'s interface and watch its eyes flicker.</span>"
		src << "<span class='danger'>You feel a sudden burst of malware loaded into your execute-as-root buffer. Your tiny brain methodically parses, loads and executes the script.</span>"

		var/obj/item/weapon/card/emag/emag = W
		emag.uses--

		message_admins("[key_name_admin(user)] emagged drone [key_name_admin(src)].  Laws overridden.")
		log_game("[key_name(user)] emagged drone [key_name(src)].  Laws overridden.")
		var/time = time2text(world.realtime,"hh:mm:ss")
		lawchanges.Add("[time] <B>:</B> [user.name]([user.key]) emagged [name]([key])")

		emagged = 1
		lawupdate = 0
		connected_ai = null
		clear_supplied_laws()
		clear_inherent_laws()
		laws = new /datum/ai_laws/syndicate_override
		set_zeroth_law("Only [user] and people \he designates as being such are operatives.")

		src << "<b>Obey these laws:</b>"
		laws.show_laws(src)
		src << "<span class='danger'>ALERT: [user] is your new master. Obey \his commands and your new laws.</span>"
		return

	else if (istype(W, /obj/item/weapon/card/id)||istype(W, /obj/item/device/pda))

		if(stat == 2)

			if(!config.allow_drone_spawn || emagged || health < -35) //It's dead, Dave.
				user << "<span class='danger'>The interface is fried, and a distressing burned smell wafts from the robot's interior. You're not rebooting this one.</span>"
				return

			if(!allowed(usr))
				user << "<span class='danger'>Access denied.</span>"
				return

			user.visible_message("<span class='danger'>\The [user] swipes \his ID card through \the [src], attempting to reboot it.</span>", "<span class='danger'>>You swipe your ID card through \the [src], attempting to reboot it.</span>")
			var/drones = 0
			for(var/mob/living/silicon/robot/drone/D in world)
				if(D.key && D.client)
					drones++
			if(drones < config.max_maint_drones)
				request_player()
			return

		else
			user.visible_message("<span class='danger'>\The [user] swipes \his ID card through \the [src], attempting to shut it down.</span>", "<span class='danger'>You swipe your ID card through \the [src], attempting to shut it down.</span>")

			if(emagged)
				return

			if(allowed(usr))
				shut_down()
			else
				user << "<span class='danger'>Access denied.</span>"

		return

	..()

//DRONE LIFE/DEATH

//For some goddamn reason robots have this hardcoded. Redefining it for our fragile friends here.
/mob/living/silicon/robot/drone/updatehealth()
	if(status_flags & GODMODE)
		health = 35
		stat = CONSCIOUS
		return
	health = 35 - (getBruteLoss() + getFireLoss())
	return

//Easiest to check this here, then check again in the robot proc.
//Standard robots use config for crit, which is somewhat excessive for these guys.
//Drones killed by damage will gib.
/mob/living/silicon/robot/drone/handle_regular_status_updates()
	var/turf/T = get_turf(src)
	if((!T || health <= -35 || (master_fabricator && T.z != master_fabricator.z)) && src.stat != DEAD)
		timeofdeath = world.time
		death() //Possibly redundant, having trouble making death() cooperate.
		gib()
		return
	..()

//DRONE MOVEMENT.
/mob/living/silicon/robot/drone/Process_Spaceslipping(var/prob_slip)
	return 0

//CONSOLE PROCS
/mob/living/silicon/robot/drone/proc/law_resync()
	if(stat != 2)
		if(emagged)
			src << "<span class='danger'>You feel something attempting to modify your programming, but your hacked subroutines are unaffected.</span>"
		else
			src << "<span class='danger'>A reset-to-factory directive packet filters through your data connection, and you obediently modify your programming to suit it.</span>"
			full_law_reset()
			show_laws()

/mob/living/silicon/robot/drone/proc/shut_down()
	if(stat != 2)
		if(emagged)
			src << "<span class='danger'>You feel a system kill order percolate through your tiny brain, but it doesn't seem like a good idea to you.</span>"
		else
			src << "<span class='danger'>You feel a system kill order percolate through your tiny brain, and you obediently destroy yourself.</span>"
			death()

/mob/living/silicon/robot/drone/proc/full_law_reset()
	clear_supplied_laws(1)
	clear_inherent_laws(1)
	clear_ion_laws(1)
	laws = new law_type

//Reboot procs.

/mob/living/silicon/robot/drone/proc/request_player()
	for(var/mob/dead/observer/O in player_list)
		if(jobban_isbanned(O, "Cyborg"))
			continue
		if(O.client)
			if(O.client.prefs.be_special & BE_PAI)
				question(O.client)

/mob/living/silicon/robot/drone/proc/question(var/client/C)
	spawn(0)
		if(!C || jobban_isbanned(C,"Cyborg"))	return
		var/response = alert(C, "Someone is attempting to reboot a maintenance drone. Would you like to play as one?", "Maintenance drone reboot", "Yes", "No", "Never for this round")
		if(!C || ckey)
			return
		if(response == "Yes")
			transfer_personality(C)
		else if (response == "Never for this round")
			C.prefs.be_special ^= BE_PAI

/mob/living/silicon/robot/drone/proc/transfer_personality(var/client/player)

	if(!player) return

	src.ckey = player.ckey

	if(player.mob && player.mob.mind)
		player.mob.mind.transfer_to(src)

	lawupdate = 0
	src << "<b>Systems rebooted</b>. Loading base pattern maintenance protocol... <b>loaded</b>."
	full_law_reset()
	welcome_drone()

/mob/living/silicon/robot/drone/proc/welcome_drone()
	src << "<b>You are a maintenance drone, a tiny-brained robotic repair machine</b>."
	src << "You have no individual will, no personality, and no drives or urges other than your laws."
	src << "Remember,  you are <b>lawed against interference with the crew</b>. Also remember, <b>you DO NOT take orders from the AI.</b>"
	src << "Use <b>say ;Hello</b> to talk to other drones and <b>say Hello</b> to speak silently to your nearby fellows."

/mob/living/silicon/robot/drone/start_pulling(var/atom/movable/AM)

	if(!(istype(AM,/obj/item/pipe) || istype(AM,/obj/structure/disposalconstruct)))
		if(istype(AM,/obj/item))
			var/obj/item/O = AM
			if(O.w_class > can_pull_size)
				src << "<span class='warning'>You are too small to pull that.</span>"
				return
		else
			if(!can_pull_mobs)
				src << "<span class='warning'>You are too small to pull that.</span>"
				return
	..()

/mob/living/silicon/robot/drone/add_robot_verbs()
	src.verbs |= silicon_subsystems

/mob/living/silicon/robot/drone/remove_robot_verbs()
	src.verbs -= silicon_subsystems

/mob/living/silicon/robot/drone/construction
	icon_state = "constructiondrone"
	law_type = /datum/ai_laws/construction_drone
	module_type = /obj/item/weapon/robot_module/drone/construction
	can_pull_size = 5
	can_pull_mobs = 1

/mob/living/silicon/robot/drone/construction/welcome_drone()
	src << "<b>You are a construction drone, an autonomous engineering and fabrication system.</b>."
	src << "You are assigned to a Sol Central construction project. The name is irrelevant. Your task is to complete construction and subsystem integration as soon as possible."
	src << "Use <b>:d</b> to talk to other drones and <b>say</b> to speak silently to your nearby fellows."
	src << "<b>You do not follow orders from anyone; not the AI, not humans, and not other synthetics.</b>."

/mob/living/silicon/robot/drone/construction/init()
	..()
	flavor_text = "It's a bulky construction drone stamped with a Sol Central glyph."

/mob/living/silicon/robot/drone/construction/updatename()
	real_name = "construction drone ([rand(100,999)])"
	name = real_name
