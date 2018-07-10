/obj/item/weapon/computer_hardware/scanner/medical
	name = "medical scanner module"
	desc = "A medical scanner module. It can be used to scan patients and display medical information."

/obj/item/weapon/computer_hardware/scanner/medical/can_use_scanner(mob/user, mob/living/carbon/human/target, proximity = TRUE)
	if(!..())
		return 0
	if(CLUMSY in user.mutations)
		return 0
	if(!istype(target))
		return 0
	if(target.isSynthetic())
		to_chat(user, "<span class='warning'>\The [src] on \the [holder2] is designed for organic humanoid patients only.</span>")
		return 0
	return 1

/obj/item/weapon/computer_hardware/scanner/medical/do_on_afterattack(mob/user, mob/living/carbon/human/target, proximity)
	if(!can_use_scanner(user, target, proximity))
		return
	var/dat = medical_scan_results(target, 1)
	if(driver && driver.using_scanner)
		driver.data_buffer = html2pencode(dat)
		GLOB.nanomanager.update_uis(driver.NM)
	user.visible_message("<span class='notice'>\The [user] runs \the [src] on \the [holder2] over \the [target].</span>")
	to_chat(user, "<hr>[dat]<hr>")