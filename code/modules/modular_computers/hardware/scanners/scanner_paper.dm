/obj/item/weapon/computer_hardware/scanner/paper
	name = "paper scanner module"
	desc = "A paper scanning module. It can scan writing and save it to a file."

/obj/item/weapon/computer_hardware/scanner/paper/can_use_scanner(mob/user, obj/item/weapon/paper/target, proximity = TRUE)
	if(!..())
		return 0
	if(!istype(target))
		return 0
	return 1

/obj/item/weapon/computer_hardware/scanner/paper/do_on_afterattack(mob/user, obj/item/weapon/paper/target, proximity)
	if(!driver || !driver.using_scanner)
		return
	if(!can_use_scanner(user, target, proximity))
		return
	var/data = html2pencode(target.info)
	if(!data)
		return
	driver.data_buffer = data
	GLOB.nanomanager.update_uis(driver.NM)

/obj/item/weapon/computer_hardware/scanner/paper/do_on_attackby(mob/user, atom/target)
	do_on_afterattack(user, target, TRUE)