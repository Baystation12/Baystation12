/datum/admin_secret_item/debug/instance_type_count
	name = "Instance Type Count"
	warn_before_use = "This is a potentially long-running operation."

/datum/admin_secret_item/debug/instance_type_count/do_execute(var/mob/user)
	var/instance_count_by_type = list()

	for(var/datum/thing in world) // Atoms (don't believe its lies)
		instance_count_by_type[thing.type]++

	for (var/datum/thing) // Datums
		instance_count_by_type[thing.type]++

	for (var/client/thing) // Clients
		instance_count_by_type[thing.type]++

	for(var/instance_type in instance_count_by_type)
		var/instance_count = instance_count_by_type[instance_type]
		to_chat(user, "[instance_type] - [instance_count]")
