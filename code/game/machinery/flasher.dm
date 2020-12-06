// It is a gizmo that flashes a small area

/obj/machinery/flasher
	name = "mounted flash"
	desc = "A wall-mounted flashbulb device."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "mflash1"
	var/range = 2 //this is roughly the size of brig cell
	var/disable = 0
	var/last_flash = 0 //Don't want it getting spammed like regular flashes
	var/strength = 10 //How weakened targets are when flashed.
	var/base_state = "mflash"
	anchored = 1
	idle_power_usage = 2
	movable_flags = MOVABLE_FLAG_PROXMOVE

	uncreated_component_parts = list(
		/obj/item/weapon/stock_parts/radio/receiver,
		/obj/item/weapon/stock_parts/power/apc
	)
	public_methods = list(
		/decl/public_access/public_method/flasher_flash
	)
	stock_part_presets = list(/decl/stock_part_preset/radio/receiver/flasher = 1)


/obj/machinery/flasher/on_update_icon()
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
	use_power_oneoff(1500)

	for (var/mob/living/O in viewers(src, null))
		if (get_dist(src, O) > src.range)
			continue

		var/flash_time = strength
		if(isliving(O))
			if(O.eyecheck() > FLASH_PROTECTION_NONE)
				continue
			if(ishuman(O))
				var/mob/living/carbon/human/H = O
				flash_time = round(H.getFlashMod() * flash_time)
				if(flash_time <= 0)
					return
				var/obj/item/organ/internal/eyes/E = H.internal_organs_by_name[H.species.vision_organ]
				if(!E)
					return
				if(E.is_bruised() && prob(E.damage + 50))
					H.flash_eyes()
					E.damage += rand(1, 5)

		if(!O.blinded)
			do_flash(O, flash_time)

/obj/machinery/flasher/proc/do_flash(var/mob/living/victim, var/flash_time)
	victim.flash_eyes()
	victim.eye_blurry += flash_time
	victim.confused += (flash_time + 2)
	victim.Stun(flash_time / 2)
	victim.Weaken(3)

/obj/machinery/flasher/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return
	if(prob(75/severity))
		flash()
	..(severity)

/obj/machinery/flasher/portable //Portable version of the flasher. Only flashes when anchored
	name = "portable flasher"
	desc = "A portable flashing device. Wrench to activate and deactivate. Cannot detect slow movements."
	icon_state = "pflash1"
	strength = 8
	anchored = 0
	base_state = "pflash"
	density = 1

/obj/machinery/flasher/portable/HasProximity(atom/movable/AM as mob|obj)
	if(!anchored || disable || last_flash && world.time < last_flash + 150)
		return

	if(istype(AM, /mob/living/carbon))
		var/mob/living/carbon/M = AM
		if(!MOVING_DELIBERATELY(M))
			flash()
	
	if(isanimal(AM))
		flash()

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
	cooldown = 5 SECONDS

/decl/public_access/public_method/flasher_flash
	name = "flash"
	desc = "Performs a flash, if possible."
	call_proc = /obj/machinery/flasher/proc/flash

/decl/stock_part_preset/radio/receiver/flasher
	frequency = BUTTON_FREQ
	receive_and_call = list("button_active" = /decl/public_access/public_method/flasher_flash)