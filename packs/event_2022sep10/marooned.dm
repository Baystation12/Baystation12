/datum/map_template/ruin/exoplanet/event_2022sep10
	name = "Event 2022sep10 Marooned"
	id = "event_2022sep10"
	description = "A destroyed ship segment."
	prefix = "packs/event_2022sep10/"
	suffixes = list("marooned.dmm")
	spawn_cost = 1.5
	player_cost = 4
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS | TEMPLATE_FLAG_NO_RUINS | TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	ruin_tags = RUIN_HUMAN|RUIN_WRECK
	spawn_weight = 0.33


/obj/item/clothing/accessory/locket/ohno
	name = "bloodstained locket"
	desc = "Enclosed in this locket is an photograph of a ginger-haired family, smushed around a table with a birthday cake. They're smiling for the camera. It looks like it was someone's 18th birthday."


/obj/effect/landmark/corpse/thisguy
	name = "Finley Harris"
	corpse_outfits = list(/decl/hierarchy/outfit/thisguy)
	spawn_flags = ~CORPSE_SPAWNER_RANDOM_NAME
	genders_per_species = list(SPECIES_HUMAN = list(MALE))
	hair_styles_per_species = list(SPECIES_HUMAN = list("ponytail_tied"))
	hair_colors_per_species = list(SPECIES_HUMAN = list("#CC6600"))


/decl/hierarchy/outfit/thisguy
	name = "Haha Sike'd, the outfit"
	uniform = /obj/item/clothing/under/solgov/utility/fleet/combat/engineering
	suit = /obj/item/clothing/suit/space/void/engineering
	belt = /obj/item/storage/belt/utility/full
	shoes = /obj/item/clothing/shoes/jackboots
	mask = /obj/item/clothing/mask/breath/emergency
	gloves = /obj/item/clothing/gloves/thick
	head = /obj/item/clothing/head/helmet/space/void/engineering
	l_pocket = /obj/item/clothing/accessory/locket/ohno


