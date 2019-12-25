/datum/unit_test/fusion_network_test
	name = "FUSION: All Devices With Initial IDs Shall Have A Valid Network"

/datum/unit_test/fusion_network_test/start_test()

	var/list/check_machines
	for(var/thing in SSmachines.machinery)
		if(hasvar(thing, "initial_id_tag") && !isnull(thing:initial_id_tag) && has_extension(thing, /datum/extension/local_network_member))
			LAZYADD(check_machines, get_extension(thing, /datum/extension/local_network_member))

	if(LAZYLEN(check_machines))
		var/list/failed_ids
		for(var/thing in check_machines)
			var/datum/extension/local_network_member/lanm = thing
			var/datum/local_network/lan = lanm.get_local_network()
			if(!lan || !lan.network_entities[lanm.holder.type] || !lan.network_entities[lanm.holder.type][lanm.holder])
				var/obj/device = lanm.holder
				LAZYADD(failed_ids, "[device.type] ([device.x],[device.y],[device.z]) - [device:initial_id_tag]")

		if(LAZYLEN(failed_ids))
			fail("Some fusion devices had IDs but no valid network:\n[jointext(failed_ids, "\n")]")
		else
			pass("All fusion devices with IDs have a valid network.")
	else
		pass("No fusion devices with IDs on this map.")

	return 1