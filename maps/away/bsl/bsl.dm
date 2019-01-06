#include "bsl_areas.dm"

/////Overmap & Shuttle Stuff
/obj/effect/overmap/sector/bsl
	name = "Bio Space Lab"
	desc = "Sensors detect a deep space research station with a faint energy profile and multiple life signs."
	icon_state = "object"
	known = 0
	initial_generic_waypoints = list(
		"nav_bsl_0",
		"nav_bsl_1",
		"nav_bsl_2",
		"nav_bsl_3",
		"nav_bsl_4",
		"nav_bsl_5",
		"nav_bsl_6",
		"nav_bsl_7"
	)

/datum/map_template/ruin/away_site/bsl
	name = "Bio Space Laboratory"
	id = "awaysite_bsl"
	description = "A deep space research station geared towards the study of xenofauna."
	suffixes = list("bsl/bsl-1.dmm", "bsl/bsl-2.dmm")
	shuttles_to_initialise = list(/datum/shuttle/autodock/ferry/bsl_lift)
	cost = 1.5

/obj/effect/shuttle_landmark/nav_bsl/nav0
	name = "Navpoint #1 North West D1"
	landmark_tag = "nav_bsl_0"

/obj/effect/shuttle_landmark/nav_bsl/nav1
	name = "Navpoint #2 East D1"
	landmark_tag = "nav_bsl_1"

/obj/effect/shuttle_landmark/nav_bsl/nav2
	name = "Navpoint #3 South East D1"
	landmark_tag = "nav_bsl_2"

/obj/effect/shuttle_landmark/nav_bsl/nav3
	name = "Navpoint #4 South West D1"
	landmark_tag = "nav_bsl_3"

/obj/effect/shuttle_landmark/nav_bsl/nav4
	name = "Navpoint #5 North D2"
	landmark_tag = "nav_bsl_4"

/obj/effect/shuttle_landmark/nav_bsl/nav5
	name = "Navpoint #6 East D2"
	landmark_tag = "nav_bsl_5"

/obj/effect/shuttle_landmark/nav_bsl/nav6
	name = "Navpoint #7 South D2"
	landmark_tag = "nav_bsl_6"

/obj/effect/shuttle_landmark/nav_bsl/nav7
	name = "Navpoint #8 West D2"
	landmark_tag = "nav_bsl_7"

/////Cargo Lift
/datum/shuttle/autodock/ferry/bsl_lift
	name = "BSL Cargo Lift"
	shuttle_area = /area/bsl/shuttle/lift
	warmup_time = 4
	waypoint_station = "nav_bsl_lift_bottom"
	waypoint_offsite = "nav_bsl_lift_top"
	sound_takeoff = 'sound/effects/lift_heavy_start.ogg'
	sound_landing = 'sound/effects/lift_heavy_stop.ogg'
	ceiling_type = null
	knockdown = 0
	defer_initialisation = TRUE

/obj/machinery/computer/shuttle_control/lift/bsl
	name = "lift controls"
	shuttle_tag = "BSL Cargo Lift"
	ui_template = "shuttle_control_console_lift.tmpl"
	icon_state = "tiny"
	icon_keyboard = "tiny_keyboard"
	icon_screen = "lift"
	density = 0

/obj/machinery/computer/shuttle_control/lift/bsl/panel
	icon = 'maps/away/bsl/bsl_sprites.dmi'
	icon_state = "tiny-panel"
	icon_keyboard = "tiny-panel_keyboard"
	icon_screen = "tiny-panel_lift"

/obj/effect/shuttle_landmark/lift/bsl_top
	name = "BSL Top Deck"
	landmark_tag = "nav_bsl_lift_top"
	flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/lift/bsl_bottom
	name = "BSL Lower Deck"
	landmark_tag = "nav_bsl_lift_bottom"
	base_area = /area/bsl/hallway1
	base_turf = /turf/simulated/floor/plating

/////Everything else but notes & papers
/obj/machinery/power/apc/bsl
	cell_type = /obj/item/weapon/cell/super/empty
	locked = 0
	coverlocked = 0

/mob/living/simple_animal/hostile/nipbug
	name = "itiki"
	desc = "It's hard to intimidate prey with such goofy eyes."
	icon = 'maps/away/bsl/bsl_sprites.dmi'
	icon_state = "nipbug"
	icon_living = "nipbug"
	icon_dead = "nipbug_dead"
	speak_chance = 1
	emote_hear = list("scratches the ground","chitters", "chirps")
	mob_size = MOB_MINISCULE
	health = 20
	maxHealth = 20
	speed = 0
	move_to_delay = 0
	melee_damage_lower = 1
	melee_damage_upper = 3
	var/poison_per_bite = 2.5
	var/poison_type = /datum/reagent/soporific

