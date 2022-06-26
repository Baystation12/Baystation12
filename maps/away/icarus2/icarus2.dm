#include "icarus2_areas.dm"
/obj/effect/overmap/visitable/sector/icarus2
	name = "arctic planetoid"
	desc = "Sensor array detects an arctic planet with degraded bluespace emission signatures. Sensors further dictate the presence of a big, crashed ship, and a smaller crashed shuttle."
	in_space = FALSE
	icon_state = "globe"
	initial_generic_waypoints = list(
		"nav_icarus2_1",
		"nav_icarus2_2",
		"nav_icarus2_3"
	)

/obj/effect/overmap/visitable/sector/icarus2/New(nloc, max_x, max_y)
	name = "[generate_planet_name()], \a [name]"
	..()

/datum/map_template/ruin/away_site/icarus2
	name = "Crashed Sol Exploration Vessel"
	id = "awaysite_icarus2"
	spawn_cost = 2
	description = "An arctic planet with a crashed Sol ship."
	suffixes = list("icarus2/icarus2-1.dmm","icarus2/icarus2-2.dmm")
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED
	generate_mining_by_z = 2

	area_usage_test_exempted_root_areas = list(/area/icarus2)
	apc_test_exempt_areas = list(
		/area/icarus2/underground = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/icarus2/ground = NO_SCRUBBER|NO_VENT|NO_APC
	)

/obj/effect/shuttle_landmark/nav_icarus2/nav1
	name = "Icarus Crash Site Landing Point A"
	landmark_tag = "nav_icarus2_1"
	base_area = /area/icarus2/ground

/obj/effect/shuttle_landmark/nav_icarus2/nav2
	name = "Icarus Crash Site Landing Point B"
	landmark_tag = "nav_icarus2_2"
	base_area = /area/icarus2/ground

/obj/effect/shuttle_landmark/nav_icarus2/nav3
	name = "Icarus Crash Site Landing Point C"
	landmark_tag = "nav_icarus2_3"
	base_area = /area/icarus2/ground

/obj/effect/computer_file_creator/icarus2_1
	name = "icarus file spawner - impact black box data dump"

/obj/effect/computer_file_creator/icarus2_1/Initialize()
	. = ..()
	file_name = "ICARUS BLACK BOX DATA DUMP PRESYSTEM CRASH 12 06 2306"
	file_info = " \
	<h2>SEV Icarus - Emergency Black Box Data Dump \
	<hr> \
	\<LOG\>: Orbit stabilized. Next correction burst, est.: 2 hrs 12 m<br>\
	\<LOG\>: Secondary orbit stabilization commencing. Announcing...<br>\
	\<ANN\>: Attention all hands, SEV Icarus is stabilizing orbit in 30 seconds. Prepare for possible gravitational spikes.<br>\
	\<LOG\>: Announcing complete.<br>\
	\<LOG\>: Preparing for burst: heating up impulse mass.<br>\
	\<LOG\>: Burst ready. Bursting in 5 seconds.<br>\
	\<LOG\>: Secondary orbit stabilized. Next correction burst, est.: 1 hr 47 m.<br>\
	\<LOG\>: Approaching rendezvous waypoint. Designated Station A-01.<br>\
	\<LOG\>: Maintaining orbit: ship thrusters now on stand-by.<br>\
	\<ADM\>: Preparing shuttles for landing. Current status: required refueling. <br>\
	\<REQ\>: Request to Engineering, Please refuel Shuttle #2... Sent.<br>\
	\<RET\>: Request completed.<br>\
	\<WARN\>: Multiple hull breaches detected.<br>\
	\<LOG\>: Severe damage: calculating automated hull integrity report.<br>\
	\<LOG\>: Calculating complete. Notify ADMIN...<br>\
	\<ERR\>: Ship superstructure currently under 70 percent! Prepare for emergency procedures.<br>\
	\<ERR\>: Ship superstructure currently under 70 percent! Prepare for emergency procedures.<br>\
	\<ERR\>: Ship superstructure currently under 70 percent! Prepare for emergency procedures.<br>\
	\<ERR\>: Ship superstructure currently under 70 percent! Prepare for emergency procedures.<br>\
	\<ERR\>: Ship superstructure currently under 70 percent! Prepare for emergency procedures.<br>\
	\<LOG\>: This error was muted for 120 seconds.<br>\
	\<WARN\>: Atmospheric Sensor Alert: Reactor Bay, Deck One.<br>\
	\<WARN\>: Atmospheric Sensor Alert: Security Bay, Deck One.<br>\
	\<WARN\>: Atmospheric Sensor Alert: Research Bay, Deck Two.<br>\
	\<WARN\>: Atmospheric Sensor Alert: Offices, Deck Two.<br>\
	\<WARN\>: Unexpected orbit change, calculating corrective burst.<br>\
	\<LOG\>: Preparing for burst: heating up impulse mass.<br>\
	\<ERR\>: Impulse mass: not found.<br>\
	\<ERR\>: Unable to gain engine speed: ship thrusters offline.<br>\
	\<WARN\>: Ship superstructure critical failure imminent. Research Bay, Offices, Deck Two compromised.<br>\
	\<WARN\>: Radiation Alert! Radiation spike detected in: Reactory Bay, Security Bay, Medical Bay, Cargo Bay.<br>\
	\<LOG\>: Orbit stabilizing: failed.<br>\
	\<WARN\>: Impact imminent... Preparing blackbox backup...<br>\
	\<LOG\>: Emergency shutdown!<br>\
	\<LOG\>: Now you can safely turn off your computer.<br>\
	"

