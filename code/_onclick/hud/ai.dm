/mob/living/silicon/ai
	hud_type = /datum/hud/ai

/datum/hud/ai/FinalizeInstantiation()

	if(!isAI(mymob))
		return

	var/mob/living/silicon/A = mymob

	adding = list()
	adding += new /obj/screen/ai_button(null,
			ui_ai_core,
			"AI Core",
			"ai_core",
			/mob/living/silicon/ai/proc/core
			)

	adding += new /obj/screen/ai_button(null,
			ui_ai_announcement,
			"AI Announcement",
			"announcement",
			/mob/living/silicon/ai/proc/ai_announcement
			)

	adding += new /obj/screen/ai_button(null,
			ui_ai_cam_track,
			"Track With Camera",
			"track",
			/mob/living/silicon/ai/proc/ai_camera_track,
			list(/mob/living/silicon/ai/proc/trackable_mobs = (AI_BUTTON_PROC_BELONGS_TO_CALLER|AI_BUTTON_INPUT_REQUIRES_SELECTION))
			)

	adding += new /obj/screen/ai_button(null,
			ui_ai_cam_light,
			"Toggle Camera Lights",
			"camera_light",
			/mob/living/silicon/ai/proc/toggle_camera_light
			)

	adding += new /obj/screen/ai_button(null,
			ui_ai_cam_change_network,
			"Jump to Network",
			"camera",
			/mob/living/silicon/ai/proc/ai_network_change,
			list(/mob/living/silicon/ai/proc/get_camera_network_list = (AI_BUTTON_PROC_BELONGS_TO_CALLER|AI_BUTTON_INPUT_REQUIRES_SELECTION))
			)

	adding += new /obj/screen/ai_button(null,
			ui_ai_sensor,
			"Set Sensor Mode",
			"ai_sensor",
			/mob/living/silicon/ai/proc/sensor_mode
			)

	adding += new /obj/screen/ai_button(null,
			ui_ai_crew_manifest,
			"Show Crew Manifest",
			"manifest",
			/mob/living/silicon/ai/proc/show_crew_manifest
			)

	adding += new /obj/screen/ai_button(null,
			ui_ai_take_image,
			"Toggle Camera Mode",
			"take_picture",
			/mob/living/silicon/ai/proc/ai_take_image
			)

	adding += new /obj/screen/ai_button(null,
			ui_ai_view_images,
			"View Images",
			"view_images",
			/mob/living/silicon/ai/proc/ai_view_images
			)

	adding += new /obj/screen/ai_button(null,
			ui_ai_state_laws,
			"State Laws",
			"state_laws",
			/mob/living/silicon/ai/proc/ai_checklaws
			)

	adding += new /obj/screen/ai_button(null,
			ui_ai_call_shuttle,
			"Call Shuttle",
			"call_shuttle",
			/mob/living/silicon/ai/proc/ai_call_shuttle
			)

	adding += new /obj/screen/ai_button(null,
			ui_ai_up,
			"Move Upwards",
			"ai_up",
			/mob/verb/up
			)

	adding += new /obj/screen/ai_button(null,
			ui_ai_down,
			"Move Downwards",
			"ai_down",
			/mob/verb/down
			)

	adding += new /obj/screen/ai_button(null,
			ui_ai_color,
			"Change Floor Color",
			"ai_floor",
			/mob/living/silicon/ai/proc/change_floor
			)

	adding += new /obj/screen/ai_button(null,
			ui_ai_holo_change,
			"Change Hologram",
			"ai_holo_change",
			/mob/living/silicon/ai/proc/ai_hologram_change
			)

	adding += new /obj/screen/ai_button(null,
			ui_ai_crew_mon,
			"Crew Monitor",
			"crew_monitor",
			/mob/living/silicon/ai/proc/show_crew_monitor
			)

	adding += new /obj/screen/ai_button(null,
			ui_ai_power_override,
			"Toggle Power Override",
			"ai_p_override",
			/mob/living/silicon/ai/proc/ai_power_override
			)

	adding += new /obj/screen/ai_button(null,
			ui_ai_shutdown,
			"Shutdown",
			"ai_shutdown",
			/mob/living/silicon/ai/proc/ai_shutdown
			)

	adding += new /obj/screen/ai_button(null,
			ui_ai_holo_mov,
			"Toggle Hologram Movement",
			"ai_holo_mov",
			/mob/living/silicon/ai/proc/toggle_hologram_movement
			)

	adding += new /obj/screen/ai_button(null,
			ui_ai_core_icon,
			"Pick Icon",
			"ai_core_pick",
			/mob/living/silicon/ai/proc/pick_icon
			)

	adding += new /obj/screen/ai_button(null,
			ui_ai_status,
			"Pick Status",
			"ai_status",
			/mob/living/silicon/ai/proc/ai_statuschange
			)

	adding += new /obj/screen/ai_button(null,
			ui_ai_crew_rec,
			"Crew Records",
			"ai_crew_rec",
			/mob/living/silicon/ai/proc/show_crew_records
			)

	A.client.screen = list()
	A.client.screen.Add(adding)
