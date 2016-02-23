/obj/item/device/assembly/paper_scanner
	name = "paper scanner"
	desc = "A device for scanning paper."
	icon_state = "paper_scanner"
	item_state = "assembly"
	throwforce = 6
	w_class = 3
	throw_speed = 2
	throw_range = 10
	weight = 2
	var/obj/item/weapon/paper/stored
	var/insert = 1

	holder_attackby = list(/obj/item/weapon/paper)

	wires = WIRE_DIRECT_RECEIVE | WIRE_PROCESS_RECEIVE | WIRE_PROCESS_ACTIVATE | WIRE_PROCESS_SEND | WIRE_DIRECT_SEND | WIRE_MISC_CONNECTION
	wire_num = 7

/obj/item/device/assembly/paper_scanner/attackby(var/obj/O, var/mob/user)
	if(istype(O, /obj/item/weapon/paper))
		if(stored)
			user << "<span class='warning'>There's already a [stored] in \the [src]!</span>"
		else
			stored = O
			user.drop_item()
			O.forceMove(src)
			spawn(1)
				user << "<span class='notice'>You put \the [stored] into \the [src]!</span>"
				if(insert)
					process_activation()
	..()

/obj/item/device/assembly/paper_scanner/get_data()
	var/list/data = list()
	data.Add("Send on Insert", (insert ? "TRUE" : "FALSE"))
	return data

/obj/item/device/assembly/paper_scanner/activate()
	if(stored)
		send_data(list(stored.info))
		return 1
	return 0

/obj/item/device/assembly/paper_scanner/Topic(href, href_list)
	if(href_list["option"])
		switch(href_list["option"])
			if("Send on Insert")
				insert = !insert
	..()



