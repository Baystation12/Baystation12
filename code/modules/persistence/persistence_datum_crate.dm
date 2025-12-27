/datum/persistent/crate
	name = "ore_crate"
	has_admin_data = TRUE
	entries_expire_at = 999999 //We'll manage our own decay of ore quantity

/datum/persistent/crate/CompileEntry(atom/entry, write_file)
	. = ..()
	var/obj/structure/ore_box/box = entry
	var/list/ores = list()
	for(var/obj/item/ore/C in box.contents)
		var/name = C.material.name
		if(name)
			if(ores[name])
				ores[name]++
			else
				ores[name] = 1
	.["ores"] = ores

/datum/persistent/crate/CreateEntryInstance(turf/creating, list/tokens)
	var/list/ore_count = tokens["ores"]
	if(!length(ore_count))
		return

	var/obj/structure/ore_box/persistent/B
	for(var/thing in creating.contents)
		B = thing
		if(istype(B))
			break

	if(!istype(B))
		B = new /obj/structure/ore_box/persistent(creating)

	B.deferred_init = ore_count
