/mob/living/silicon/ai //from infinity //proxima
	hud_type = /datum/hud/ai

/datum/hud/ai/FinalizeInstantiation() //~KareTa //And _Elar_
	adding = list()
	adding += new /obj/screen/ai_button{screen_loc = ui_ai_core;				name = "AI Core";				icon_state = "ai_core";			ai_verb = /mob/living/silicon/ai/proc/core}()
	adding += new /obj/screen/ai_button{screen_loc = ui_ai_announcement;		name = "AI Announcement";		icon_state = "announcement";	ai_verb = /mob/living/silicon/ai/proc/ai_announcement}()
	adding += new /obj/screen/ai_button{screen_loc = ui_ai_cam_track;			name = "Track With Camera";		icon_state = "track";			ai_verb = /mob/living/silicon/ai/proc/ai_camera_track;		input_procs = list(/mob/living/silicon/ai/proc/trackable_mobs = (AI_BUTTON_PROC_BELONGS_TO_CALLER|AI_BUTTON_INPUT_REQUIRES_SELECTION))}()
	adding += new /obj/screen/ai_button{screen_loc = ui_ai_cam_light;			name = "Toggle Camera Lights";	icon_state = "camera_light";	ai_verb = /mob/living/silicon/ai/proc/toggle_camera_light}()
	adding += new /obj/screen/ai_button{screen_loc = ui_ai_cam_change_network;	name = "Jump to Network";		icon_state = "camera";			ai_verb = /mob/living/silicon/ai/proc/ai_network_change;	input_procs = list(/mob/living/silicon/ai/proc/get_camera_network_list = (AI_BUTTON_PROC_BELONGS_TO_CALLER|AI_BUTTON_INPUT_REQUIRES_SELECTION))}()
	adding += new /obj/screen/ai_button{screen_loc = ui_ai_sensor;				name = "Set Sensor Mode";		icon_state = "ai_sensor";		ai_verb = /mob/living/silicon/ai/proc/sensor_mode}()
	adding += new /obj/screen/ai_button{screen_loc = ui_ai_crew_manifest;		name = "Show Crew Manifest";	icon_state = "manifest";		ai_verb = /mob/living/silicon/ai/proc/show_crew_manifest}()
	adding += new /obj/screen/ai_button{screen_loc = ui_ai_take_image;			name = "Toggle Camera Mode";	icon_state = "take_picture";	ai_verb = /mob/living/silicon/ai/proc/ai_take_image}()
	adding += new /obj/screen/ai_button{screen_loc = ui_ai_view_images;			name = "View Images";			icon_state = "view_images";		ai_verb = /mob/living/silicon/ai/proc/ai_view_images}()
	adding += new /obj/screen/ai_button{screen_loc = ui_ai_state_laws;			name = "State Laws";			icon_state = "state_laws";		ai_verb = /mob/living/silicon/ai/proc/ai_checklaws}()
	adding += new /obj/screen/ai_button{screen_loc = ui_ai_call_shuttle;		name = "Call Shuttle";			icon_state = "call_shuttle";	ai_verb = /mob/living/silicon/ai/proc/ai_call_shuttle}()
	adding += new /obj/screen/ai_button{screen_loc = ui_ai_up;					name = "Move Upwards";			icon_state = "ai_up";			ai_verb = /mob/verb/up}()
	adding += new /obj/screen/ai_button{screen_loc = ui_ai_down;				name = "Move Downwards";		icon_state = "ai_down";			ai_verb = /mob/verb/down}()



	adding += new /obj/screen/ai_button{screen_loc = ui_ai_color;			name = "Change Floor Color";		icon_state = "ai_floor";		ai_verb = /mob/living/silicon/ai/proc/change_floor}()
	adding += new /obj/screen/ai_button{screen_loc = ui_ai_holo_change;		name = "Change Hologram";			icon_state = "ai_holo_change";	ai_verb = /mob/living/silicon/ai/proc/ai_hologram_change}()
	adding += new /obj/screen/ai_button{screen_loc = ui_ai_crew_mon;		name = "Crew Monitor";				icon_state = "crew_monitor";	ai_verb = /mob/living/silicon/ai/proc/show_crew_monitor}()
	adding += new /obj/screen/ai_button{screen_loc = ui_ai_power_override;	name = "Toggle Power Override";		icon_state = "ai_p_override";	ai_verb = /mob/living/silicon/ai/proc/ai_power_override}()
	adding += new /obj/screen/ai_button{screen_loc = ui_ai_shutdown;		name = "Shutdown";					icon_state = "ai_shutdown";		ai_verb = /mob/living/silicon/ai/proc/ai_shutdown}()
	adding += new /obj/screen/ai_button{screen_loc = ui_ai_holo_mov;		name = "Toggle Hologram Movement";	icon_state = "ai_holo_mov";		ai_verb = /mob/living/silicon/ai/proc/toggle_hologram_movement}()
	adding += new /obj/screen/ai_button{screen_loc = ui_ai_core_icon;		name = "Pick Icon";					icon_state = "ai_core_pick";	ai_verb = /mob/living/silicon/ai/proc/pick_icon}()
	adding += new /obj/screen/ai_button{screen_loc = ui_ai_status;			name = "Pick Status";				icon_state = "ai_status";		ai_verb = /mob/living/silicon/ai/proc/ai_statuschange}()
	adding += new /obj/screen/ai_button{screen_loc = ui_ai_crew_rec;		name = "Crew Records";				icon_state = "ai_crew_rec";		ai_verb = /mob/living/silicon/ai/proc/show_crew_records}()
	mymob.client.screen = list()
	mymob.client.screen.Add(adding)
