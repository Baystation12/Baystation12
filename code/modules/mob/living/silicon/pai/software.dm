var/list/pai_emotions = list(
		"Happy" = 1,
		"Cat" = 2,
		"Extremely Happy" = 3,
		"Face" = 4,
		"Laugh" = 5,
		"Off" = 6,
		"Sad" = 7,
		"Angry" = 8,
		"What" = 9
	)


var/global/list/pai_software_by_key = list()
var/global/list/default_pai_software = list()
/hook/startup/proc/populate_pai_software_list()
	var/r = 1 // I would use ., but it'd sacrifice runtime detection
	for(var/type in typesof(/datum/pai_software) - /datum/pai_software)
		var/datum/pai_software/P = new type()
		if(pai_software_by_key[P.id])
			var/datum/pai_software/O = pai_software_by_key[P.id]
			world << "<span class='warning'>pAI software module [P.name] has the same key as [O.name]!</span>"
			r = 0
			continue
		pai_software_by_key[P.id] = P
		if(P.default)
			default_pai_software[P.id] = P
	return r

/mob/living/silicon/pai/New()
	..()
	software = default_pai_software.Copy()

/mob/living/silicon/pai/verb/paiInterface()
	set category = "pAI Commands"
	set name = "Software Interface"

	ui_interact(src)

/mob/living/silicon/pai/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1)
	if(user != src)
		if(ui) ui.set_status(STATUS_CLOSE, 0)
		return

	if(ui_key != "main")
		var/datum/pai_software/S = software[ui_key]
		if(S && !S.toggle)
			S.on_ui_interact(src, ui, force_open)
		else
			if(ui) ui.set_status(STATUS_CLOSE, 0)
		return

	var/data[0]

	// Software we have bought
	var/bought_software[0]
	// Software we have not bought
	var/not_bought_software[0]

	for(var/key in pai_software_by_key)
		var/datum/pai_software/S = pai_software_by_key[key]
		var/software_data[0]
		software_data["name"] = S.name
		software_data["id"] = S.id
		if(key in software)
			software_data["on"] = S.is_active(src)
			bought_software[++bought_software.len] = software_data
		else
			software_data["ram"] = S.ram_cost
			not_bought_software[++not_bought_software.len] = software_data

	data["bought"] = bought_software
	data["not_bought"] = not_bought_software
	data["available_ram"] = ram

	// Emotions
	var/emotions[0]
	for(var/name in pai_emotions)
		var/emote[0]
		emote["name"] = name
		emote["id"] = pai_emotions[name]
		emotions[++emotions.len] = emote

	data["emotions"] = emotions
	data["current_emotion"] = card.current_emotion

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "pai_interface.tmpl", "pAI Software Interface", 450, 600)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/mob/living/silicon/pai/Topic(href, href_list)
	. = ..()
	if(.) return

	if(href_list["software"])
		var/soft = href_list["software"]
		var/datum/pai_software/S = software[soft]
		if(S.toggle)
			S.toggle(src)
		else
			ui_interact(src, ui_key = soft)
		return 1

	else if(href_list["stopic"])
		var/soft = href_list["stopic"]
		var/datum/pai_software/S = software[soft]
		if(S)
			return S.Topic(href, href_list)

	else if(href_list["purchase"])
		var/soft = href_list["purchase"]
		var/datum/pai_software/S = pai_software_by_key[soft]
		if(S && (ram >= S.ram_cost))
			ram -= S.ram_cost
			software[S.id] = S
		return 1
