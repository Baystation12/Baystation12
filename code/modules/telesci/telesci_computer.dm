/obj/machinery/computer/telescience
	name = "telepad control console"
	desc = "Used to teleport objects to and from the telescience telepad."
	icon_state = "teleport"
	var/sending = 1
	var/obj/machinery/telepad/telepad = null

	// VARIABLES //
	var/teles_left	// How many teleports left until it becomes uncalibrated
	var/x_off	// X offset
	var/y_off	// Y offset
	var/x_co	// X coordinate
	var/y_co	// Y coordinate
	var/z_co	// Z coordinate

/obj/machinery/computer/telescience/New()
	..()
	teles_left = rand(8,12)
	x_off = rand(-10,10)
	y_off = rand(-10,10)
	initialize()

/obj/machinery/computer/telescience/initialize()
	..()
	telepad = locate() in range(src, 7)

/obj/machinery/computer/telescience/update_icon()
	if(stat & BROKEN)
		icon_state = "telescib"
	else
		if(stat & NOPOWER)
			src.icon_state = "teleport0"
			stat |= NOPOWER
		else
			icon_state = initial(icon_state)
			stat &= ~NOPOWER

/obj/machinery/computer/telescience/attack_paw(mob/user)
	user << "You are too primitive to use this computer."
	return

/obj/machinery/computer/telescience/attack_ai(mob/user)
	src.attack_hand(user)

/obj/machinery/computer/telescience/attack_hand(mob/user)
	if(..())
		return
	var/t = ""
	t += "<A href='?src=\ref[src];setx=1'>Set X</A>"
	t += "<A href='?src=\ref[src];sety=1'>Set Y</A>"
	t += "<A href='?src=\ref[src];setz=1'>Set Z</A>"
	t += "<BR><BR>Current set coordinates:"
	t += "([x_co], [y_co], [z_co])"
	t += "<BR><BR><A href='?src=\ref[src];send=1'>Send</A>"
	t += " <A href='?src=\ref[src];receive=1'>Receive</A>"
	t += "<BR><BR><A href='?src=\ref[src];recal=1'>Recalibrate</A>"
	var/datum/browser/popup = new(user, "telesci", name, 640, 480)
	popup.set_content(t)
	popup.open()
	return
/obj/machinery/computer/telescience/proc/sparks()
	if(telepad)
		var/L = get_turf(E)
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(5, 1, L)
		s.start()
	else
		return
