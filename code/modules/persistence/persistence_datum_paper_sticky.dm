/datum/persistent/paper/sticky
	name = "stickynotes"
	paper_type = /obj/item/weapon/paper/sticky
	requires_noticeboard = FALSE
	tokens_per_line = 10

/datum/persistent/paper/sticky/LabelTokens(var/list/tokens)
	var/list/labelled_tokens = ..()
	var/entries = LAZYLEN(labelled_tokens)
	labelled_tokens["offset_x"] = tokens[entries+1]
	labelled_tokens["offset_y"] = tokens[entries+2]
	labelled_tokens["color"] =    tokens[entries+3]
	return labelled_tokens

/datum/persistent/paper/sticky/CreateEntryInstance(var/turf/creating, var/list/tokens)
	var/atom/paper = ..()
	if(paper)
		paper.pixel_x = text2num(tokens["offset_x"])
		paper.pixel_y = text2num(tokens["offset_y"])
		paper.color =   tokens["color"]
	return paper

/datum/persistent/paper/sticky/CompileEntry(var/atom/entry, var/write_file)
	. = ..()
	var/obj/item/weapon/paper/sticky/paper = entry
	LAZYADD(., "[paper.pixel_x]")
	LAZYADD(., "[paper.pixel_y]")
	LAZYADD(., "[paper.color]")
