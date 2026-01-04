/datum/persistent/crate
	name = "ore_crate"
	has_admin_data = TRUE
	entries_expire_at = 999999 //We'll manage our own decay of ore quantity

/datum/persistent/crate/CompileEntry(atom/entry, write_file)
	. = ..()
	var/obj/structure/ore_box/persistent/box = entry
	if(!istype(box))
		return
	var/list/ores = list()
	for (var/obj/item/ore/ore_piece in box.contents)
		var/name = ore_piece.material.name
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

	var/obj/structure/ore_box/persistent/B = locate() in range(1, creating)

	if(!istype(B))
		B = new /obj/structure/ore_box/persistent(creating)

	B.deferred_init = ore_count