/obj/machinery/computer/telescience/proc/telefail()
	if(prob(50))
		sparks()
		for(var/mob/O in hearers(src, null))
			O.show_message("\red The telepad weakly fizzles.", 2)
		return
	if(prob(5))
		// Irradiate everyone in telescience!
		for(var/obj/machinery/telepad/E in machines)
			var/L = get_turf(E)
			sparks()
			for(var/mob/living/carbon/human/M in viewers(L, null))
				M.apply_effect((rand(10, 20)), IRRADIATE, 0)
				M << "\red You feel strange."
		return
	if(prob(1))
		// AI CALL SHUTTLE I SAW RUNE, SUPER LOW CHANCE, CAN HARDLY HAPPEN
		for(var/mob/living/carbon/O in viewers(src, null))
			var/datum/game_mode/cult/temp = new
			O.show_message("\red The telepad flashes with a strange light, and you have a sudden surge of allegiance toward the true dark one!", 2)
			O.mind.make_Cultist()
			temp.grant_runeword(O)
			sparks()
		return
	if(prob(1))
		// VIVA LA FUCKING REVOLUTION BITCHES, SUPER LOW CHANCE, CAN HARDLY HAPPEN
		for(var/mob/living/carbon/O in viewers(src, null))
			O.show_message("\red The telepad flashes with a strange light, and you see all kind of images flash through your mind, of murderous things Nanotrasen has done, and you decide to rebel!", 2)
			O.mind.make_Rev()
			sparks()
		return
	if(prob(1))
		// The OH SHIT FUCK GOD DAMN IT LYNCH THE SCIENTISTS event.
		for(var/mob/living/carbon/O in viewers(src, null))
			O.show_message("\red The telepad changes colors rapidly, and opens a portal, and you see what your mind seems to think is the very threads that hold the pattern of the universe together, and a eerie sense of paranoia creeps into you.", 2)
			spacevine_infestation()
			sparks()
		return
	if(prob(5))
		// HOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOONK
		for(var/mob/living/carbon/M in hearers(src, null))
			M << sound('sound/items/AirHorn.ogg')
			if(istype(M, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = M
				if(istype(H.l_ear, /obj/item/clothing/ears/earmuffs) || istype(H.r_ear, /obj/item/clothing/ears/earmuffs))
					continue
			M << "<font color='red' size='7'>HONK</font>"
			M.sleeping = 0
			M.stuttering += 20
			M.ear_deaf += 30
			M.Weaken(3)
			if(prob(30))
				M.Stun(10)
				M.Paralyse(4)
			else
				M.make_jittery(500)
			sparks()
		return
	if(prob(1))
		// They did the mash! (They did the monster mash!) The monster mash! (It was a graveyard smash!)
		sparks()
		for(var/obj/machinery/telepad/E in machines)
			var/L = get_turf(E)
			var/blocked = list(/mob/living/simple_animal/hostile,
				/mob/living/simple_animal/hostile/alien/queen/large,
				/mob/living/simple_animal/hostile/retaliate,
				/mob/living/simple_animal/hostile/retaliate/clown,
				/mob/living/simple_animal/hostile/giant_spider/nurse)
			var/list/hostiles = typesof(/mob/living/simple_animal/hostile) - blocked
			playsound(L, 'sound/effects/phasein.ogg', 100, 1)
			for(var/mob/living/carbon/human/M in viewers(L, null))
				flick("e_flash", M.flash)
			var/chosen = pick(hostiles)
			var/mob/living/simple_animal/hostile/H = new chosen
			H.loc = L
			return
		return
	return

/obj/machinery/computer/telescience/proc/doteleport(mob/user)
	var/trueX = (x_co + x_off)
	var/trueY = (y_co + y_off)
	trueX = Clamp(trueX, 1, world.maxx)
	trueY = Clamp(trueY, 1, world.maxy)
	if(telepad)
		var/turf/target = locate(trueX, trueY, z_co)
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(5, 1, telepad)
		s.start()
		flick("pad-beam", telepad)
		user << "<span class = 'caution'> Teleport successful.</span>"
		var/sparks = get_turf(target)
		var/datum/effect/effect/system/spark_spread/y = new /datum/effect/effect/system/spark_spread
		y.set_up(5, 1, sparks)
		y.start()
		var/turf/source = target
		var/turf/dest = get_turf(telepad)
		if(sending)
			source = dest
			dest = target
		for(var/atom/movable/ROI in source)
			if(ROI.anchored) continue
			do_teleport(ROI, dest, 0)
		return
	return

/obj/machinery/computer/telescience/proc/teleport(mob/user)
	if(x_co == null || y_co == null || z_co == null)
		user << "<span class = 'caution'>  Error: set coordinates.</span>"
		return
	if(x_co < 1 || x_co > 255)
		telefail()
		user << "<span class = 'caution'>  Error: X is less than 1 or greater than 255.</span>"
		return
	if(y_co < 1 || y_co > 255)
		telefail()
		user << "<span class = 'caution'>  Error: Y is less than 1 or greater than 255.</span>"
		return
	if(z_co == 2 || z_co < 1 || z_co > 7)
		telefail()
		user << "<span class = 'caution'>  Error: Z is less than 1, greater than 7, or equal to 2.</span>"
		return
	if(teles_left > 0)
		teles_left -= 1
		doteleport(user)
	else
		telefail()
		return
	return

/obj/machinery/computer/telescience/Topic(href, href_list)
	if(..())
		return
	if(href_list["setx"])
		var/new_x = input("Please input desired X coordinate.", name, x_co) as num
		x_co = Clamp(new_x, 1, 9999)
		return
	if(href_list["sety"])
		var/new_y = input("Please input desired Y coordinate.", name, y_co) as num
		y_co = Clamp(new_y, 1, 9999)
		return
	if(href_list["setz"])
		var/new_z = input("Please input desired Z coordinate.", name, z_co) as num
		z_co = Clamp(new_z, 1, 9999)
		return
	if(href_list["send"])
		sending = 1
		teleport(usr)
		return
	if(href_list["receive"])
		sending = 0
		teleport(usr)
		return
	if(href_list["recal"])
		teles_left = rand(9,12)
		x_off = rand(-10,10)
		y_off = rand(-10,10)
		sparks()
		usr << "<span class = 'caution'> Calibration successful.</span>"
		return