/obj/effect/computer_file_creator/icarus2_2
	name = "icarus file spawner - impact ai log data dump"

/obj/effect/computer_file_creator/icarus2_2/Initialize()
	. = ..()
	file_name = "ICARUS AI LOG DATA DUMP 12 06 2306"
	file_info = " \
	<b>Automated Hull Integrity Report</b><br>\
	<hr> \
	<i>Report generated on 2306-05-25 at 08:49</i><br>\
	<b>HULL STATUS SUMMARY</b><br>\
	<hr> \
	>Critical Damage: Deck 1 Fore-Port Hullpoint; Deck 1 Mid-Port Hullpoint; Deck 1 Aft-Port Hullpoint; Deck 2 Fore-Port Hullpoint; Deck 2 Mid-Port Hullpoint; Deck 2 Aft-Port Hullpoint. Immediate repairs required to prevent loss of Deck 1 and Deck 2 interior structural integrity.<br>\
	>Moderate Damage: Deck 2 Fore-Starboard Hullpoint; Deck 2 Mid-Starboard Hullpoint; Deck 2 Aft-Starboard Hullpoint. Non-priority repairs due to confirmed atmosphere loss - repair after C-Class hullpoint damage is tended to in order to re-establish atmosphere and structural integrity on affected deck.<br>\
	>Light Damage: None.<br>\
	<b>HYPERSONIC MEASUREMENTS</b><br>\
	<hr> \
	>Hypersonic thickness sensors rendered non-functional. Re-boot system; if issue persists, check hypersonic sensors on the exterior of the hull.<br>\
	<b>RISK MATRIX ASSESSMENT</b> \
	>Risk to Deck 1 hull integrity deemed as HIGH near Fore-Port and Fore-Starboard hullpoints. Evacuation of ordinance is highly advised.<br>\
	>Risk to Deck 2 hull integrity deemed as VERY HIGH due to imminent collapse of all Port-side hullpoints. Additionally, risk of TOKAMAK reactor meltdown may cause further hull damage and irradiate areas beyond access. Immediate damage control advised to prevent decay of deck superstructure beyond recoverable levels.<br>\
	>Risk to all other decks deemed as MODERATE due to possibility of ship superstructure degradation, resulting in cascading damage.<br>\
	<b>RECOMMENDED ACTION</b><br>\
	<hr> \
	>Implement hull triage procedures and bring hardpoint damage to acceptable levels before taking any other repair actions.<br>\
	>Declare a ship-wide engineering emergency to prevent non-engineering crew from interfering with damaged areas.<br>\
	>Wake up all engineering personnel from cryogenic stasis if possible.<br>\
	>Deploy inflatables to M-Class damage areas after C-Class hullpoints are repaired.<br>\
	>Re-establish atmosphere on affected decks and proceed with regular post-emergency protocols.<br>\
	<hr> \
	<i>Licensed to Deimos Advanced Information Systems (DAIS) under one or more developer license agreements.  See the NOTICE file distributed with this work for additional information regarding copyright ownership.  DAIS licenses this file to you under the Deimos License, Version 2.0 (the 'License'); you may not use this file except in compliance with the License.  You may obtain a copy of the License at dais/license.dnet.</i><br>\
	<i>Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an AS IS BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the License for the specific language governing permissions and limitations under the License.</i>"

