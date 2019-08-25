// R&D tech file
/datum/computer_file/binary/tech
	filetype = "RDF"
	size = 8
	var/datum/tech/tech = null

/datum/computer_file/binary/tech/proc/set_tech(datum/tech/new_tech)
	tech = new_tech
	filename = sanitizeFileName(lowertext(tech.name))
