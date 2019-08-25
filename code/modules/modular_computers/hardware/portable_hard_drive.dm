// These are basically USB data sticks and may be used to transfer files between devices
/obj/item/weapon/computer_hardware/hard_drive/portable
	name = "basic data crystal"
	desc = "Small crystal with imprinted photonic circuits that can be used to store data. Its capacity is 16 GQ."
	w_class = ITEM_SIZE_SMALL
	icon_state = "flashdrive_basic"
	hardware_size = 1
	power_usage = 30
	max_capacity = 64
	default_files = list()
	origin_tech = list(TECH_DATA = 2)
	matter = list(MATERIAL_STEEL = 1, MATERIAL_PLASTIC = 2, MATERIAL_GOLD = 0.25)
	matter_reagents = list()
	w_class = ITEM_SIZE_SMALL
	var/disk_name
	var/license = 0

/obj/item/weapon/computer_hardware/hard_drive/portable/advanced
	name = "advanced data crystal"
	desc = "Small crystal with imprinted high-density photonic circuits that can be used to store data. Its capacity is 64 GQ."
	power_usage = 20
	icon_state = "flashdrive_advanced"
	hardware_size = 1
	max_capacity = 64
	origin_tech = list(TECH_DATA = 2)

/obj/item/weapon/computer_hardware/hard_drive/portable/super
	name = "super data crystal"
	desc = "Small crystal with imprinted ultra-density photonic circuits that can be used to store data. Its capacity is 256 GQ."
	power_usage = 40
	icon_state = "flashdrive_super"
	hardware_size = 1
	max_capacity = 256
	origin_tech = list(TECH_DATA = 4)

/obj/item/weapon/computer_hardware/hard_drive/portable/Initialize()
	. = ..()
	if(disk_name)
		SetName("[initial(name)] - '[disk_name]'")

/obj/item/weapon/computer_hardware/hard_drive/portable/Destroy()
	if(holder2 && (holder2.portable_drive == src))
		holder2.portable_drive = null
	return ..()

/obj/item/weapon/computer_hardware/hard_drive/portable/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/pen))
		var/new_name = input(user, "What would you like to label the disk?", "Tape labeling") as null|text
		if(isnull(new_name)) return
		new_name = sanitizeSafe(new_name)
		if(new_name)
			SetName("[initial(name)] - '[new_name]'")
			to_chat(user, SPAN_NOTICE("You label the disk '[new_name]'."))
		else
			SetName("[initial(name)]")
			to_chat(user, SPAN_NOTICE("You wipe off the label."))
		return

	..()

/obj/item/weapon/computer_hardware/hard_drive/portable/install_default_files()
	if(disk_name)
		var/datum/computer_file/data/text/D = new
		D.filename = "DISK_NAME"
		D.stored_data = disk_name

		store_file(D)
	..()

/obj/item/weapon/computer_hardware/hard_drive/portable/ui_data()
	var/list/data = ..()
	data["license"] = license
	return data


//Bay disk objects

/*
// These are basically USB data sticks and may be used to transfer files between devices


/obj/item/weapon/computer_hardware/hard_drive/portable/New()
	..()
	stored_files = list()
	recalculate_size()

/obj/item/weapon/computer_hardware/hard_drive/portable/Destroy()
	if(holder2 && (holder2.portable_drive == src))
		holder2.portable_drive = null
	return ..()
	*/