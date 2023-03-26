/obj/machinery/media/music_writer
	name = "music disks rewriter"
	desc = "A machine which rewrites musical disks."
	icon = 'packs/infinity/icons/obj/machinery/disk_writer.dmi'
	icon_state = "writer_off"
	density = FALSE
	power_channel = EQUIP
	use_power = 1
	idle_power_usage = 10
	active_power_usage = 100
	anchored = TRUE

	var/mob/customer //current user
	var/cooldown = 0 // Every 3 minute after successful re-write.

	var/writing = FALSE

	var/obj/item/music_tape/disk

/obj/machinery/media/music_writer/Process()
	if(writing)
		if(!check_victim())
			set_off()
	if(cooldown)
		cooldown -= 1 SECOND

/obj/machinery/media/music_writer/on_update_icon()
	if(writing)
		icon_state = "writer_on"
	else
		icon_state = "writer_off"

/obj/machinery/media/music_writer/proc/check_victim()
	if(locate(customer, src.loc))
		return 1
	return 0

/obj/machinery/media/music_writer/proc/set_off()
	if(customer)
		customer = null
	writing = FALSE
	update_icon()

/obj/machinery/media/music_writer/proc/set_on(mob/M)
	if(M)
		customer = M
		writing = TRUE
		update_icon()

/obj/machinery/media/music_writer/use_tool(obj/item/tool, mob/user, list/click_params)
	if(istype(tool, /obj/item/music_tape))
		var/obj/item/music_tape/D = tool
		if(disk)
			to_chat(user, SPAN_NOTICE("There is already a disk inside."))
			return TRUE

		if(D.ruined)
			to_chat(user, SPAN_NOTICE("\The [D] is ruined, you can't use it."))
			return TRUE

		visible_message(SPAN_NOTICE("[user] inserts the disk in \the [src]'s card slot."))
		user.drop_item()
		D.forceMove(src)
		disk = D
		return TRUE
	return ..()

/obj/machinery/media/music_writer/physical_attack_hand(mob/user)
	if(locate(user, src.loc))
		interact(user)

/obj/machinery/media/music_writer/interact(mob/user)
	var/dat = "Please insert a cassette.<br>"

	if(writing)
		dat = "Memory scan completed. <br>Writing the tune from scan of [customer.name] mind... Please, stand still."

	if(disk && !writing)
		dat = "<A href='?src=\ref[src];write=1'>Write ([disk.rewrites_left] times left)</A>"

	if(disk && !writing)
		dat += "<br><a href='?src=\ref[src];eject=1'>Eject Disk</a>"

	if(cooldown)
		dat = "[src] is recalibrating its systems for a new rewrite. Please, wait [cooldown/10] seconds."

	playsound(src, 'packs/infinity/sound/machines/console/console2.ogg', 40, 1)

	var/datum/browser/popup = new(user, "musicwriter", "Music Writer", 200, 100)
	popup.set_content(dat)
	popup.open()

/obj/machinery/media/music_writer/attack_ai(mob/user)
	return

/obj/machinery/media/music_writer/OnTopic(mob/user, list/href_list)
	if(href_list["write"])
		if(!writing && !customer && disk && cooldown == 0)
			if(disk.rewrites_left > 0)
				if(write_disk(usr))
					message_admins("[customer.real_name]([customer.ckey]) uploaded new sound <A HREF='?_src_=holder;listensound=\ref[disk.track.source]'>(preview)</A> in <a href='?_src_=holder;adminplayerobservefollow=\ref[src]'>the cassette</a> named as \"[disk.track.title]\". <A HREF='?_src_=holder;wipedata=\ref[disk]'>Wipe</A> data.")
					cooldown += 3 MINUTES
					sleep(4 SECONDS)

					playsound(src, 'packs/infinity/sound/machines/console/console_success.ogg', 40, 1)
					sleep(2 SECONDS)

					eject(usr)
					set_off()
			else
				playsound(src, 'packs/infinity/sound/machines/console/console_error.ogg', 40, 1)
				to_chat(usr, SPAN_DANGER("You can't rewrite this disk - the tape was rewriten too many times."))

	if(href_list["eject"])
		if(usr.incapacitated())
			return

		if(!disk)
			to_chat(usr, SPAN_NOTICE("There's no disk in \the [src]"))
			return

		if(writing)
			to_chat(usr, SPAN_DANGER("You can't eject the disk while \the [src] is working."))
			return

		visible_message(SPAN_NOTICE("[usr] eject the disk from \the [src]."))
		eject(usr)

	return TOPIC_REFRESH

/obj/machinery/media/music_writer/proc/write_disk(mob/user)
	set_on(user)

	playsound(src, pick(GLOB.console_interact_sound), 40, 1)

	var/new_sound_file = input(user, "Pick file:","File") as null|sound
	if(!new_sound_file)
		playsound(src, 'packs/infinity/sound/machines/console/console_error.ogg', 40, 1)
		set_off()
		return

	playsound(src, pick(GLOB.console_interact_sound), 40, 1)

	var/new_name = input(user, "Name the cassette:") as null|text
	if(!new_name)
		playsound(src, 'packs/infinity/sound/machines/console/console_error.ogg', 40, 1)
		set_off()
		return

	playsound(src, pick(GLOB.console_interact_sound), 40, 1)

	new_name = sanitizeSafe(new_name)

	if(new_sound_file && new_name && writing)
		playsound(src, 'packs/infinity/sound/machines/console/console.ogg', 40)

		disk.SetName("cassette - \"[new_name]\"")

		if(disk.track) //Removing old datum disk if there one
			qdel(disk.track)

		var/jukebox_track/T = new(new_name, new_sound_file)

		if(T)
			disk.track = T
			disk.uploader_ckey = customer.ckey
			disk.rewrites_left--
			return 1
	return 0

/obj/machinery/media/music_writer/proc/eject(mob/user)
	playsound(src, 'packs/infinity/sound/machines/console/console3.ogg', 40, 1)
	user.put_in_hands(disk)
	disk = null
