/obj/item/weapon/computer_hardware/scanner/medical
	name = "medical scanner module"
	desc = "A medical scanner module. It can be used to scan patients and display medical information."

/obj/item/weapon/computer_hardware/scanner/medical/can_use_scanner(mob/user, atom/target, proximity = TRUE)
	if(!..())
		return 0
	if(CLUMSY in user.mutations)
		return 0
	if(!istype(target))
		return 0
	return 1

/obj/item/weapon/computer_hardware/scanner/medical/do_on_afterattack(mob/user, atom/target as mob|obj, proximity)
	if(!can_use_scanner(user, target, proximity))
		return

	var/dat = medical_scan_action(target, user, holder2, 1)

	if(dat && driver && driver.using_scanner)
		driver.data_buffer = html2pencode(dat)
		GLOB.nanomanager.update_uis(driver.NM)
