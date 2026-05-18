/datum/unit_test/cigarette_test
	name = "CIGARETTES: All Cigarettes Contain Enough Reagents For Transfer"

/datum/unit_test/cigarette_test/start_test()
	var/list/failed_cigs = list()
	var/fail_msg = "The following cigarettes have a sum of all fillings divided by smoketime less than 0.01, thus no reagents would transfer from the cigarette to the human:\n"

	for (var/cig_type in typesof(/obj/item/clothing/mask/smokable/cigarette) - /obj/item/clothing/mask/smokable/cigarette/rolled)
		var/sum_filling = 0
		var/obj/item/clothing/mask/smokable/cigarette/cig = new cig_type
		for (var/datum/reagent/reagent as anything in cig.filling)
			sum_filling += cig.filling[reagent]
		if (sum_filling / cig.smoketime < 0.01)
			failed_cigs += cig_type

	if (length(failed_cigs))
		for (var/cig in failed_cigs)
			fail_msg += ("[cig]\n")
		fail(fail_msg)
	else
		pass("All cigarettes are sane.")
	return 1
