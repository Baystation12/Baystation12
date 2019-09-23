/obj/item/weapon/stock_parts/computer/scanner/reagent
	name = "reagent scanner module"
	desc = "A reagent scanner module. It can scan and analyze various reagents."

/obj/item/weapon/stock_parts/computer/scanner/reagent/can_use_scanner(mob/user, obj/target, proximity = TRUE)
	if(!..(user, target, proximity))
		return 0
	if(!istype(target))
		return 0
	return 1

/obj/item/weapon/stock_parts/computer/scanner/reagent/do_on_afterattack(mob/user, obj/target, proximity)
	if(!can_use_scanner(user, target, proximity))
		return
	var/dat = reagent_scan_results(target)
	if(driver && driver.using_scanner)
		driver.data_buffer = jointext(dat, "\[br\]")
		SSnano.update_uis(driver.NM)
	to_chat(user, "<span class = 'notice'>[jointext(dat, "<br>")]</span>")