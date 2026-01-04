/obj/computer_file_creator/minnoe/atmos_tug
	name = "blackbox recording"

/obj/computer_file_creator/minnoe/atmos_tug/Initialize()  //credit to Karljohansson
	file_name = "NETMON_SENSORDUMP-BLACKBOX"
	file_info = " \
		\<03:12:34\> EXTREME HULL DEFORMATION DETECTED. BLACKBOX RECORDING SNIPPET ISOLATED.<br>\
		\<03:12:37\> HULL BREACH DETECTED IN: CARGO BAY. DISABLING SCRUBBERS.<br>\
		\<03:13:13\> HULL BREACH DETECTED IN: BRIDGE. DISABLING SCRUBBERS<br>\
		\<03:13:52\> SWAPPING TO UNINTERRUPTABLE POWER SUPPLY TO PERFORM SAFE SHUTDOWN OF AUXILIARY SYSTEMS.<br>\
		\<03:16:06\> COLLISION DETECTED. ATMOSPHERIC PROCESSING OFFLINE.<br>\
		\<03:16:06\> SEVERE DEVIATION FROM ASSIGNED HOVER POSITION DETECTED. AUTOMATICALLY FIRING REVERSE THRUST.<br>\
		\<03:16:07\> NO THRUSTER RESPONSE DETECTED.<br>\
		\<03:16:09\> LIDAR DETECTS LARGE OBJECT APPROACHING VESSEL. ESTIMATED COLLISION IN 9.33 SECONDS.<br>\
		\<03:16:18\> COLLISION DETECTED. ATMOSPHERIC PROCESSING OFFLINE.<br>\
		\<03:20:22\> POWER LEVEL CRITICAL. PUSHING SNIPPET TO HARD DRIVE."
	. = ..()

/obj/computer_file_creator/minnoe/boardingpod
	name = "boarding pod orders"

/obj/computer_file_creator/minnoe/boardingpod/Initialize()
	file_name = "Boarding_pod_orders"
	file_info = "\
		Lieutenant. Let me be clear; we need a win.<br><br>\
		We're running low on supplies and gas out here.<br>\
		This is a routine smash and grab- it's just an asteroid resort, we're not expecting anything serious here.<br>\
		We'll disable the Filly Myrrh with two precise railgun strikes, hitting the Bridge and the Cargo Bay.<br>\
		These should be light hits, but be prepared for venting once you depart.<br>\
		Once you impact, seize control of the ship and board the Resort. Take no prisoners.<br>\
		Space the bodies. Make offloading stations for the gas.<br>\
		Take anything valuable, even if it's nailed down.<br>\
		Happy Hunting, Lieutenant.<br>"
	. = ..()

/obj/item/paper/memo/minnoe
	name = "requisition logs"
	info = {"Back and forth requisition sheets between the Quarter Master and the Station Commander, a silent battle of paperwork. The Quartermaster complains in the margins about getting the best 'value' for Earhart."}

/obj/item/paper/memo/minnoe/commander
	name = "denied requisition logs"
	info = {"Back and forth requisition sheets between the Quarter Master and the Station Commander, a silent battle of paperwork. The Commander denied many requisition sheets, responding back about 'operating at a loss to get the most tech we can in the long term.'"}

/obj/item/paper/memo/minnoe/operatingguidelines
	name = "operating guidelines"
	info = {"A stack of operation guidelines, detailing the job of the various staff onboard the Asteroid Restort 'Minnoe'. All of the crew are actually Service Members belonging to the Free Peoples of Earhart, though their mission seems to be to.. run the best resport possible.?"}

/obj/item/paper/memo/minnoe/chef
	name = "Diner operating procedures"
	info = {"Various recipies for a kitchen and bar, with guidelines about meal times and portions. The food is heavily weighted towards spacer-types, and the booze menu demands the bartender steer patrons away from 'rationed' drink types as they get drunk. "}

/obj/item/paper/minnoe/roboticisit //credit to sirofsirs11
	name = "mech maintenance bay"
	info ="TO: COMMANDER NINEATEONE<br>\
		FROM: CORPORAL FOURTWOSIX<br>\
		<br><hr>\
		The printer's incomplete and just isn't cut out for what you're implying we can do with it.\
		Solar robotics are impressive, but all you've given me is maybe half of a printer and a heavily used circuit imprinter. Even if it did work more than a quarter of the time, I don't have the materials to make it work.\
		Just yesterday, I had a request to build a full exosuit, and they requested several parts I was unable to fabricate. I had to turn him down.<br><br>\
		Look, I'm not going to beat around the bush. We need to complete the workshop. We're simply not going to fool people into trading in their robotics when you claim we have a Sol-made printer when we have half a printer and some parts that the other engineer and I threw together that work almost like a Sol-made printer on a good day."