/obj/effect/computer_file_creator/icarus2_3
	name = "icarus file spawner - email transcript 0"

/obj/effect/computer_file_creator/icarus2_3/Initialize()
	. = ..()
	file_name = "ICARUS E-MAIL TRANSCRIPT  SERVICE  12 06 2306"
	file_info = " \
	<b>TITLE</b> Meals 4 Command<br>\
	<b>ORIGIN</b> andrea.lecia@icarus.ec.scg<br>\
	<b>RECIPIENT</b> ama.drovus@icarus.ec.scg<br>\
	<b>TIME</b> 05:47<br>\
	<b>MESSAGE</b> Hi Amanda! Sorry for the cryo systems waking you up this early in the morning, but we had a really important detour and we need all hands on deck to help us where needed, so it woke up a lot of the Service staff we have.<br>\
	The captain and commander have been awake for some time now and they've been digging a whole lot on this particular station, so I'm afraid they may be getting a bit hungry. Could you make something sweet for them to keep them focused? The pie you made while we were in GSC-907 was really great!<br>\
	If you could make it again I think they'd really appreciate it. Thanks in advance!<br>"

/obj/effect/computer_file_creator/icarus2_4
	name = "icarus file spawner - email transcript 1"

/obj/effect/computer_file_creator/icarus2_4/Initialize()
	. = ..()
	file_name = "ICARUS SAVED E-MAIL TRANSCRIPT  COMMAND  12 06 2306"
	file_info = " \
	<b>TITLE</b> (URGENT)<br>\
	<b>ORIGIN</b> a.peterson@icarus.ec.scg<br>\
	<b>RECIPIENT</b> semyon.anders@icarus.ec.scg, tokona@icarus.ec.scg, ap.trois@icarus.ec.scg, forb.rand@icarus.ec.scg, jozzi@icarus.ec.scg<br>\
	<b>TIME</b> 06:23<br>\
	<b>MESSAGE</b> While the station is busy calling up their Sol superiors, I've taken this opportunity to have Gordon print out the transcript of our conversation so far.<br>\
	Smuggler den in this area of space might not bode well, worse if it is the Confederates. The transcript will be with Rand, he will safe-keep it wherever he needs to. Once our relays are back online, he will fax it.<br>\
	We put off a possible signal source of a more established civilisation to re-route to this back-water planet. I'm trusting you, Semyon, and I aim to make sure this all goes accordingly and is worth the detour."

/obj/effect/computer_file_creator/icarus2_5
	name = "icarus file spawner - active crew manifest"

/obj/effect/computer_file_creator/icarus2_5/Initialize()
	. = ..()
	file_name = "ICARUS ACTIVE CREW MANIFEST  12 06 2306"
	file_info = "<center>\[solcrest]<BR>\
			<b>SEV Icarus</b><br>\
			Active Crew Roster - 05:01 - 12/06/2306</center><br>\
			<b>COMMAND</b><br>\
			\[list]\
			\[*]Commanding Officer: CDR. Alex Peterson\
			\[*]Executive Officer: LT. Semyon Anders \
			\[*]CMO: LT. Toko Nashamura\
			\[*]CE: ENS. Ari Trois\
			\[*]COS: LT. Rand Forbarra\
			\[*]CSO: LT. Carl Jozziliny\
			\[*]BO: ENS. Gordon Johnson\
			\[*]BO: ENS. Andrea Lecia\
			\[*]SCGR: Mr. Gavro Hendel\
			\[*]CL: Mx. Namine Xi\
			\[/list]<br>\
			<b>MEDICAL</b><br>\
			\[list]\
			\[*]Physician: ENS. John Fors\
			\[*]Nurse: XPL. Betty Laffer\
			\[*]Nurse: XPL. Matthew Daranesh\
			\[/list]<br>\
			<b>ENGINEERING</b><br>\
			\[list]\
			\[*]Engineer: XPL. Ronda Atkins\
			\[*]Engineer: XPL. Peter Napp\
			\[*]Engineer: XPL. Aiden Kallufe\
			\[/list]<br>\
			<b>SECURITY</b><br>\
			\[list]\
			\[*]BC: CXPL. Nuri Batyam\
			\[*]MAA: XPL. Benjamin Tho\
			\[*]MAA: XPL. Tetha-12\
			\[/list]<br>\
			<b>EXPLORATION</b><br>\
			\[list]\
			\[*]Pathfinder: ENS. Karylee Blair\
			\[*]Pilot: CXPL. Alex Warda\
			\[*]Explorer: SXPL. William Lions\
			\[*]Explorer: XPL. Hope Bafflow\
			\[*]Explorer: XPL. Yuri Meadows\
			\[list]\
			<b>SCIENCE</b><br>\
			\[list]\
			\[*]S. Researcher: ENS. Marka Kavlovski\
			\[*]Xenobotanist: ENS. Dali Bateko\
			\[*]Xenoarchaeologist: ENS. Williams Surkiate\
			\[*]Research Assistant: XPL. Henry Sila\
			\[list]"

