/datum/persistent/paper/sticky
	name = "stickynotes"
	paper_type = /obj/item/paper/sticky
	requires_noticeboard = FALSE

/datum/persistent/paper/sticky/CreateEntryInstance(var/turf/creating, var/list/tokens)
	var/atom/paper = ..()
	if(paper)
		paper.pixel_x = tokens["offset_x"]
		paper.pixel_y = tokens["offset_y"]
		paper.color =   tokens["color"]
	return paper

/datum/persistent/paper/sticky/CompileEntry(var/atom/entry, var/write_file)
	. = ..()
	var/obj/item/paper/sticky/paper = entry
	.["offset_x"] = paper.pixel_x
	.["offset_y"] = paper.pixel_y
	.["color"] = paper.color
