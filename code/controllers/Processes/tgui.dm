var/global/datum/controller/process/tgui/tgui_process

/datum/controller/process/tgui
	var/list/tg_open_uis = list() // A list of open UIs, grouped by src_object and ui_key.
	var/list/processing_uis = list() // A list of processing UIs, ungrouped.
	var/basehtml // The HTML base used for all UIs.

/datum/controller/process/tgui/setup()
	name = "tgui"
	schedule_interval = 10 // every 2 seconds
	start_delay = 23

	basehtml = file2text('tgui/tgui.html') // Read the HTML from disk.
	tgui_process = src

/datum/controller/process/tgui/doWork()
	for(var/gui in processing_uis)
		var/datum/tgui/ui = gui
		if(ui && ui.user && ui.src_object)
			ui.process()
			SCHECK
			continue
		processing_uis.Remove(ui)
		SCHECK

/datum/controller/process/tgui/statProcess()
	..()
	stat(null, "[tgui_process.processing_uis.len] UI\s")
