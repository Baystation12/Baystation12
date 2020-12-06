/datum/codex_entry/bodyscanner
	associated_paths = list(/obj/machinery/bodyscanner)
	mechanics_text = "The advanced scanner detects and reports internal injuries such as bone fractures, internal bleeding, and organ damage. \
	This is useful if you are about to perform surgery.<br>\
	<br>\
	Click your target with Grab intent, then click on the scanner to place them in it. Click the red terminal to operate. \
	Right-click the scanner and click 'Eject Occupant' to remove them.  You can enter the scanner yourself in a similar way, using the 'Enter Body Scanner' \
	verb."

/datum/codex_entry/cryocell
	associated_paths = list(/obj/machinery/atmospherics/unary/cryo_cell)
	mechanics_text = "The cryogenic chamber, or 'cryo', treats most damage types, most notably genetic damage. It also stabilizes patients \
	in critical condition by placing them in stasis, so they can be treated at a later time.<br>\
	<br>\
	In order for it to work, it must be loaded with chemicals, and the temperature of the solution must reach a certain point. Additionally, it \
	requires a supply of pure oxygen, provided by canisters that are attached. The most commonly used chemicals in the chambers are Cryoxadone and \
	Clonexadone. Clonexadone is more effective in treating all damage, including Genetic damage, but is otherwise functionally identical.<br>\
	<br>\
	Activating the freezer nearby, and setting it to a temperature setting below 150, is recommended before operation! Further, any clothing the patient \
	is wearing that act as an insulator will reduce its effectiveness, and should be removed.<br>\
	<br>\
	Clicking the tube with a beaker full of chemicals in hand will place it in its storage to distribute when it is activated.<br>\
	<br>\
	Click your target with Grab intent, then click on the tube, with an empty hand, to place them in it. Click the tube again to open the menu. \
	Press the button on the menu to activate it. Once they have reached 100 health, right-click the cell and click 'Eject Occupant' to remove them. \
	Remember to turn it off, once you've finished, to save power and chemicals!"

/datum/codex_entry/optable
	associated_paths = list(/obj/machinery/optable)
	mechanics_text = "Click your target with Grab intent, then click on the table with an empty hand, to place them on it.<br>Click on table after that to enable knockout function."

/datum/codex_entry/operating
	associated_paths = list(/obj/machinery/computer/operating)
	mechanics_text = "This console gives information on the status of the patient on the adjacent operating table, notably their consciousness."

/datum/codex_entry/sleeper
	associated_paths = list(/obj/machinery/sleeper)
	mechanics_text = "The sleeper allows you to clean the blood by means of dialysis, and to administer medication in a controlled environment.<br>\
	<br>\
	Click your target with Grab intent, then click on the sleeper to place them in it. Click the green console, with an empty hand, to open the menu. \
	Click 'Start Dialysis' to begin filtering unwanted chemicals from the occupant's blood. The beaker contained will begin to fill with their \
	contaminated blood, and will need to be emptied when full.<br>\
	There's similar function for ingested reagents, 'Stomach Pump'.<br>\
	<br>\
	You can also inject common medicines directly into their bloodstream.\
	<br>\
	Right-click the cell and click 'Eject Occupant' to remove them.  You can enter the cell yourself by right clicking and selecting 'Enter Sleeper'. \
	Note that you cannot control the sleeper while inside of it."

/datum/codex_entry/cryobag_furled
	associated_paths = list(/obj/item/bodybag/cryobag)
	mechanics_text = "This stasis bag will preserve the occupant, stopping most forms of harm from occuring, such as from oxygen \
	deprivation, irradiation, shock, and chemicals inside the occupant, at least until the bag is opened again.<br>\
	<br>\
	Stasis bags can only be used once, and are rather costly, so use them well.  They are ideal for situations where someone may die \
	before being able to bring them back to safety, or if they are in a hostile enviroment, such as in vacuum or in a toxins leak, as \
	the bag will protect the occupant from most outside enviromental hazards.  If you open a bag by mistake, closing the bag with no \
	occupant will not use up the bag, and you can pick it back up.<br>\
	<br>\
	You can use a health analyzer to scan the occupant's vitals without opening the bag by clicking the occupied bag with the analyzer."

/datum/codex_entry/cryobag_open
	associated_paths = list(/obj/structure/closet/body_bag/cryobag)
	mechanics_text = "This stasis bag will preserve the occupant, stopping most forms of harm from occuring, such as from oxygen \
	deprivation, irradiation, shock, and chemicals inside the occupant, at least until the bag is opened again.<br>\
	<br>\
	Stasis bags can only be used once, and are rather costly, so use them well.  They are ideal for situations where someone may die \
	before being able to bring them back to safety, or if they are in a hostile enviroment, such as in vacuum or in a toxins leak, as \
	the bag will protect the occupant from most outside enviromental hazards.  If you open a bag by mistake, closing the bag with no \
	occupant will not use up the bag, and you can pick it back up.<br>\
	<br>\
	You can use a health analyzer to scan the occupant's vitals without opening the bag by clicking the occupied bag with the analyzer."

/datum/codex_entry/autopump
	associated_paths = list(/obj/item/auto_cpr/)
	mechanics_text = "This automatic pump will help a patient whose heart is stopped, much like CPR, when put in the patient's suit slot.<br>\
	<br>\
	There are several things to keep in mind when using it. First off, you need Basic Medicine AND Anatomy skills to align it properly, otherwise it'll hurt patient. \
	It will only provide some circulation, you need to fix blood volume and oxygen supply issues for it to be useful. \
	It performs worse than manual CPR by a skilled user and will NOT restart the heart. It's advantage is automatic nature.<br>"