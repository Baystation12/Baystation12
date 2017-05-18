/*A god form basically is a combination of a sprite sheet choice and a gameplay choice.
Each plays slightly different and has different challenges/benefits
*/

/datum/god_form
	var/name = "Form"
	var/info = "This is a form your being can take."
	var/desc = "This is the mob's description given."
	var/faction = "neutral" //For stuff like mobs and shit
	var/god_icon_state //What you look like
	var/pylon_icon_state //What image shows up when appearing in a pylon
	var/mob/living/deity/linked_god = null
	var/floor_decl = /decl/flooring/reinforced/cult
	var/list/buildables = list() //Both a list of var changes and a list of buildables.
	var/list/icon_states = list()
	var/list/starting_feats //This is used to give different forms different starting trees

/datum/god_form/New(var/mob/living/deity/D)
	D.feats += name
	D.icon_state = god_icon_state
	D.desc = desc
	linked_god = D
	if(starting_feats)
		for(var/feat in starting_feats)
			D.feats |= feat

/datum/god_form/proc/sync_structure(var/obj/O)
	var/list/svars = buildables[O.type]
	if(!svars)
		return
	for(var/V in svars)
		O.vars[V] = svars[V]

/datum/god_form/proc/take_charge(var/mob/living/user, var/charge)
	return 1

/datum/god_form/Destroy()
	if(linked_god)
		linked_god.form = null
		linked_god = null
	return ..()

/datum/god_form/narsie
	name = "Nar-Sie"
	info = {"The Geometer of Blood, you crave blood and destruction.<br>
	<b>Benefits:</b><br>
		<font color='blue'>+Can gain power from blood sacrifices.<br>
		+Ability to forge weapons and armor.</font>
	<b>Drawbacks:</b><br>
		<font color='red'>-Servant abilities require copious amounts of their blood.</font>
	"}
	desc = "A being made of a million nightmares, a billion deaths."
	god_icon_state = "nar-sie"
	pylon_icon_state = "shade"
	faction = "cult"

	buildables = list(/obj/structure/deity/altar = list("name" = "altar",
														"desc" = "A small desk, covered in blood.",
														"icon_state" = "talismanaltar"),
					/obj/structure/deity/pylon,
					/turf/simulated/floor/deity = list("name" = "disturbing smooth surface")
					)

	starting_feats = list(DEITY_FORM_DARK_ART, DEITY_FORM_BLOOD_SAC, DEITY_FORM_DARK_MINION, DEITY_FORM_BLOOD_FORGE)

/datum/god_form/narsie/take_charge(var/mob/living/user, var/charge)
	if(!..())
		return 0
	if(prob(charge))
		to_chat(user, "<span class='warning'>You feel drained...</span>")
	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.should_have_organ(BP_HEART))
			H.vessel.remove_reagent("blood", charge)
	else
		user.adjustBruteLoss(charge)
	return 1

/* Obelisk:
This form is an off shoot of nar-sie.
Benefits:
	+ Get power via sacrifice
	+ Hardier structures
*/

/datum/god_form/narsie/obelisk
	name = "Obelisk"
	info = {"You are the accumulation of all things maddening and unnatural.<br>
	<b>Benefits:</b><br>
		<font color='blue'>+Can gain power from blood sacrifices<br>
		+Hardier structures<br>
		+Unique Mind-Bending Structures</font><br>
	<b>Drawbacks:</b><br>
		<font color='red'>-Servant abilities require both blood and sanity.</font>"}
	desc = "Looking at it makes your brain itch."
	pylon_icon_state = "glowing_behemoth"
	faction = "obelisk"

	buildables = list(/obj/structure/deity/altar = list("health" = 50),
					/obj/structure/deity/pylon = list("health" = 45),
					/turf/simulated/floor/deity
					)
	starting_feats = list(DEITY_FORM_BLOOD_SAC)

/*Vampire:
This form is another off-shoot of nar-sie.
Benefits:
	+Vampire Tree
Drawbacks:
	-No sac
*/
/datum/god_form/narsie/vampire
	name = "Vampire"
	info = {"You are the embodiment of greed: feeding on the destruction of others for your own gain.<br>
	<b>Benefits:</b><br>
		<font color='blue'>+Ability to forge weapons and armor.<br>
		+Unique blood-syphoning tree</font><br>
	<b>Drawbacks:</b><br>
		<font color='red'>-Servant abilities require copious amounts of their blood.</font>
	"}

/datum/god_form/wizard
	name = "The Tower"
	info = {"Only from destruction does the Tower grow. Its bricks smelted from crumbled ignorance and the fires of ambition.<br>
	<b>Benefits:</b><br>
		<font color='blue'>+Learn spells from a miadra of different schools.<br></font><br>
	<b>Drawbacks:</b><br>
		<font color='red'>-Abilities hold a single charge and must be charged at their school's structure.</font>
	"}
	desc = "A single solitary tower"
	pylon_icon_state = "nim"

	buildables = list(/obj/structure/deity/altar = list("icon_state" = "tomealtar"),
					/obj/structure/deity/pylon,
					/turf/simulated/floor/deity
					)
/* Hive-Mind:
This form is all about base-building and defense. Unlike other forms it does not blend in at all and as such must be defended at all costs.
Benefits:
	+ Unique defense structures
	+ Spell's unique cost regenerates over time.
Drawbacks:
	- Out of place structures
	- Most spells must be used near a unique structure.
*/
/datum/god_form/hive
	name = "Hive-Mind"
	info = {"A biological mother-brain that uses a maidra of chemicals and parasites to control and augment its hosts.<br>
	<b>Benefits:</b><br>
		<font color='blue'>+ Unique defensive and utility structures</font><br>
	<b>Drawbacks:</b><br>
		<font color='red'>- Overt and out of place structures<br>
		- Most servant abilities require chemicals syphoned from a buildable structure.</font>
	"}
	desc = "Ew, looks like shit."
	god_icon_state = "biomass"
	pylon_icon_state = "horror"

	buildables = list(/obj/structure/deity/altar = list("name" = "Biopit",
														"desc" = "A mass of flesh and gas"),
					/turf/simulated/floor/deity = list("name" = "a fleshy surface")
					)