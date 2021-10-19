/obj/item/stock_parts/computer/scanner/robotic
	name = "robotic scanner module"
	desc = "A robotic scanner module. It is used to analyse the integrity of synthetic components."

/obj/item/stock_parts/computer/scanner/robotic/do_on_afterattack(mob/user, atom/target, proximity)
	if(!can_use_scanner(user, target, proximity))
		return

	var/damaged = target.get_damaged_components(1,1,1)

	if(damaged && driver && driver.using_scanner)
		driver.data_buffer = html2pencode(damaged)
		SSnano.update_uis(driver.NM)