/mob/living/simple_animal/hostile/nipbug/AttackingTarget()
	. = ..()
	if(isliving(.))
		var/mob/living/L = .
		if(L.reagents)
			L.reagents.add_reagent(/datum/reagent/soporific, poison_per_bite)
			to_chat(L, "<span class='warning'>You feel a tiny prick as \the [src] nips you.</span>")

/obj/effect/paint/bsl
	color = "#99763b"

/obj/item/weapon/storage/secure/safe/bsl
	l_code = "43598"
	l_set = 1
	desc = "This model has been upgraded to be tamper resistant."

/obj/item/weapon/storage/secure/safe/bsl/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(locked)
		if(isScrewdriver(W))
			user.show_message(text("<span class='notice'>The anti-tamper measures prevent you from opening the service panel.</span>"))
			return
		return
	..()

/obj/item/weapon/storage/secure/safe/bsl/New()
		..()
		new /obj/item/weapon/reagent_containers/syringe/steroid(src)
		new /obj/item/clothing/head/helmet/space/void/merc(src)
		new /obj/item/clothing/gloves/thick/swat(src)
		new /obj/item/weapon/paper/crumpled(src)
		new /obj/item/weapon/spacecash/bundle/c20(src)
		new /obj/item/weapon/spacecash/bundle/c100(src)
		new /obj/item/weapon/spacecash/bundle/c100(src)
		new /obj/item/weapon/reagent_containers/food/drinks/bottle/specialwhiskey(src)
		new /obj/item/weapon/gun/projectile/revolver/mateba(src)
		new /obj/item/ammo_casing/a50(src)
		new /obj/item/device/dociler(src)
		new /obj/item/weapon/reagent_containers/pill/happy(src)

/turf/simulated/ocean/bsl
	flooded = FALSE

//////////Notes & Papers

/obj/item/weapon/paper/bsl/log1
	name = "printed log #0152-A"
	info = "//Biological Space Laboratory<br>\
			//System Log<br>\
			<br><br>\
			(00:00) Beginning daily system analysis...<br><br>\
			(00:01) Daily system analysis complete. All systems nominal.<br><br>\
			(03:23) Asteroid cluster detected. Auto-designation: ASTEROID_CLUSTER-0118<br><br>\
			(03:24) Beginning automated analysis of: ASTEROID_CLUSTER-0118...<br><br>\
			(03:24) Beginning thermal scan...<br><br>\
			(03:24) Thermal scan complete.<br><br>\
			(03:25) Beginning optical scan...<br><br>\
			(03:27) Optical scan complete.<br><br>\
			(03:27) Charging Alden-Saraspova array...<br><br>\
			(03:30) Alden-Saraspova array charged.<br><br>\
			(03:30) Aligning Alden-Saraspova array...<br><br>\
			(03:31) Alden-Saraspova array aligned.<br><br>\
			(03:31) Beginning Alden-Saraspova scan...<br><br>\
			(03:58) Alden-Saraspova scan complete.<br><br>\
			(03:58) Analyzing data...<br><br>\
			(04:00) Data analysis complete.<br><br>\
			(04:00) ASTEROID_CLUSTER-0118: Exotic particles detected. Anomalous artifact detected. Anomalous biological material detected. No signs of life detected.<br><br>\
			(04:00) Automated analysis complete.<br><br>\
			(05:27) Space carp school detected. Analyzing vectors...<br><br>\
			(05:28) No intersect detected.<br><br>\
			(07:47) Shuttle departing for: ASTEROID_CLUSTER-0118<br><br>\
			(07:59) Shuttle has left local space.<br><br>\
			(11:55) Ion cloud detected. Analyzing vectors...<br><br>\
			(11:55) Estimated 4 minutes until intersect.<br><br>\
			(12:00) Entering ion cl%$*<br><br>\
			(12:11) *%^ting ion cloud.<br><br>\
			(16:30) Shuttle has entered local space.<br><br>\
			(16:31) Radiation storm detected. Analyzing vectors...<br><br>\
			(16:32) Estimated 2 minutes until intersect.<br><br>\
			(16:34) Entering radiation storm.<br><br>\
			(16:38) Exiting radiation storm.<br><br>\
			(16:40) Collision course detected. Analyzing vectors...<br><br>\
			(16:41) Estimated 0 minutes to intersect.<br><br>\
			(16:41) Collision detected.<br><br>\
			(16:41) Breach detected: Anomaly Laboratory.<br><br>\
			(16:41) Breach detected: Shuttle.<br><br>\
			(16:41) Breach detected: Upper Deck Maintenance.<br><br>\
			(16:41) Breach detected: Hangar.<br><br>\
			(16:41) Shuttle connection lost.<br><br>\
			(17:31) Manual override detected. Beginning automated analysis of: Shuttle<br><br>\
			(17:31) Beginning thermal scan..."