/*
// Security HUD
/mob/living/silicon/pai/proc/facialRecognition()
	var/dat = {"<h2>Facial Recognition Suite</h2><hr>
				When enabled, this package will scan all viewable faces and compare them against the known criminal database, providing real-time graphical data about any detected persons of interest.<br><br>
				The suite is currently [ (src.secHUD) ? "<font color=#55FF55>en" : "<font color=#FF5555>dis" ]abled</font>.<br>
				<a href='byond://?src=\ref[src];software=securityhud;sub=0;toggle=1'>Toggle Suite</a><br>
				"}
	return dat

// Medical HUD
/mob/living/silicon/pai/proc/medicalAnalysis()
	var/dat = ""
	if(src.subscreen == 0)
		dat += {"<h2>Medical Analysis Suite</h2><hr>
				 <h4>Visual Status Overlay</h4>
					When enabled, this package will scan all nearby crewmembers' vitals and provide real-time graphical data about their state of health.<br><br>
					The suite is currently [ (src.medHUD) ? "<font color=#55FF55>en" : "<font color=#FF5555>dis" ]abled</font>.<br>
					<a href='byond://?src=\ref[src];software=medicalhud;sub=0;toggle=1'>Toggle Suite</a><br>
					<br>
					<a href='byond://?src=\ref[src];software=medicalhud;sub=1'>Host Bioscan</a><br>
					"}
	if(src.subscreen == 1)
		dat += {"<h2>Medical Analysis Suite</h2><hr>
				 <h4>Host Bioscan</h4>
				"}

		var/mob/living/M
		//If we are not deployed, check the holder of the card.
		if(src.loc == card)
			M = card.loc

		//If we are deployed or the card is not held, check the first living mob in our turf.
		if(!M || !istype(M))
			var/turf/T = get_turf(src)
			M = locate(/mob/living/) in T.contents

		if(!M || !istype(M))
			src.temp = "Error: No biological host found. <br>"
			src.subscreen = 0
			return dat

		dat += {"<b>Bioscan Results for [M]</b>: <br>
		Overall Status: [M.stat > 1 ? "dead" : "[M.health]% healthy"] <br><br>

		<b>Scan Breakdown</b>: <br>
		Respiratory: [M.getOxyLoss() > 50 ? "<font color=#FF5555>" : "<font color=#55FF55>"][M.getOxyLoss()]</font><br>
		Toxicology: [M.getToxLoss() > 50 ? "<font color=#FF5555>" : "<font color=#55FF55>"][M.getToxLoss()]</font><br>
		Burns: [M.getFireLoss() > 50 ? "<font color=#FF5555>" : "<font color=#55FF55>"][M.getFireLoss()]</font><br>
		Structural Integrity: [M.getBruteLoss() > 50 ? "<font color=#FF5555>" : "<font color=#55FF55>"][M.getBruteLoss()]</font><br>
		Body Temperature: [M.bodytemperature-T0C]&deg;C ([M.bodytemperature*1.8-459.67]&deg;F)<br>
		"}
		for(var/datum/disease/D in M.viruses)
			dat += {"<h4>Infection Detected.</h4><br>
					 Name: [D.name]<br>
					 Type: [D.spread]<br>
					 Stage: [D.stage]/[D.max_stages]<br>
					 Possible Cure: [D.cure]<br>
					"}
		dat += "<br><a href='byond://?src=\ref[src];software=medicalhud;sub=1'>Refresh Bioscan</a><br>"
		dat += "<br><a href='byond://?src=\ref[src];software=medicalhud;sub=0'>Visual Status Overlay</a><br>"
	return dat

// Atmospheric Scanner
/mob/living/silicon/pai/proc/softwareAtmo()
	var/dat = "<h2>Atmospheric Sensor</h2><hr>"

	var/turf/T = get_turf_or_move(src.loc)
	if (isnull(T))
		dat += "Unable to obtain a reading.<br>"
	else
		var/datum/gas_mixture/environment = T.return_air()

		var/pressure = environment.return_pressure()
		var/total_moles = environment.total_moles

		dat += "Air Pressure: [round(pressure,0.1)] kPa<br>"

		if(total_moles)
			for(var/g in environment.gas)
				dat += "[gas_data.name[g]]: [round((environment.gas[g] / total_moles) * 100)]%<br>"
		dat += "Temperature: [round(environment.temperature-T0C)]&deg;C<br>"
	dat += "<br><a href='byond://?src=\ref[src];software=atmosensor;sub=0'>Refresh Reading</a>"
	return dat

// Camera Jack - Clearly not finished
/mob/living/silicon/pai/proc/softwareCamera()
	var/dat = "<h2>Camera Jack</h2><hr>"
	dat += "Cable status : "

	if(!src.cable)
		dat += "<font color=#FF5555>Retracted</font> <br>"
		return dat
	if(!src.cable.machine)
		dat += "<font color=#FFFF55>Extended</font> <br>"
		return dat

	var/obj/machinery/machine = src.cable.machine
	dat += "<font color=#55FF55>Connected</font> <br>"

	if(!istype(machine, /obj/machinery/camera))
		src << "DERP"
	return dat

// Door Jack
/mob/living/silicon/pai/proc/softwareDoor()
	var/dat = "<h2>Airlock Jack</h2><hr>"
	dat += "Cable status : "
	if(!src.cable)
		dat += "<font color=#FF5555>Retracted</font> <br>"
		dat += "<a href='byond://?src=\ref[src];software=doorjack;cable=1;sub=0'>Extend Cable</a> <br>"
		return dat
	if(!src.cable.machine)
		dat += "<font color=#FFFF55>Extended</font> <br>"
		return dat

	var/obj/machinery/machine = src.cable.machine
	dat += "<font color=#55FF55>Connected</font> <br>"
	if(!istype(machine, /obj/machinery/door))
		dat += "Connected device's firmware does not appear to be compatible with Airlock Jack protocols.<br>"
		return dat
//	var/obj/machinery/airlock/door = machine

	if(!src.hackdoor)
		dat += "<a href='byond://?src=\ref[src];software=doorjack;jack=1;sub=0'>Begin Airlock Jacking</a> <br>"
	else
		dat += "Jack in progress... [src.hackprogress]% complete.<br>"
		dat += "<a href='byond://?src=\ref[src];software=doorjack;cancel=1;sub=0'>Cancel Airlock Jack</a> <br>"
	//src.hackdoor = machine
	//src.hackloop()
	return dat

// Door Jack - supporting proc
/mob/living/silicon/pai/proc/hackloop()
	var/turf/T = get_turf_or_move(src.loc)
	for(var/mob/living/silicon/ai/AI in player_list)
		if(T.loc)
			AI << "<font color = red><b>Network Alert: Brute-force encryption crack in progress in [T.loc].</b></font>"
		else
			AI << "<font color = red><b>Network Alert: Brute-force encryption crack in progress. Unable to pinpoint location.</b></font>"
	while(src.hackprogress < 100)
		if(src.cable && src.cable.machine && istype(src.cable.machine, /obj/machinery/door) && src.cable.machine == src.hackdoor && get_dist(src, src.hackdoor) <= 1)
			hackprogress += rand(1, 10)
		else
			src.temp = "Door Jack: Connection to airlock has been lost. Hack aborted."
			hackprogress = 0
			src.hackdoor = null
			return
		if(hackprogress >= 100)		// This is clunky, but works. We need to make sure we don't ever display a progress greater than 100,
			hackprogress = 100		// but we also need to reset the progress AFTER it's been displayed
		if(src.screen == "doorjack" && src.subscreen == 0) // Update our view, if appropriate
			src.paiInterface()
		if(hackprogress >= 100)
			src.hackprogress = 0
			src.cable.machine:open()
		sleep(50)			// Update every 5 seconds

// Digital Messenger
/mob/living/silicon/pai/proc/pdamessage()

	var/dat = "<h2>Digital Messenger</h2><hr>"
	dat += {"<b>Signal/Receiver Status:</b> <A href='byond://?src=\ref[src];software=pdamessage;toggler=1'>
	[(pda.toff) ? "<font color='red'> \[Off\]</font>" : "<font color='green'> \[On\]</font>"]</a><br>
	<b>Ringer Status:</b> <A href='byond://?src=\ref[src];software=pdamessage;ringer=1'>
	[(pda.silent) ? "<font color='red'> \[Off\]</font>" : "<font color='green'> \[On\]</font>"]</a><br><br>"}
	dat += "<ul>"
	if(!pda.toff)
		for (var/obj/item/device/pda/P in sortAtom(PDAs))
			if (!P.owner||P.toff||P == src.pda||P.hidden)	continue
			dat += "<li><a href='byond://?src=\ref[src];software=pdamessage;target=\ref[P]'>[P]</a>"
			dat += "</li>"
	dat += "</ul>"
	dat += "Messages: <hr>"

	dat += "<style>td.a { vertical-align:top; }</style>"
	dat += "<table>"
	for(var/index in pda.tnote)
		if(index["sent"])
			dat += addtext("<tr><td class='a'><i><b>To</b></i></td><td class='a'><i><b>&rarr;</b></i></td><td><i><b><a href='byond://?src=\ref[src];software=pdamessage;target=",index["src"],"'>", index["owner"],"</a>: </b></i>", index["message"], "<br></td></tr>")
		else
			dat += addtext("<tr><td class='a'><i><b>From</b></i></td><td class='a'><i><b>&rarr;</b></i></td><td><i><b><a href='byond://?src=\ref[src];software=pdamessage;target=",index["target"],"'>", index["owner"],"</a>: </b></i>", index["message"], "<br></td></tr>")
	dat += "</table>"
	return dat

/mob/living/silicon/pai/proc/translator_toggle()

	// 	Sol Common, Tradeband and Gutter are added with New() and are therefore the current default, always active languages

	if(translator_on)
		translator_on = 0

		remove_language("Sinta'unathi")
		remove_language("Siik'tajr")
		remove_language("Skrellian")
		remove_language("Aviachirp")
		remove_language("Chittin")
		remove_language("Vox-pidgin")
		remove_language("Rootspeak")
		remove_language("Encoded Audio Language")
		remove_language("Xenomorph")

		src << "\blue Translator Module toggled OFF."

	else
		translator_on = 1

		add_language("Sinta'unathi")
		add_language("Siik'tajr")
		add_language("Skrellian")
		add_language("Aviachirp")
		add_language("Chittin")
		add_language("Vox-pidgin")
		add_language("Rootspeak")
		add_language("Encoded Audio Language")
		add_language("Xenomorph")

		src << "\blue Translator Module toggled ON."*/
	else if(href_list["image"])
		var/img = text2num(href_list["image"])
		if(1 <= img && img <= 9)
			card.setEmotion(img)
		return 1
