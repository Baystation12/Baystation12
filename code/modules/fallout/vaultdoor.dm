var/obj/structure/vaultdoor/vdoor = null

/obj/structure/vaultdoor
	name = "vault door"
	icon = 'icons/fallout/vaultdoor.dmi'
	icon_state = "closed"
	density = 1
	anchored = 1
	opacity = 1
	var/open = 0

/obj/structure/vaultdoor/New()
	..()
	pixel_x = -32
	pixel_y = -32
	vdoor = src

/obj/structure/vaultdoor/proc/open()
	if(!open)
		playsound(loc, 'sound/fallout/doorgear_open.ogg', 50, 0, 10)
		sleep(110)
		icon_state = "opening"
		sleep(40)
		density = 0
		opacity = 0
		icon_state = "open"
		open = !open

/obj/structure/vaultdoor/proc/close()
	if(open)
		playsound(loc, 'sound/fallout/doorgear_close.ogg', 50, 0, 10)
		sleep(90)
		icon_state = "closing"
		sleep(60)
		icon_state = "closed"
		density = 1
		opacity = 1
		open = !open


/obj/machinery/vaultcontrol
	name = "vault door control"
	icon = 'icons/fallout/lever.dmi'
	icon_state = "lever"
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 300
	active_power_usage = 300

	var/dooropen = 0
	var/doormoving = 0

/obj/machinery/vaultcontrol/update_icon()
	if(stat & NOPOWER)
		icon_state = "lever-nopower"
	else if(!dooropen) //door open command is given
		if(doormoving)
			icon_state = "lever-opening"
		else
			icon_state = "lever-open"
	else
		if(doormoving)
			icon_state = "lever-closing"
		else
			icon_state = "lever"

/obj/machinery/vaultcontrol/proc/handleDoor()
	if(!dooropen) // door closed
		dooropen = 1
		doormoving = 1
		update_icon()
		vdoor.open()

	else
		dooropen = 0
		doormoving = 1
		update_icon()
		vdoor.close()

	sleep(150)
	doormoving = 0
	update_icon()

/obj/machinery/vaultcontrol/attack_hand(mob/user as mob)
	..()
	if(!doormoving && vdoor)
		handleDoor()
	else
		to_chat(usr, "<span class='warning'>The door is already changing state!</span>")