/obj/item/stock_parts/computer/scanner/atmos
	name = "atmospheric scanner module"
	desc = "An atmospheric scanner module. It can scan the surroundings and report the composition of gases."
	can_run_scan = 1

/obj/item/stock_parts/computer/scanner/atmos/can_use_scanner(mob/user, atom/target, proximity = TRUE)
	if(!..())
		return 0
	if(!target.simulated)
		return 0
	return 1

/obj/item/stock_parts/computer/scanner/atmos/run_scan(mob/user, datum/computer_file/program/scanner/program)
	program.data_buffer = html2pencode(scan_data(user, user.loc)) || program.data_buffer

/obj/item/stock_parts/computer/scanner/atmos/do_on_afterattack(mob/user, atom/target, proximity)
	if (!can_use_scanner(user, target, proximity))
		return
	user.visible_message(
		SPAN_NOTICE("\The [user] runs \the [src] over \the [target]."),
		SPAN_NOTICE("You run \the [src] over \the [target]."),
		range = 2
	)
	var/data = scan_data(user, target, proximity)
	if (!data)
		return
	if (driver?.using_scanner)
		driver.data_buffer = html2pencode(data)
		SSnano.update_uis(driver.NM)

/obj/item/stock_parts/computer/scanner/atmos/proc/scan_data(mob/user, atom/target, proximity = TRUE)
	if(!can_use_scanner(user, target, proximity))
		return 0
	var/air_contents = target.return_air()
	if(!air_contents)
		return 0
	return atmosanalyzer_scan(target, air_contents)

/obj/item/stock_parts/computer/scanner/atmos/can_use_scanner(mob/user, atom/target, proximity)
	if (!isobj(target) && !isturf(target))
		return FALSE
	return ..()