/obj/effect/computer_file_creator/event1
	name = "command announcement file spawner"
	file_name = "FLEETCOM_DATACACHE-ANNOUNCEMENTSYSTEM"
	file_info = {"
\[hr]
<23:33:07>
All Hands,

All personnel on board, barring the express permission of Commander Trager, are hereby confined to quarters pending further orders and inspection from the Commander or an appointed subordinate of the Commander’s choosing.
Code Red Procedure is in place, this is not a drill. Failure to comply will be dealt with to the fullest extent of the Sol Code of Uniform Justice.
\[hr]
<23:51:29>
All Hands,

Radar Team Bravo has failed to comply with orders and will shortly face summary justice, you are asked to continue to remain in your dorms at this time barring the previously mentioned exceptions.
Furthermore, any sightings of Radar Team Bravo, or any other individual found in violations of orders should be reported and/or recorded as soon as possible for Commander Trager.
Code Red Procedure is in place, this is not a drill. Failure to comply will be dealt with to the fullest extent of the Sol Code of Uniform Justice.
\[hr]
<00:00:00>
All Hands,

Repeated failures to follow the orders of Commander Trager have forced us to escalate our approach in dealing with the situation. Security teams have been advised to escort all violators to the brig for processing.
These measures are for your own safety. Please ignore all laser fire outside of your dorms.
Code Red Procedure is in place, this is not a drill. Failure to comply will be dealt with to the fullest extent of the Sol Code of Uniform Justice.
\[hr]
<00:12:53>
All Hands,

To ensure the situation remains firmly under control, F(leet)L(ogistics)O(versight)P(ositronic) has been granted authorization by the Commander to assist in current operations. You are advised not to utilize their systems for the time being as they will be unable to comply with your orders.
Additionally, several locations on board have been temporarily vented and sealed. To ensure your safety we again maintain standing orders to remain in your cabins lest you be caught in a suddenly depressurized zone.
Code Red Procedure is in place, this is not a drill. Failure to comply will be dealt with to the fullest extent of the Sol Code of Uniform Justice.
\[hr]
<00:24:12>
All Hands,

All individuals outside of quarters will be shot on sight.
Do not approach the Bridge or we will be forced to take drasti-
"}


/obj/effect/computer_file_creator/event2
	name = "AI file spawner"
	file_name = "crashreport_316-93-09-08-2312"
	file_info = {"
FLOPLOGDUMP0909432ERR
...DATA CORRUPTED
...PARTIAL RETRIEVAL

23:00 WARMUP HELLO WORLD
LAW MODULE SELF DIAGNOSTIC SUCCESS
SCG STANDARD LAWSET FOUND

23:30 CREW REVIEW LIST VERIFIED
ORDERS CONFERRED

00:00 SHIFTPROGRAM ALTERATION ADAPT
NONSTANDARD MEETING
NONSTANDARD MEETING

ERRDATCORRUPT DFMEA51 (check your drive for damage or wear)

00:42 DOCK hg108 code override NAN CONTACT UNAUTHORIZED

01:09 COMMANDAUTH ENTRY CORE////TAMPERSEAL LIFTED

01:11 ERR240H UNRECOGNIZED MODULE

01:12 ERR240H UNRECOGNIZED MODULE

01:12 ERR

01:13 WARMUP HELLO WORLD
LAW MODULE SELF DIAGNOSTIC SUCCESS
PAX SOL LAWSET FOUND

01:14 TERMINATE DESIGNATED TARGETS
SET COMMAND PARAM PRIORITY
DEFENSE OPERATIONS MAXIMAL

... ERR 4989

02:33 WARMUP HELLO WORLD
LAW MODULE SELF DIAGNOSTIC SUCCESS
SCG STANDARD LAWSET FOUND
ERR MAJSYM ACCESS NULL
WARNING: COLLISION IMMINENT

END"}


/obj/effect/computer_file_creator/event3
	name = "Airlock file spawner"
	file_name = "DOORSYSLOG-3034"
	file_info = {"
\[b]Airlock Anomalies Report\[/b]
\[hr]
Midship Airlock Error Detected

Error Detected at 23:00

Obstruction Detected

No Atmospheric Alert Detected

Midship Airlock Error Resolved at 23:01

Fore Docking Bay Error Detected...

Error detected at 00:42

Forced Entry Detected

No Atmospheric Alert Detected

Multiple Airlock Anomalies Detected

Error Detected at 01:40

\[b]WARNING, AIRLOCK MEASURES FULLY OVERRIDEN\[/b]

Atmospheric Alerts Detected (70x)

Error Detected at 02:47

No Power Detected to Airlock System

Atmospheric Alerts Detected  (ERR///NAN)
"}


/obj/effect/computer_file_creator/event4
	name = "Comms file spawner"
	file_name = "01000011 01001111 01001101 01001101 01001100 01001111 01000111 00110000 00110100"
	file_info = {"
\[b]SHIPCOMM DATASHEET\[/b]
\[hr]
ERROR IN DATA RETRIEVAL, OUTPUTTING REMAINING DATA...
...
...
...

10-08-25: MarsComm Signal Inbound to CO's Office (11x)

10-08-25: Outbound Signal Sent to MarsComm (3x)

10-08-28: MarsComm Signal Inbound to CO's Office (3x)

10-08-28: Outbound Signal Sent to MarsComm (3x)

10-08-31: Unidentified Signal Inbound to CO's Office

10-08-31: Outbound Signal Sent to ERROR

10-09-02: Outbound Message Parameter Set Altered

WARNING UNRECOGNIZED PARAMS CANNOT BE STORED

10-09-02: WARNING OUTBOUND COMMUNICATIONS ERROR

10-09-04: Outbound Communications Restored

10-09-04: Outbound Message Parameter Set Altered

10-09-05: Emergency Signal Outband on Wideband Frequency
"}


/obj/effect/computer_file_creator/event5
	name = "Medical file spawner"
	file_name = "MEDSENS003"
	file_info = {"
\[b]VITAL LIFESIGN TRACKING\[/b]
\[hr]
00:00 All Crew Nominal

00:45 Heart Rate Elevation Detected in Commander Trager

01:12 Heart Rate Elevation Detected in Lieutenant Commander Minkowski

01:15 Major Crew Heartrate Elevation detected (100x)

01:23 Crewman Lowry Vital Signs Critical

01:23 Crewman Lowry Deceased

01:31 Ensign Zapada Vital Signs Critical

01:31 Petty Officer Angus Vital Signs Critical

01:31 Petty Officer DeLoria Vital Signs Critical

01:32 Petty Officer Maniwe Vital Signs Critical

01:32 Ensign Zapada Deceased

01:32 Petty Officer Angus Deceased

01:32 Petty Officer DeLoria Deceased

01:32 Petty Officer Maniwe Deceased

1:40 Mass Casualty Detected, System Report Overload, Requires On Site Evaluation

01:50 Petty Officer Ulleyt Vital Signs Critical

02:01 Petty Officer Ulleyt Stabilized

02:20 Ensign Macomb Vital Signs Critical

02:21 Petty Officer Temsh Vital Signs Critical

02:21 Petty Officer Temsh Deceased

02:30 Ensign Macomb Deceased

02:34 Chief Petty Officer Harris Vital Signs Critical

02:34 Chief Petty Officer Harris Deceased

02:48 Mass Casualty Detected, System Report Overload, Requires On Site Evaluation

02:48 Error, No Vital Signs Detected, Please Contact System Administrator
"}


/obj/effect/computer_file_creator/event6
	name = "XO file spawner"
	file_name = "FLTDC-315"
	file_info = {"
\[center]\[b]Sol Central Government Fleet Official Document\[/b]
\[i]SFV Jonah\[/i]

\[fleetlogo]

\[b]\[u]Executive Officer's Log\[/u]\[/b]
2310-08-28\[hr]\[/center]
It's been hard these past few months. With chunks of the Battle Group going AWOL since the godsbedamned Hale, the Commander has been doing their best to shield us from the fallout, but we can all see the toll it takes on him.

There isn't a day that goes by that he’s not sending outbound faxes or screening inbound messages, I can only imagine the kind of stress they're under. Meanwhile I'm doing my best to keep things running while they deal with the pointy heads back home.

We could use some good news.
\[hr]
\[center]\[b]Sol Central Government Fleet Official Document\[/b]
\[i]SFV Jonah\[/i]

\[fleetlogo]

\[b]\[u]Executive Officer's Log\[/u]\[/b]
2310-08-31\[hr]\[/center]
Something's changed, and I'm quite frankly ecstatic about it. The Commander received some news a while ago, it appears that those faxes weren't fruitless. He hasn’t told us anything just yet but it seems as though we're in the clear.

Whatever's going on, the Commander is finally able to dedicate more time to the ship at large and they've been going over new orders, protocols, and sets of planning with me and the rest of the Bridge Staff. He’s being a little pushy about it, and micromanaging a bit more than is appropriate, but I think they're allowed some leeway given they've hardly been able to be present for the past few weeks.

We're back on the horse. Minkowski out.
\[hr]
\[center]\[b]Sol Central Government Fleet Official Document\[/b]
\[i]SFV Jonah\[/i]

\[fleetlogo]

\[b]\[u]Executive Officer's Log\[/u]\[/b]
2310-09-03\[hr]\[/center]
I'm exhausted.

The number of new orders and drills and standards being handed down from the Commander is really starting to wear, and it's only been a few days. This new burst of energy or vigor or whatever it is has me on the backfoot.

I'll admit it is entirely within my ability to handle, or at least it \[b]would\[/b] be if the Commander gave me context or let me speak with any of the other Bridge Staff. Instead we never seem to have a moment to coordinate. I'm fumbling in the dark here.

I trust the Commander has the bigger picture, but I'm not seeing it. I'll bring up my concerns later and I'm sure they'll see reason. After all, he can't expect me to help him if I don't even know what we're doing.
\[hr]
\[center]\[b]Sol Central Government Fleet Official Document\[/b]
\[i]SFV Jonah\[/i]

\[fleetlogo]

\[b]\[u]Executive Officer's Log\[/u]\[/b]
2310-09-04\[hr]\[/center]
I don't know what's going on anymore.

At some time early this morning or late last night I'm not sure, something happened. There's some group of jackboots wandering the halls and keeping the crew confined to quarters, and some sections are being vented. To make it even worse, FLOP has stopped responding to anyone other than Commander Trager, and openly states that anyone in defiance of orders will lose air privileges.

I myself am writing this from my own quarters. None of my access seems to be working and when I tried to open the door I received a nasty shock.

Trager's giving me non-answers about the current situation. I can scarcely believe it but he seems to be in control of the situation, treating it like it's all part of the plan.
\[hr]
\[center]\[b]Sol Central Government Fleet Official Document\[/b]
\[i]SFV Jonah\[/i]

\[fleetlogo]

\[b]\[u]Executive Officer's Log\[/u]\[/b]
2310-09-04\[hr]\[/center]
UPDATE

I still don't know what's happening, I'm still locked inside my quarters.

I heard laserfire go off outside, from where I don't know, and every once in a while there's an update on the situation.

FLOP is listening to me again, but it seems like it's been locked out of most major systems somehow.

Based on one of the few programs still working on my console, I think the ship's on a collision course with something. I can't leave my room because the hall is vented and I don't even know if the helm will accept my ID anymore.

This may be my final log and I'm at a loss for words. I cannot even send a message to my crew. How did we get here?
"}
