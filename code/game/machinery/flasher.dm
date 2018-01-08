// It is a gizmo that flashes a small area

/obj/machinery/flasher
	name = "Mounted flash"
	desc = "A wall-mounted flashbulb device."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "mflash1"
	var/id = null
	var/range = 2 //this is roughly the size of brig cell
	var/disable = 0
	var/last_flash = 0 //Don't want it getting spammed like regular flashes
	var/strength = 10 //How weakened targets are when flashed.
	var/base_state = "mflash"
	anchored = 1
	use_power = 1
	idle_power_usage = 2
	flags = PROXMOVE
	var/_wifi_id
	var/datum/wifi/receiver/button/flasher/wifi_receiver

/obj/machinery/flasher/portable //Portable version of the flasher. Only flashes when anchored
	name = "portable flasher"
	desc = "A portable flashing device. Wrench to activate and deactivate. Cannot detect slow movements."
	icon_state = "pflash1"
	strength = 8
	anchored = 0
	base_state = "pflash"
	density = 1

/obj/machinery/flasher/Initialize()
	. = ..()
	if(_wifi_id)
		wifi_receiver = new(_wifi_id, src)

/obj/machinery/flasher/Destroy()
	qdel(wifi_receiver)
	wifi_receiver = null
	return ..()

/obj/machinery/flasher/update_icon()
	if ( !(stat & (BROKEN|NOPOWER)) )
		icon_state = "[base_state]1"
//		src.sd_SetLuminosity(2)
	else
		icon_state = "[base_state]1-p"
//		src.sd_SetLuminosity(0)

//Don't want to render prison breaks impossible
/obj/machinery/flasher/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(isWirecutter(W))
		add_fingerprint(user, 0, W)
		src.disable = !src.disable
		if (src.disable)
			user.visible_message("<span class='warning'>[user] has disconnected the [src]'s flashbulb!</span>", "<span class='warning'>You disconnect the [src]'s flashbulb!</span>")
		if (!src.disable)
			user.visible_message("<span class='warning'>[user] has connected the [src]'s flashbulb!</span>", "<span class='warning'>You connect the [src]'s flashbulb!</span>")
	else
		..()

//Let the AI trigger them directly.
/obj/machinery/flasher/attack_ai()
	if (src.anchored)
		return src.flash()
	else
		return

/obj/machinery/flasher/proc/flash()
	if (!(powered()))
		return

	if ((src.disable) || (src.last_flash && world.time < src.last_flash + 150))
		return

	playsound(src.loc, 'sound/weapons/flash.ogg', 100, 1)
	flick("[base_state]_flash", src)
	src.last_flash = world.time
	use_power(1500)

	for (var/mob/living/O in viewers(src, null))
		if (get_dist(src, O) > src.range)
			continue

		var/flash_time = strength
		if (istype(O, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = O
			if(!H.eyecheck() <= 0)
				continue
			flash_time = round(H.species.flash_mod * flash_time)
			var/obj/item/organ/internal/eyes/E = H.internal_organs_by_name[BP_EYES]
			if(!E)
				return
			if(E.is_bruised() && prob(E.damage + 50))
				H.flash_eyes()
				E.damage += rand(1, 5)
		if(!O.blinded)
			O.flash_eyes()
			O.eye_blurry += flash_time
			O.confused += (flash_time + 2)
			O.Stun(flash_time / 2)
			O.Weaken(3)

/obj/machinery/flasher/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return
	if(prob(75/severity))
		flash()
	..(severity)

/obj/machinery/flasher/portable/HasProximity(atom/movable/AM as mob|obj)
	if ((src.disable) || (src.last_flash && world.time < src.last_flash + 150))
		return

	if(istype(AM, /mob/living/carbon))
		var/mob/living/carbon/M = AM
		if ((M.m_intent != "walk") && (src.anchored))
			src.flash()

/obj/machinery/flasher/portable/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(isWrench(W))
		add_fingerprint(user)
		src.anchored = !src.anchored

		if (!src.anchored)
			user.show_message(text("<span class='warning'>[src] can now be moved.</span>"))
			src.overlays.Cut()

		else if (src.anchored)
			user.show_message(text("<span class='warning'>[src] is now secured.</span>"))
			src.overlays += "[base_state]-s"

/obj/machinery/button/flasher
	name = "flasher button"
	desc = "A remote control switch for a mounted flasher."

/obj/machinery/button/flasher/attack_hand(mob/user as mob)

	if(..())
		return

	use_power(5)

	active = 1
	icon_state = "launcheract"

	for(var/obj/machinery/flasher/M in SSmachines.machinery)
		if(M.id == src.id)
			spawn()
				M.flash()

	sleep(50)

	icon_state = "launcherbtt"
	active = 0

	return