/obj/item/paper/minnoe
	name = "operation guidelines"
	info = "TO: LIUETENANT ONESEVENSIX <br>FROM: MAJOR SEVENTHREENINE<br><hr>\
			Liuetenant,<br><br>Your orders are to investigate the loss of contact with Minnoe Station. We lost contact and have been unable to raise them for several weeks now. I suspect the worst.<br><br>\
			Your mission objectives are as follows:<br><br>1. Investigate the loss of contact with Minnoe Station.<br>2. Contact any survivors and deal with any ongoing emergencies.<br>3. Fax a report back to me requesting further instructions.<br><br>\
			We cannot afford to lose the asset that is Minnoe Station.<br><br>Out."

/obj/item/paper/memo/minnoe/commander/instructions
	name = "requisition logs"
	info = {"The operations logs of the Station Commander, detailing much about their goals and desires. This is an Free-People-of-Earhart operation, bartering for Sol or GCC based tech with spacer-types on a high-end, exclusive resort. The crew outnumber patrons, and the station is operating at a loss, intentionally?"}

/obj/item/paper/memo/minnoe/bridge
	name = "patron reservations"
	info = {"Dates and timetables for almost a dozen past patron stays, with several more in the future- before the stations untimely demise. The Bridge crew here seems to be catering to Spacer-crewed ships of 12 or so, offering high-end R&R and fuel resupply for very cheap barter."}

/obj/item/paper/memo/minnoe/rnrpatrons
	name = "patrons compliments"
	info = {"Handfuls of compliments and positive reports from past patrons, praising the 'incredible value' and 'customer focused' experience onboard this Resort. Judging by the way these are filed, it seems they're escalated to someone higher up and off the station."}

/obj/item/paper/memo/minnoe/gashauler
	name = "thrust mass refuel"
	info = {"Billing from a commerical gas hauler, bringing in thrust-mass and atmosphere to the Resort. The Station Quartermaster is trying to haggle the Hauler down, seems they're pretty stingy on hard Sol or GCC cash. The Hauler, the ITU Filly Myrrh, seem antsy about staying for too long, citing 'security concerns'."}

/obj/item/paper/memo/minnoe/engineering
	name = "engineering department setup"
	info = {"Complaints from the on-station Engineer, stapled to startup and design paperwork for the Engineering bay. The FPE-trained Engineer is lamenting the high-quality components found in the engineering bay, citing difficulty maintaining the foreign tech. His comments about the 'second hand' nature of the equipment leaves little to the imagination- this equipment was Pirated off a ship somewhere."}

/obj/item/paper/memo/minnoe/departuretimeline
	name = "departure timeline"
	info = {"The departure logs for the patrons who were present when the station was attacked. The crew was 3 days from departure onboard the 'ITV Vagrant', a light freighter that was docked on the west spoke."}

/obj/item/paper/memo/minnoe/foodorders
	name = "food orders"
	info = {"Food orders being taken from patrons in the North-East Spoke Garden, just as the station was being attacked. Orders of synth-eggs and red-kibble left unfulfilled."}

/obj/item/paper/memo/minnoe/stockroom
	name = "Stockroom inventory"
	info = {"Stockroom inventory sheets, detailing how many weeks the station can keep operating with on-hand supplies. The stockroom was very stocked at the time of the attack- but more curiously, it seems the station was recieving routine supplies from an FTU-based Merchantman. The crew went to great lengths to hide their FPE-origins from the FTU ship."}

/obj/item/paper/memo/minnoe/medical
	name = "Doctors reports"
	info = {"Doctors reports from the on-station doctor. Between treatment reports of 'Patrons' you see comments sent to the station Commander, lamenting the 'wasting' of externally smuggled medical supplies on the patrons. The Doctor seemed to want to take the Sol-origin medical supplies and send them home, declaring the pressing need on the home front."}

/obj/item/paper/memo/minnoe/nouniform
	name = "Crew Dress Code"
	info = {"Dress code from the Station Commander- personally ordering all crew to space their FPE uniforms and Badges. The great lengths they went through to hide their origins seems to have been undone by the proud crew wearing their smuggled uniforms, in a sense of mis-begotten pride."}

/obj/item/paper/memo/minnoe/excavation
	name = "excavation logs"
	info = {"excavation logs from a 'Patron' who begged the crew to allow him to excavate something he'd seen on an outlying asteroid to the north-west, near the Diner. The price he paid was high- proprietary NT-based research tech."}

/obj/item/paper/memo/minnoe/hiddendock
	name = "hidden dock inventory"
	info = {"The inventory sheet from a hidden dock, on Minnoe Resort's south-east side. The incoming and outgoing inventory is well detailed, but the actual identity of the fence or pirate is missing. The incoming shipments are undoubtably Sol-based, comprised of Tech, Medicine and Ship equipment, paid for with transfers of less-valuable barter goods from the Quartermaster's department. Most of the payments are the timetables of the departing crews and their ships- someone was double-dealing. Some of the medical shipments are overstocked with narcotics- someone was was hiding those from the Quartermaster."}
