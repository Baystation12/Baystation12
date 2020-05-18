/datum/persistent/paper
	name = "paper"
	entries_expire_at = 50
	has_admin_data = TRUE
	var/paper_type = /obj/item/weapon/paper
	var/requires_noticeboard = TRUE

/datum/persistent/paper/CheckTurfContents(var/turf/T, var/list/tokens)
	if(requires_noticeboard && !(locate(/obj/structure/noticeboard) in T))
		new /obj/structure/noticeboard(T)
	. = ..()

/datum/persistent/paper/CreateEntryInstance(var/turf/creating, var/list/tokens)
	var/obj/structure/noticeboard/board = locate() in creating
	if(requires_noticeboard && LAZYLEN(board.notices) >= board.max_notices)
		return
	var/obj/item/weapon/paper/paper = new paper_type(creating)
	paper.set_content(tokens["message"], tokens["title"])
	paper.last_modified_ckey = tokens["author"]
	if(requires_noticeboard)
		board.add_paper(paper)
	SSpersistence.track_value(paper, type)
	return paper

/datum/persistent/paper/GetEntryAge(var/atom/entry)
	var/obj/item/weapon/paper/paper = entry
	return paper.age

/datum/persistent/paper/CompileEntry(var/atom/entry, var/write_file)
	. = ..()
	var/obj/item/weapon/paper/paper = entry
	.["author"] =  paper.last_modified_ckey || "unknown"
	.["message"] = paper.info || ""
	.["title"] =   paper.name || "paper"

/datum/persistent/paper/GetAdminDataStringFor(var/thing, var/can_modify, var/mob/user)
	var/obj/item/weapon/paper/paper = thing
	if(can_modify)
		. = "<td style='background-color:[paper.color]'>[paper.info]</td><td>[paper.name]</td><td>[paper.last_modified_ckey]</td><td><a href='byond://?src=\ref[src];caller=\ref[user];remove_entry=\ref[thing]'>Destroy</a></td>"
	else
		. = "<td colspan = 2;style='background-color:[paper.color]'>[paper.info]</td><td>[paper.name]</td><td>[paper.last_modified_ckey]</td>"

/datum/persistent/paper/RemoveValue(var/atom/value)
	var/obj/structure/noticeboard/board = value.loc
	if(istype(board))
		board.remove_paper(value)
	qdel(value)
