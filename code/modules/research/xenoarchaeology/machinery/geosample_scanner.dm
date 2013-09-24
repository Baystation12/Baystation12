
/obj/machinery/radiocarbon_spectrometer
	name = "Radiocarbon spectrometer"
	desc = "A specialised, complex scanner for gleaning information on all manner of small things."
	anchored = 1
	density = 1
	icon = 'icons/obj/virology.dmi'
	icon_state = "analyser"

	use_power = 1			//1 = idle, 2 = active
	idle_power_usage = 20
	active_power_usage = 300

	var/obj/item/weapon/reagent_containers/glass/held_container
	var/scanning = 0
	var/report_num = 0
	//
	var/obj/item/scanned_item
	var/last_scan_data = "test data"
	//
	var/scan_start_time = 1
	var/scan_end_time = 1
	var/scan_progress = 0
	var/scan_duration = 600

/obj/machinery/radiocarbon_spectrometer/attack_hand(var/mob/user as mob)
	ui_interact(user)

/obj/machinery/radiocarbon_spectrometer/attackby(var/obj/I as obj, var/mob/user as mob)
	scanned_item = I
	scanning = 1
	user.drop_item()
	I.loc = src
	scan_end_time = world.time + 100

/obj/machinery/radiocarbon_spectrometer/ui_interact(mob/user, ui_key = "radio_spectro")

	if(user.stat)
		return

	// this is the data which will be sent to the ui
	var/data[0]
	data["scanned_item"] = scanned_item ? scanned_item.name : null
	data["scanned_item_desc"] = scanned_item ? scanned_item.desc : null
	data["scanning"] = scan_progress
	data["scan_progress"] = scanning
	data["last_scan_data"] = last_scan_data

	var/datum/nanoui/ui = nanomanager.get_open_ui(user, src, ui_key)
	if (!ui)
		// the ui does not exist, so we'll create a new one
		ui = new(user, src, ui_key, "geoscanner.tmpl", "High Res Radiocarbon Spectrometer", 520, 410)
		// When the UI is first opened this is the data it will use
		ui.set_initial_data(data)
		ui.open()
		// Auto update every Master Controller tick
		ui.set_auto_update(1)
	else
		// The UI is already open so push the new data to it
		ui.push_data(data)
		return

/obj/machinery/radiocarbon_spectrometer/process()
	if(scanning)
		if(!scanned_item || scanned_item.loc != src)
			scanned_item = null
			scanning = 0
		else if(world.time >= scan_end_time)
			src.visible_message("\blue \icon[src] makes an insistent chime.", 2)
			scanning = 0

			//create report
			var/obj/item/weapon/paper/P = new(src.loc)
			P.name = "[src] report #[++report_num]: [scanned_item.name]"
			P.stamped = list(/obj/item/weapon/stamp)
			P.overlays = list("paper_stamped")

			//work out data
			var/data = " - Mundane object<br>"
			var/datum/geosample/G
			switch(scanned_item.type)
				if(/obj/item/weapon/ore)
					var/obj/item/weapon/ore/O = scanned_item
					if(O.geological_data)
						G = O.geological_data

				if(/obj/item/weapon/rocksliver)
					var/obj/item/weapon/rocksliver/O = scanned_item
					if(O.geological_data)
						G = O.geological_data

				if(/obj/item/weapon/archaeological_find)
					data = " - Mundane object (unknown xenos origins)<br>"

					var/obj/item/weapon/archaeological_find/A = scanned_item
					if(A.speaking_to_players)
						data = " - Exhibits properties consistent with sonic mimicry.<br>"
					if(A.listening_to_players)
						data = " - Exhibits properties similar to audio capture technologies.<br>"

			var/anom_found = 0
			if(G)
				data = " - Spectometric analysis on mineral sample of [finds_as_strings[responsive_carriers.Find(G.source_mineral)]]<br>"
				if(G.age_billion > 0)
					data += " - Radiometric dating shows age of [G.age_billion].[G.age_million] billion years<br>"
				else if(G.age_million > 0)
					data += " - Radiometric dating shows age of [G.age_million].[G.age_thousand] million years<br>"
				else
					data += " - Radiometric dating shows age of [G.age_thousand * 1000 + G.age] years<br>"
				data += " - Chromatographic analysis shows the following materials present:<br>"
				for(var/carrier in G.find_presence)
					if(G.find_presence[carrier])
						data += " - - [G.find_presence[carrier]]% [finds_as_strings[carrier]]<br>"

				if(G.artifact_id && G.artifact_distance >= 0)
					anom_found = 1
					data += " - Hyperspectral imaging reveals exotic energy wavelength detected with ID: [G.artifact_id]<br>"
					data += " - Fourier transform analysis on anomalous energy absorption indicates energy source located inside emission radius of [G.artifact_distance]m<br>"

			if(!anom_found)
				data += " - No anomalous data<br>"

			P.info = "<b>[src] analysis report #[report_num]<br>"
			P.info += "<b>Scanned item:</b> [scanned_item.name]<br><br>" + data
			last_scan_data = P.info

			scanned_item.loc = src
			scanned_item = null
		else
			scan_progress = 100 * (scan_end_time - scan_start_time) / scan_duration
			if(prob(2))
				src.visible_message("\blue \icon[src] [pick("whirrs","chuffs","clicks")][pick(" excitedly"," energetically"," busily")].", 2)
	else if(prob(0.5))
		src.visible_message("\blue \icon[src] [pick("plinks","hisses")][pick(" quietly"," softly"," sadly"," plaintively")].", 2)
