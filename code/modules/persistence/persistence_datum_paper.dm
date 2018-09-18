/datum/persistent/paper
	name = "paper"
	tokens_per_line = 7
	entries_expire_at = 50
	admin_dat_header_colspan = 4
	var/paper_type = /obj/item/weapon/paper
	var/requires_noticeboard = TRUE

/datum/persistent/paper/LabelTokens(var/list/tokens)
	var/list/labelled_tokens = ..()
	var/entries = LAZYLEN(labelled_tokens)
	labelled_tokens["author"] =  tokens[entries+1]
	labelled_tokens["message"] = tokens[entries+2]
	labelled_tokens["title"] = tokens[entries+3]
	return labelled_tokens

/datum/persistent/paper/CheckTurfContents(var/turf/T, var/list/tokens)
	var/obj/structure/noticeboard/board = locate() in T
	return !istype(board) || LAZYLEN(board.notices) < board.max_notices

/datum/persistent/paper/CreateEntryInstance(var/turf/creating, var/list/tokens)
	var/obj/structure/noticeboard/board = locate() in creating
	if(!board && requires_noticeboard)
		board = new(creating)
	var/obj/item/weapon/paper/paper = new paper_type(creating)
	paper.set_content(tokens["message"], tokens["title"])
	paper.last_modified_ckey = tokens["author"]
	if(board)
		board.add_paper(paper)

/datum/persistent/paper/IsValidEntry(var/atom/entry)
	. = ..()
	if(. && requires_noticeboard)
		var/obj/structure/noticeboard/N = entry.loc
		. = istype(N) && (entry in N.notices)

/datum/persistent/paper/GetEntryAge(var/atom/entry)
	var/obj/item/weapon/paper/paper = entry
	return paper.age

/datum/persistent/paper/CompileEntry(var/atom/entry, var/write_file)
	. = ..()
	var/obj/item/weapon/paper/paper = entry
	LAZYADD(., "[paper.last_modified_ckey ? paper.last_modified_ckey : "unknown"]")
	LAZYADD(., "[paper.info]")
	LAZYADD(., "[paper.name]")

/datum/persistent/paper/GetAdminDataStringFor(var/thing, var/datum/admins/caller, var/can_modify)
	var/obj/item/weapon/paper/paper = thing
	if(can_modify)
		. = "<td>[paper.info]</td><td>[paper.name]</td><td>[paper.last_modified_ckey]</td><td><a href='byond://?src=\ref[src];caller=\ref[caller];remove_entry=\ref[thing]'>Destroy</a></td><td><a href='byond://?src=\ref[src];caller=\ref[caller];ban_author=[paper.last_modified_ckey]'>Ban Author</a></td>"
	else
		. = "<td colspan = 2>[paper.info]</td><td colspan = 2>[paper.name]</td><td>[paper.last_modified_ckey]</td>"

/datum/persistent/paper/RemoveValue(var/atom/value)
	var/obj/structure/noticeboard/board = value.loc
	if(istype(board))
		board.remove_paper(value)
	qdel(value)
