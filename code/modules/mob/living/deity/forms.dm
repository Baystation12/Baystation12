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
	var/list/struct_vars = list()
	var/list/icon_states = list()

/datum/god_form/New(var/mob/living/deity/D)
	D.feats += name
	D.icon_state = god_icon_state
	D.desc = desc
	linked_god = D

/datum/god_form/proc/sync_structure(var/obj/O)
	var/list/svars = struct_vars[O.type]
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
		<font color='blue'>+Can gain power from blood sacrifices.<br></font>
	<b>Drawbacks:</b><br>
		<font color='red'>-Servant abilities require host's blood and flesh.</font>
	"}
	desc = "A being made of a million nightmares, a billion deaths."
	god_icon_state = "narsie"
	pylon_icon_state = "shade"
	faction = "cult"

	struct_vars = list(/obj/structure/deity/altar = list("name" = "altar",
														"desc" = "A small desk, covered in blood.",
														"icon_state" = "talismanaltar"),
					/turf/simulated/floor/deity = list("name" = "disturbing smooth surface")
					)

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

	struct_vars = list(/obj/structure/deity/altar = list("name" = "Biopit",
														"desc" = "A mass of flesh and gas"),
					/turf/simulated/floor/deity = list("name" = "a fleshy surface")
					)