/obj/effect/computer_file_creator/icarus2_6
	name = "icarus file spawner - chat transcript 0"

/obj/effect/computer_file_creator/icarus2_6/Initialize()
	. = ..()
	file_name = "ICARUS RECOVERED CHAT TRANSCRIPT MEDICAL 12 06 2306"
	file_info = " \
	\<05:36\> M477: bro\
	\<05:36\> BETTI: what's up\
	\<05:37\> M477: stressed, the captain ran out of his imidazoline again and he's fucking yelling at me instead of going to medical proper because he's too busy in the bridge or something, and im not in the mood to get chewed out\
	\<05:37\> BETTI: captain's prescription we literally cant get anywhere out here, he always goes on and on about it and i dont think he understands, we need like, another resupply for the chem machines\
	\<05:37\> BETTI: i dont know how many times i have to tell him that we just\
	\<05:37\> BETTI: CANT get it lmao\
	\<05:38\> BETTI: it's like talking to a brick wall\
	\<05:38\> M477: god i know right?? what the hell are we supposed to do\
	\<05:38\> M477: does he want us to kill someone for it because i'm pretty close to doing that\
	\<05:38\> M477: lol\
	\<05:38\> BETTI: you know that station that's been sitting in orbit? the one we cant contact\
	\<05:42\> M477: sorry, was grabbing some tea\
	\<05:43\> M477: yeah\
	\<05:43\> BETTI: 20 bucks says they have what we need\
	\<05:43\> M477: lets fly over and kick their shit in for it\
	\<05:43\> BETTI: with what guns???\
	\<05:44\> M477: we have like, a taser and i think some of the engineers can cook up a kickass air cannon\
	\<05:44\> BETTI: LMAO\
	\<05:44\> BETTI: DUDE ONE OF THEM TOTALLY WOULD DO THAT TOO\
	\<05:44\> M477: I KNOW\
	\<05:45\> BETTI: You remember when uhhhhhh\
	\<05:45\> BETTI: JACKSON he made a fucking pipe gun that shot steel BBs with phoron\
	\<05:47\> M477: YEAH I REMEMBER, THEY WERE PISSED\
	\<05:47\> M477: didn't the MAs fucking hound him for like a week straight for that, some shit about `Its dangerous and you shouldnt be doing it!!!!!` bitch the hull is made of TITANIUM\
	\<05:47\> M477: WHAT THE FUCK IS A STEEL BB GOING TO DO\
	\<05:47\> BETTI: theyre scared that its gonna mess up their uniform\
	\<05:47\> BETTI: you know how much they care about their berets\
	\<05:47\> BETTI: they would gut you if they found out you took their precious fancy hat\
	\<05:48\> M477: retuuurn the haaat or suffer my cuuuurse\
	\<05:48\> BETTI: LMAO\
	\<05:48\> BETTI: also AGUGHGH BRB SORRY\
	\<06:00\> M477: youre good\
	\<06:01\> BETTI: aiden is bitching at me\
	\<06:01\> BETTI: AGAIN\
	\<06:01\> BETTI: about some shit i really do not care about nor need to care about\
	\<06:01\> M477: ?\
	\<06:01\> BETTI: SO, SIT BACK\
	\<06:02\> BETTI: BECUASE THIS ONES A LONG ONE\
	\<06:02\> M477: oh boy\
	\<06:02\> BETTI: SO APPARENTLY were in orbit around the planet, right? and theres this unknown station kind of just chilling off to the left. literaly nothing its doing, its just chilling. petersons being peterson again and has him constantly watching it on the uhhhh, nav console. NO breaks\
	\<06:04\> BETTI: he only got off just now because he managed to grab one of his other friends to watch it so he could make me suffer instead lol\
	\<06:04\> BETTI: getting really sick of it\
	\<06:04\> M477: i mean his fears arent stupid are they? pattersons\
	\<06:04\> M477: imagine if a station just kind of popped out from around the back of the planet you were orbiting and refused all hailing? thats pretty ominous\
	\<06:04\> BETTI: dude, theyre a staiton\
	\<06:06\> BETTI: its almost impossible to NOT outrun a station, it literally\
	\<06:06\> BETTI: CANNOT move.\
	\<06:06\> M477: can you outrun a missile that can be launched in less than a minute, though\
	\<06:06\> BETTI: we have point defense\
	\<06:07\> BETTI: and its not my fucking problem anyways lmao\
	\<06:07\> BETTI: he keeps coming to me with his problems and i dont want to tell him to essentially fuck off because hes, you know, a higher rank than i am?? and i dont wanna get on his bad side\
	\<06:07\> M477: just\
	\<06:07\> M477: look\
	\<06:08\> M477: i dunno, man, but youve gotta shake him eventually, this isnt good for you\
	\<06:08\> M477: tell him respectfully that you have enough on your plate already dealing with every engineer that tries to get `creative` and accidentally loses a finger or two\
	\<06:09\> M477: and that hes going to have to go somewhere else to talk about that station and its ominous lurking\
	\<06:09\> BETTI: honestly i dont like it either if it counts for anything\
	\<06:09\> BETTI: i think im gonna tell him that, though\
	\<06:09\> BETTI: pray i dont get chewed out for it, right?\
	\<06:09\> M477: heres hoping\
	\<06:14\> BETTI: that went\
	\<06:14\> BETTI: a LOT better than I thought it would\
	\<06:14\> BETTI: also, update, apparently the station got closer to us. even MORE menacingly this time. or we got close to it. idk.\
	\<06:14\> BETTI: but\
	\<06:15\> BETTI: he seemed to understand actually and thats a lot more than i was expecting out of him\
	\<06:15\> M477: my prayers\
	\<06:15\> M477: they are the best\
	\<06:15\> BETTI: lmao\
	\<06:16\> BETTI: get to medbay\
	\<06:16\> BETTI: hes finally left me alone now so we can have a CUP OF TEA or smt\
	\<06:16\> M477: kk\
	"