/obj/item/weapon/paper/bsl/log2
	name = "printed log #0153-B"
	info = "//Biological Space Laboratory<br>\
			//System Log<br>\
			<br><br>\
			(17:31) Thermal scan complete.<br><br>\
			(17:31) Beginning optical scan...<br><br>\
			(17:32) Optical scan complete.<br><br>\
			(17:32) Charging Alden-Saraspova array...<br><br>\
			(17:34) Alden-Saraspova array charged.<br><br>\
			(17:34) Aligning Alden-Saraspova array...<br><br>\
			(17:35) Alden-Saraspova array aligned.<br><br>\
			(17:35) Beginning Alden-Saraspova scan...<br><br>\
			(17:42) Alden-Saraspova scan complete.<br><br>\
			(17:42) Analyzing data...<br><br>\
			(17:44) Data analysis complete.<br><br>\
			(17:44) Shuttle: Biological material detected. Anomalous biological material detected. No signs of life detected.<br><br>\
			(17:44) Automated analysis complete.<br><br>\
			(17:53) Explosion detected: Lower Deck Airlock.<br><br>\
			(17:53) Breach detected: Lower Deck Airlock.<br><br>\
			(18:34) Carp school detected. Analyzing vectors...<br><br>\
			(18:35) No intersect detected.<br><br>\
			(19:03) Explosion detected: Lower Deck Maintenance.<br><br>\
			(19:03) Breach detected: Lower Deck Maintenance.<br><br>\
			(19:03) Breach detected: Arid Habitat.<br><br>\
			(20:25) Explosion detected: Upper Deck Primary Hallway.<br><br>\
			(20:26) Explosion detected: Upper Deck Primary Hallway.<br><br>\
			(20:26) Loss of life has exceeded acceptable limit. Activating SOS beacon...<br><br>\
			(20:26) SOS beacon activated.<br><br>\
			(20:41) Manual override detected. SOS beacon deactivated.<br><br>\
			(20:41) Loss of life has exceeded acceptable limit. Activating SOS beacon...<br><br>\
			(20:41) SOS beacon activated.<br><br>\
			(21:16) Manual override detected. SOS beacon deactivated.<br><br>\
			(21:16) Loss of life has exceeded acceptable limit. Activating SOS beacon...<br><br>\
			(21:16) Error: unable to interface with SOS beacon.<br><br>\
			(21:59) Radiation storm detected. Analyzing vectors...<br><br>\
			(22:00) No intersect detected.<br><br>\
			(22:16) Loss of life has exceeded acceptable limit. Activating SOS beacon...<br><br>\
			(22:16) Error: unable to interface with SOS beacon.<br><br>\
			(22:37) Low power detected.<br><br>\
			(23:16) Loss of life has exceeded acceptable limit. Activating SOS beacon...<br><br>\
			(23:16) Error: unable to interface with SOS beacon.<br><br>\
			(23:19) Critical power detected. Power failure imminent."

/obj/item/weapon/paper/bsl/log0
	name = "printed log #0149-A"
	info = "//Biological Space Laboratory<br>\
			//System Log<br>\
			<br>\
			(00:00) Beginning daily system analysis...<br><br>\
			(00:01) Daily system analysis complete. All systems nominal.<br><br>\
			(04:34) Carp school detected. Analyzing vectors...<br><br>\
			(04:35) No intersect detected.<br><br>\
			(09:05) Dust cloud detected. Analyzing vectors...<br><br>\
			(09:05) Estimated 7 minutes to intersect.<br><br>\
			(09:12) Entering dust cloud.<br><br>\
			(09:30) Exiting dust cloud.<br><br>\
			(13:42) Asteroid detected. Auto-designation: ASTEROID-0534<br><br>\
			(13:42) Beginning automated analysis of: ASTEROID-0534...<br><br>\
			(13:43) Beginning thermal scan...<br><br>\
			(13:43) Thermal scan complete.<br><br>\
			(13:43) Beginning optical scan...<br><br>\
			(13:44) Optical scan complete.<br><br>\
			(13:44) Charging Alden-Saraspova array...<br><br>\
			(13:47) Alden-Saraspova array charged.<br><br>\
			(13:47) Aligning Alden-Saraspova array...<br><br>\
			(13:48) Alden-Saraspova array aligned.<br><br>\
			(13:48) Beginning Alden-Saraspova scan...<br><br>\
			(13:56) Alden-Saraspova scan complete.<br><br>\
			(13:56) Analyzing data...<br><br>\
			(13:58) Data analysis complete.<br><br>\
			(13:58) ASTEROID-0538: Anomalous artifacts detected. No signs of life detected.<br><br>\
			(13:58) Automated analysis complete.<br><br>\
			(14:45) Shuttle departing for: ASTEROID-0538<br><br>\
			(14:56) Shuttle has left local space.<br><br>\
			(15:17) Electrical storm detected. Analyzing vectors...<br><br>\
			(15:17) Estimated 9 minutes to intersect.<br><br>\
			(15:26) Entering electrical sto<br><br>\
			(15:30) System reboot complete. Beginning system analysis...<br><br>\
			(15:31) All systems nominal.<br><br>\
			(17:12) Shuttle has entered local space.<br><br>\
			(17:24) Beginning docking procedures...<br><br>\
			(17:25) Shuttle has docked.<br><br>\
			(20:21) Dust cloud detected. Analyzing vectors...<br><br>\
			(20:21) No intersect detected.<br><br>\
			(20:32) New backup created: Solar_Knight_Gear_1.xov<br><br>\
			(21:13) New backup created: Solar_Knight_Gear_2.xov<br><br>\
			(21:15) Dust cloud detected. Analyzing vectors...<br><br>\
			(21:16) No intersect detected. <br><br>\
			(21:57) New backup created: Solar_Knight_Gear_3.xov"

