// Reports are a way to notify admins of wrongdoings that happened
// while no admin was present. They work a bit similar to news, but
// they can only be read by admins and moderators.

// a single admin report
datum/admin_report/var
	ID     // the ID of the report
	body   // the content of the report
	author // key of the author
	date   // date on which this was created
	done   // whether this was handled

	offender_key // store the key of the offender
	offender_cid // store the cid of the offender

datum/report_topic_handler
	Topic(href,href_list)
		..()
		var/client/C = locate(href_list["client"])
		if(href_list["action"] == "show_reports")
			C.display_admin_reports()
		else if(href_list["action"] == "remove")
			C.mark_report_done(text2num(href_list["ID"]))
		else if(href_list["action"] == "edit")
			C.edit_report(text2num(href_list["ID"]))

var/datum/report_topic_handler/report_topic_handler

world/New()
	..()
	report_topic_handler = new

// add a new news datums
proc/make_report(body, author, okey, cid)
	var/savefile/Reports = new("data/reports.sav")
	var/list/reports
	var/lastID

	Reports["reports"]   >> reports
	Reports["lastID"] >> lastID

	if(!reports) 	reports = list()
	if(!lastID) 	lastID = 0

	var/datum/admin_report/created = new()
	created.ID 		= ++lastID
	created.body 	= body
	created.author 	= author
	created.date    = world.realtime
	created.done    = 0
	created.offender_key = okey
	created.offender_cid = cid

	reports.Insert(1, created)

	to_chat(Reports["reports"], reports)
	to_chat(Reports["lastID"], lastID)
// load the reports from disk
proc/load_reports()
	var/savefile/Reports = new("data/reports.sav")
	var/list/reports

	Reports["reports"] >> reports

	if(!reports) reports = list()

	return reports

// check if there are any unhandled reports
client/proc/unhandled_reports()
	if(!src.holder) return 0
	var/list/reports = load_reports()

	for(var/datum/admin_report/N in reports)
		if(N.done)
			continue
		else return 1

	return 0

// checks if the player has an unhandled report against him
client/proc/is_reported()
	var/list/reports = load_reports()

	for(var/datum/admin_report/N in reports) if(!N.done)
		if(N.offender_key == src.key)
			return 1

	return 0

// display only the reports that haven't been handled
client/proc/display_admin_reports()
	set category = "Admin"
	set name = "Display Admin Reports"
	if(!src.holder) return

	var/list/reports = load_reports()

	var/output = ""
	if(unhandled_reports())
		// load the list of unhandled reports
		for(var/datum/admin_report/N in reports)
			if(N.done)
				continue
			output += "<b>Reported player:</b> [N.offender_key](CID: [N.offender_cid])<br>"
			output += "<b>Offense:</b>[N.body]<br>"
			output += "<small>Occured at [time2text(N.date,"MM/DD hh:mm:ss")]</small><br>"
			output += "<small>authored by <i>[N.author]</i></small><br>"
			output += " <a href='?src=\ref[report_topic_handler];client=\ref[src];action=remove;ID=[N.ID]'>Flag as Handled</a>"
			if(src.key == N.author)
				output += " <a href='?src=\ref[report_topic_handler];client=\ref[src];action=edit;ID=[N.ID]'>Edit</a>"
			output += "<br>"
			output += "<br>"
	else
		output += "Whoops, no reports!"

	usr << browse(output, "window=news;size=600x400")


client/proc/Report(mob/M as mob in mob_list)
	set category = "Admin"
	if(!src.holder)
		return

	var/CID = "Unknown"
	if(M.client)
		CID = M.client.computer_id

	var/body = input(src.mob, "Describe in detail what you're reporting [M] for", "Report") as null|text
	if(!body) return


	make_report(body, key, M.key, CID)

	spawn(1)
		display_admin_reports()

client/proc/mark_report_done(ID as num)
	if(!src.holder || src.holder.level < 0)
		return

	var/savefile/Reports = new("data/reports.sav")
	var/list/reports

	Reports["reports"]   >> reports

	var/datum/admin_report/found
	for(var/datum/admin_report/N in reports)
		if(N.ID == ID)
			found = N
	if(!found) to_chat(src, "<b>* An error occured, sorry.</b>")

	found.done = 1

	to_chat(Reports["reports"], reports)
client/proc/edit_report(ID as num)
	if(!src.holder || src.holder.level < 0)
		to_chat(src, "<b>You tried to modify the news, but you're not an admin!</b>")
		return

	var/savefile/Reports = new("data/reports.sav")
	var/list/reports

	Reports["reports"]   >> reports

	var/datum/admin_report/found
	for(var/datum/admin_report/N in reports)
		if(N.ID == ID)
			found = N
	if(!found) to_chat(src, "<b>* An error occured, sorry.</b>")
	var/body = input(src.mob, "Enter a body for the news", "Body") as null|message
	if(!body) return

	found.body = body

	to_chat(Reports["reports"], reports)