/obj/effect/computer_file_creator/icarus2_7
	name = "icarus file spawner - chat transcript 1"

/obj/effect/computer_file_creator/icarus2_7/Initialize()
	. = ..()
	file_name = "ICARUS RECOVERED CHAT TRANSCRIPT SECURITY 12 06 2306"
	file_info = " \
	\<06:35\> nurib: received the transcript fax, forberra\
	\<06:36\> forberry: keep it closeby, laminate it if you have to. not even a single coffee stain on that paper.\
	\<06:36\> forberry: peterson thinks something's off, and trois agrees. if push comes to shove, we can ask supply for weapons.\
	\<06:40\> nurib: that bad? reading over it seems weird, just..\
	\<06:40\> nurib: not too awful. mybe they mismatched their sig keys\
	\<06:41\> forberry: fuck if i know, im running back from the bridge, i need two copies of that made and handed to me. i'll bring you a drink too.\
	\<06:41\> nurib: couldnt i just fax this straight to excomm for you, foreberra\
	\<06:42\> forberry: bluespace relay's malfunctioning. we aren't getting comms out, and that's what has trois troubled.\
	\<06:42\> forberry: im running past engineering now, need to speak to semyon for a bit, he's fixing the shuttles for exploration.\
	\<06:46\> nurib: this REALLY seems like a blue alert scenario, forberra\
	\<06:59\> nurib: the ship just shook what are you doing\
	\<07:08\> nurib: can you put your headset back on? semyon's asking for u\
	\<07:12\> nurib: im hearing atmos alarms and the doors are closing down forberra\
	\<07:16\> nurib: those are mass driver shots were being shot at forbera im teling the rest into vodisuit\
	\<07:22\> nurib: papers safe but i need u on comms before they hoot our tcoms out, bring me a vodsuit outside is overpressurising\
	\<07:34\> nurib: theres PHORON outside my offce rand the rest of the MAs are aay i dont have a voidsuit, say somethin on comms please\
	"

