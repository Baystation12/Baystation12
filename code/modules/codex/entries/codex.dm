/datum/codex_entry/codex
	display_name = "The Codex"
	associated_strings = list("codex")
	lore_text = "The Codex is the overall body containing the document that you are currently reading. It is a distributed encyclopedia maintained by a dedicated, hard-working staff of journalists, bartenders, hobos, space pirates and xeno-intelligences, all with the goal of providing you, the user, with supposedly up-to-date, nominally useful documentation on the topics you want to know about. \
	<br><br> \
	Access to the Codex is afforded instantly by a variety of unobtrusive devices, including PDA attachments, retinal implants, neuro-memetic indoctrination and hover-drone. All our access devices are affordable, stylish and guaranteed not to expose you to encephalo-malware. \
	<br><br> \
	The Codex editorial offices are located in Venus orbit and will offer cash payments for stories, anecdotes and evidence of the strange and undocumented miscellany cluttering up our observable universe. Remember our motto: <i>\"Knowledge is power, sell your excess.\"</i>"

/datum/codex_entry/codex/New()
	mechanics_text = "The Codex is both an IC and OOC resource. ICly, it is as described; a space encyclopedia. You can use <b>Search-Codex <i>topic</i></b> to look something up, or you can click the links provided when examining some objects. \
	<br><br> \
	Any of the lore you find in the Codex, designated by <b><font color = '[CODEX_COLOR_LORE]'>green</font></b> text, can be freely referenced in-character. \
	<br><br> \
	OOC information on various mechanics and interactions is marked by <b><font color = '[CODEX_COLOR_MECHANICS]'>blue</font></b> text. \
	<br><br> \
	Information for antagonists will not be shown unless you are an antagonist, and is marked by <b><font color = '[CODEX_COLOR_ANTAG]'>red</font></b> text."
	..()

/datum/codex_entry/nexus
	display_name = "Nexus"
	associated_strings = list("nexus")
	mechanics_text = "The place to start with <span codexlink='codex'>The Codex</span><br>" 

/datum/codex_entry/nexus/get_text(var/mob/presenting_to)
	var/list/dat = list(get_header(presenting_to))
	dat += "[mechanics_text]"
	dat += "<h3>Categories</h3>"
	var/list/categories = list()
	for(var/type in subtypesof(/datum/codex_category))
		var/datum/codex_category/C = type
		var/key = "[initial(C.name)] (category)"
		var/datum/codex_entry/entry = SScodex.get_codex_entry(key)
		if(entry)
			categories += "<li><span codexlink='[key]'>[initial(C.name)]</span> - [initial(C.desc)]"
	dat += jointext(categories, " ")
	return "<font color = '[CODEX_COLOR_MECHANICS]'>[jointext(dat, null)]</font>"

/client/proc/codex_topic(href, href_list)
	if(href_list["codex_search"]) //nano throwing errors
		search_codex()
		return TRUE

	if(href_list["codex_index"]) //nano throwing errors
		list_codex_entries()
		return TRUE