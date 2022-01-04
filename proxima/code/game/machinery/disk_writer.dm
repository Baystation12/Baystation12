//from infinity
/obj/machinery/media/music_writer
	name = "music disks rewriter"
	desc = "A machine which rewrites musical disks."
	icon = 'proxima/icons/obj/machinery/disk_writer.dmi'
	icon_state = "writer_off"
	density = FALSE
	power_channel = EQUIP
	use_power = 1
	idle_power_usage = 10
	active_power_usage = 100

	var/mob/customer //current user
	var/cooldown = 0 // Every 20 seconds after successful re-write.

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

/obj/machinery/media/music_writer/proc/set_on(var/mob/M)
	if(M)
		customer = M
		writing = TRUE
		update_icon()

/obj/machinery/media/music_writer/attackby(obj/O, mob/user)
	if(istype(O, /obj/item/music_tape))
		var/obj/item/music_tape/D = O
		if(disk)
			to_chat(user, SPAN_NOTICE("There is already a disk inside."))
			return

		if(D.ruined)
			to_chat(user, SPAN_NOTICE("\The [D] is ruined, you can't use it."))
			return

		visible_message(SPAN_NOTICE("[user] inserts the disk in \the [src]'s card slot."))
		user.drop_item()
		D.forceMove(src)
		disk = D

/obj/machinery/media/music_writer/physical_attack_hand(mob/user)
	if(locate(user, src.loc))
		interact(user)

/obj/machinery/media/music_writer/interact(mob/user)
	var/dat = "Please insert a cassette.<br>"

	if(writing)
		dat = "Memory scan completed. <br>Writing the tune from scan of [customer.name] mind... Please, stand still."

	if(disk && !writing)
		dat = "<A href='?src=\ref[src];write=1'>Write</A>"

	if(disk && !writing)
		dat += "<br><a href='?src=\ref[src];eject=1'>Eject Disk</a>"

	if(cooldown)
		dat = "[src] is recalibrating its systems for a new rewrite. Please, wait [cooldown] seconds."

	playsound(src, 'proxima/sound/machines/console/console2.ogg', 40, 1)

	var/datum/browser/popup = new(user, "musicwriter", "Music Writer", 200, 135)
	popup.set_content(dat)
	popup.open()

/obj/machinery/media/music_writer/attack_ai(mob/user)
	return

/obj/machinery/media/music_writer/OnTopic(var/user, var/list/href_list)
	if(href_list["write"])
		if(!writing && !customer && disk && cooldown == 0)
			if(write_disk(usr))
				message_admins("[customer.real_name]([customer.ckey]) uploaded new sound in <a href='?_src_=holder;adminplayerobservefollow=\ref[src]'>the cassette</a> named as \"[disk.track.title]\".")
				cooldown += 2 SECONDS
				sleep(4 SECONDS)

				playsound(src, 'proxima/sound/machines/console/console_success.ogg', 40, 1)
				sleep(2 SECONDS)

				eject(usr)
				set_off()

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
		playsound(src, 'proxima/sound/machines/console/console_error.ogg', 40, 1)
		set_off()
		return

	playsound(src, pick(GLOB.console_interact_sound), 40, 1)

	var/new_name = input(user, "Name the cassette:") as null|text
	if(!new_name)
		playsound(src, 'proxima/sound/machines/console/console_error.ogg', 40, 1)
		set_off()
		return

	playsound(src, pick(GLOB.console_interact_sound), 40, 1)

	new_name = sanitizeSafe(new_name)

	if(new_sound_file && new_name && writing)
		playsound(src, 'proxima/sound/machines/console/console.ogg', 40)

		disk.SetName("cassette - \"[new_name]\"")

		if(disk.track) //Removing old datum disk if there one
			qdel(disk.track)

		var/jukebox_track/T = new(new_name, new_sound_file)

		if(T)
			disk.track = T
			disk.uploader_ckey = customer.ckey
			return 1
	return 0

/obj/machinery/media/music_writer/proc/eject(mob/user)
	playsound(src, 'proxima/sound/machines/console/console3.ogg', 40, 1)
	user.put_in_hands(disk)
	disk = null