/obj/effect/computer_file_creator/icarus2_8
	name = "icarus file spawner - comms transcript 0"

/obj/effect/computer_file_creator/icarus2_8/Initialize()
	. = ..()
	file_name = "ICARUS RECOVERED INTERCOMM TRANSCRIPT ENGINEERING 12 06 2306"
	file_info = " <hr>\
	\<Engineering\> \<Kallufe.Aiden\> <unintelligible>--it, Trois! Peter's dying on the floor and I can't hail Betty or Matt. Radiation's over hundred I-Us!\
	\<Engineering\> \<Trois.Ari\> Try run and get Fors, but he's too busy. I cannot do much about the engine's radiation shielding-!\
	\<Engineering\> \<Trois.Ari\> I'm <unintelligible>-o hail Ronda, where did she /GO/!?\
	\<Engineering\> \<Anders.Semyon\> Ronda's helping get the Pasiphae to almost flight-ready status. The Minotaur's engines are gone, but the Pasiphae's reactor is active.\
	\<Engineering\> \<Trois.Ari\> Semyon I am trying to keep our engine <unintellegible> with more radiation. I need Ronda to help me here, /now/! I don't even know what's going on with the drive.\
	\<Engineering\> \<Anders.Semyon\> The Liaison's getting on the Pasiphae. I'm keeping a sizeable contingent here plus the cryogenics manifest to help you, the Representative and Liaison will be heading down planet.\
	\<Engineering\> \<Anders.Semyon\> The Icarus is doomed either ways, Trois. There's no two ways about it.\
	\<Engineering\> \<Trois.Ari\> Then /what/ do you want me to do-!?\
	\<Engineering\> \<Anders.Semyon\> Buy the people on the Icarus enough time for the Pasiphae to make trips to and from the surface so we can minimise casualties.\
	\<Engineering\> \<Trois.Ari\> There is /no/ way you can make that many trips, Semyon-\
	\<Engineering\> \<Anders.Semyon\> <unintelligible>--orry, Trois- the shuttle's getting ready to launch. See you on the other side.\
	\<Engineering\> \<Trois.Ari\> ---..Okay! Fine. Okay. I can- okay.. I can fix this, Semyon. --Aiden, I need you to bring me more plasteel and titanium from our deck two storage!\
	\<Engineering\> \<Trois.Ari\> Alright?\
	\<Engineering\> \<Trois.Ari\> --Aiden?\
	"

/obj/effect/computer_file_creator/icarus2_9
	name = "icarus file spawner - comms transcript 1"

/obj/effect/computer_file_creator/icarus2_9/Initialize()
	. = ..()
	file_name = "ICARUS RECOVERED INTERCOMM TRANSCRIPT COMMANDHAILING 12 06 2306"
	file_info = " \
	\<Hailing\> \<Anders.Semyon\> This is Lieutenant Semyon of the S-E-V Icarus, checking in on a seemingly unregistered station out here. Can I have your identification?\
	\<Hailing\> \<????\> --Right this is Seismography Station twenty-two Bee, designation Phaethon. Why is a Solar vessel infringing upon a Solar station's restricted space?\
	\<Hailing\> \<Anders.Semyon\> Huh? Solar registered? I'm unsure if your station signature transponder is damaged or not, but you are not broadcasting the right signal.\
	\<Hailing\> \<????\> <unintelligible>--E-V Icarus, maintain your distance from the station. We do not need your help.\
	\<Hailing\> \<Anders.Semyon\> We have capable engineering and science teams to help you with your transponder, Phaethon, are you s-\
	\<Hailing\> \<????\> -Keep your fucking distance, Icarus.\
	\<Hailing\> \<Anders.Semyon\> -Phaethon need I remind you that these comms are being recorded and monitored and /will/ be sent to ExComm for evaluation?\
	\<Hailing\> \<????\> --Icarus we er- we're having issues with our docking ports, docking is a no-go at this time-\
	\<Hailing\> \<Anders.Semyon\> Docking issues? We /just/ offered assistance. Our engineers are obviously EVA trained-- that's a poor excuse, Phaethon, what are you here for?\
	\<Hailing\> \<????\> We're a- seismography monitoring station for the local planet, Lieutenant-- I thought I made that cle-\
	\<Hailing\> \<Anders.Semyon\> And are you able to maybe impart some of your recent seismographical data? We'd definitely reciprocate.\
	\<Hailing\> \<????\> I'm uh- I'm afraid I cannot do that Lieutenant-- We have sensitive, proprietary, um, tectonics here.\
	\<Hailing\> \<Anders.Semyon\> ...Who am I speaking to, exactly?\
	\<Hailing\> \<????\> --Lieutenant O'Hara.\
	\<Hailing\> \<Anders.Semyon\> Lieutenant O'Hara- put me on line with your superior office?\
	\<Hailing\> \<?????\> This is Commander Jacobson of the Seismography Station twenty-two Bee. Lieutenant Semyon, what do you need-?\
	\<Hailing\> \<Anders.Semyon\> Verification of your alignment with Sol, commander, ma'am. So far all I've gotten are empty threats and ramblings.\
	\<Hailing\> \<?????\> Of course, Lieutenant Semyon. We will contact ExComm and get them to fax you all the needed verifications. Though you might have to wait, bluespace reception is spotty.\
	\<Hailing\> \<Anders.Semyon\> We have time, commander.\
	"