/obj/item/weapon/paper/bsl/note0
	name = "printed document #01"
	info= "//Biological Space Laboratory<br>\
			//Solar_Knight_Gear_1.xov<br>\
			<br><br>\
			//ITEM: Solar Knight Helmet<br>\
			//DESCRIPTION: Medieval style plate helmet.<br>\
			//RECOVERED FROM: ASTEROID-0538<br>\
			//ANOMALY: Low level energy emissions interspersed throughout the structure and substructure. Unable to determine any data about activation trigger.<br>\
			//NOTES: Low level energy emissions may be a sign that an anomalistic effect exists and is just waiting to be activated. Unfortunately, I was unable to determine how to activate the helmet during my cursory examination. I did, however, find that the helmet is made from a previously undocumented material composition. It's both incredibly light and durable. I'll ask Dr. Yarvo to take a look at it, as material science is her strong suit. I'm sure she can figure it out.<br>\
			<br>\
			//Dr. Gabo Tukoko"


/obj/item/weapon/paper/bsl/note1
	name = "printed document #02"
	info = "//Biological Space Laboratory<br>\
			//Solar_Knight_Gear_2.xov<br>\
			<br><br>\
			//ITEM: Solar Knight Armor<br>\
			//DESCRIPTION: Medieval style plate armor.<br>\
			//RECOVERED FROM: ASTEROID-0538<br>\
			//ANOMALY: Low level energy emissions interspersed throughout the structure and substructure. Unable to determine any data about activation trigger.<br>\
			//NOTES: According to my Alden-Saraspova counter, the energy emissions of the armor and the helmet match each other exactly. This leads me to believe they either share the same effect, or maybe the helmet and armor work together to create a single effect. However, I was unable to determine how to activate this item as well. Perhaps the low level energy emissions aren't a sign of a latent energy waiting to be unlocked, but rather a sign that whatever energy the items once possessed has faded. Regardless, the armor is made almost entirely from that same miracle material. Yarvo's going to go nuts over this. <br>\
			<br>\
			//Dr. Gabo Tukoko"


/obj/item/weapon/paper/bsl/note2
	name = "printed document #03"
	info = "//Biological Space Laboratory<br>\
			//Solar_Knight_Gear_3.xov<br>\
			<br><br>\
			//ITEM:Solar Knight Longsword<br>\
			//DESCRIPTION:Medieval style sword<br>\
			//RECOVERED FROM:ASTEROID-0538<br>\
			//ANOMALY: Concentrated energy emissions interspersed throughout the structure and substructure. Activation index involves physical interaction with artifact surface.<br>\
			//NOTES: Well it seems I've unintentionally saved the best for last. The sword activated as soon as I picked it up, even through my gloves and anomaly suit. Seeing as it's a sword, my first test involved cutting something. To my surprise, it seemed to transfer the kinetic energy into a burst of heat on contact. Very intriguing. This definitely requires more testing. But it's late, and I'm tired. There's always tomorrow, right?<br>\
			<br>\
			//Dr. Gabo Tukoko"

/obj/item/weapon/paper/bsl/note3
	name = "written note"
	info = "Hey I didn't want to embarrass you by bringing it up in front of the rest of the crew, but as the tech chief I feel it's my duty to let you know that you have GOT up your password game. 00000 is not a secure password. Neither is 12345, nor 54321. You want a good password? Try 46583. Or 43598. Even 76492 would be fine. Anything other than what you've been doing. PLEASE.<br><br>\
			-Fredwart Finkle<br><br><br>\
			P.S. Please burn this after you read it. Leaving paper trails is SO BAD for password security. Seriously."