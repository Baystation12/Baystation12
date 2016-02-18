/obj/item/device/assembly/card_reader
	name = "card reader"
	desc = "Stores an identification card and sends information contained on it."
	icon_state = "card_reader"
	item_state = "assembly"
	throwforce = 5
	w_class = 2
	throw_speed = 4
	throw_range = 10
	flags = CONDUCT
	holder_attackby = list(/obj/item/weapon/card/id)

	wires = WIRE_DIRECT_RECEIVE | WIRE_PROCESS_RECEIVE | WIRE_PROCESS_ACTIVATE | WIRE_MISC_ACTIVATE | WIRE_DIRECT_SEND | WIRE_PROCESS_SEND | WIRE_MISC_CONNECTION
	wire_num = 7

	var/list/data_types = list("Name", "Occupation", "Access", "Billing")
	var/data_type = "Name"
	var/list/activations = list("Scan ID", "Eject ID")
	var/activation = "Scan ID"
	var/activate_on_insert = "TRUE"

	var/obj/item/weapon/card/id/inserted

	get_data()
		var/list/data = list()
		data.Add("Sent Data", data_type, "Activation Action", activation, "Scan On Insert", activate_on_insert)
		return data

	get_buttons()
		if(inserted)
			return list("Eject ID")

	attackby(var/obj/O, var/mob/user)
		if(istype(O, /obj/item/weapon/card/id))
			user.drop_item()
			inserted = O
			inserted.loc = src
			if(activate_on_insert == "TRUE")
				misc_activate()

	Topic(href, href_list)
		if(href_list["option"])
			switch(href_list["option"])
				if("Sent Data")
					var/index = data_types.Find(data_type)
					if(!index || index == data_types.len) data_type = data_types[1]
					else data_type = data_types[(index+1)]
				if("Activation Action")
					var/index = activations.Find(activation)
					if(!index || index == activations.len) activation = activations[1]
					else activation = activations[(index+1)]
				if("Scan On Insert")
					if(activate_on_insert == "TRUE") activate_on_insert = "FALSE"
					else activate_on_insert = "TRUE"
				if("Eject ID")
					eject_id()
		..()



	misc_activate()
		if(inserted)
			switch(data_type)
				if("Name")
					send_data(list(inserted.registered_name))
				if("Occupation")
					send_data(list(inserted.assignment))
				if("Access")
					send_data(inserted.access)
				if("Billing")
					send_data(list(inserted.associated_account_number))

	activate()
		switch(activation)
			if("Scan ID")
				misc_activate()
			if("Eject ID")
				eject_id()

	proc/eject_id()
		if(usr)
			usr.put_in_hands(inserted)
		else
			inserted.loc = get_turf(src)
			inserted = null