/obj/effect/computer_file_creator/icarus2_10
	name = "icarus file spawner - comms transcript 1"

/obj/effect/computer_file_creator/icarus2_10/Initialize()
	. = ..()
	file_name = "ICARUS RECOVERED SUPPLY LOG 12 06 2306"
	file_info = " \
	<h2>SEV Icarus - Pasiphae Flight Control Log \
	<hr> \
	\<ADM\>: Preparing shuttles for landing. Current status: required refueling. <br>\
	\<ALERT\>: Shuttle #2, `Pasiphae` requires refueling. Requesting Technician<br>\
	\<LOG\>: Attention: Fuel pump flow initiated. Please insert a canister.<br>\
	\<LOG\>: Canister detected, lock engaged. Releasing pump seals...<br>\
	\<LOG\>: Fueling complete. Please detach the canister. Fueling complete, please....<br>\
	\<LOG\>: Canister detached. Disabling pump flow<br>\
	\<ANN\>: All hands, anyone who's still listening, get to the Pasiphae. We've got a few minutes tops, , we've been <DATA CORRUPT>, get to the hangar, I said get to <DATA CORRUPT><br>\
	\<LOG\>: Announcing complete.<br>\
	\<LOG\>: Launch initialised. Commencing... <br>\
	\<ERR\>: Fuel leakage detected by Pasiphae <DATA CORRUPT>. Launch denied. Please resolve this issue! <br>\
	\<LOG\>: Force launch command received, launchin-<br>\
	\<ERR\>: Fuel leakage detected by Pasiphae <DATA CORRUPT>. Launch denied. Please resolve this issue!<br>\
	\<ERR\>: Error! Cannot recognise propulsion fuel, `Carbon Dioxide`. Denying release of fuel pump<br>\
	\<ERR\>: Error! Automatic seals on fuel hatch have been disengaged, please seal the hatch and-<br>\
	\<LOG\>: Re-entry fuel detected! Pressure reading: 1013.2 KPA. Atmospheric Composition: Hydrogen, 100%<br>\
	\<ANN\>: Anders, disengage the seals! Anders I said, disengage the airlock seals. Our people can't get in<br>\
	\<LOG\>: Propulsion fuel pump online. Re-entry fuel online. Pasiphae is takeoff ready, transmitting to flight control<br>\
	\<ADM\>: Attempting to restore power to Pasiphae airlock doors <br>\
	\<ERR\>: Error! Unable to restore power to Pasiphae subsystems. Please check for potential wiring or power issues<br>\
	\<WARN\>: Damage sustained to airlock door #1, possible damage to internal circuitry<br>\
	\<ANN\>: Atkins is trying to get you in, just hold on a little longer. <br>\
	\<WARN\>: SEV Icarus is losing orbit, ETA to de-orbit, three minutes<br>\
	\<LOG\>: Auxiliary generator activated, checking for issues...<br>\
	\<LOG\>: Auxiliary generator fully online, no issues detected<br>\
	\<LOG\>: Launch initialised. Commencing... <br>\
	\<ANN\>: What the fuck do you think you're doing? They're still out there you fuck! Atkins, kill that launch, kill that- <br>\
	\<LOG\>: Force launch command received. Launching <br>\
	\<LOG\>: Launch successful. Good luck on your survey mission, Pasiphae! <br>\
	"
