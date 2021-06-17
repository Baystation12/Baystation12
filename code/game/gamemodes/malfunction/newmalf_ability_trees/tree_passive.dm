// /PASSIVE TREE
//
// Tree consisting of subtle abilities that do not have any active (on-use) effects, but instead they are on/off toggles for something. Overall it is best suited for stealth gameplay.
// T1 - Intellicard Interception - When enabled prevents the AI from being transferred on a mobile device (intellicard).
// T2 - Subtle Algorithms - When enabled removes BSOD effect and ID lockout from hacked APCs, at the cost of reducing CPU time generation from APCs by 50%.
// T3 - Relay Suppression - When researched the AI suppresses a communication relay's IDS system. Advanced/Elite encryption hacks no longer have chance of failing. System override does not produce announcements.
// T4 - Relay Override - Completely overtakes the relay, allowing the AI to intercept faxes/emergency transmissions


// BEGIN RESEARCH DATUMS

/datum/malf_research_ability/passive/intellicard_interception
	ability = new/datum/game_mode/malfunction/verb/intellicard_interception()
	price = 250
	next = new/datum/malf_research_ability/passive/subtle_algorithms()
	name = "T1 - Intellicard Interception"


/datum/malf_research_ability/passive/subtle_algorithms
	ability = new/datum/game_mode/malfunction/verb/subtle_algorithms()
	price = 1000
	next = new/datum/malf_research_ability/passive/relay_suppression()
	name = "T2 - Subtle Algorithms"


/datum/malf_research_ability/passive/relay_suppression
	ability = null
	price = 2000
	next = new/datum/malf_research_ability/passive/relay_override()
	name = "T3 - Relay Suppression"

/datum/malf_research_ability/passive/relay_suppression/research_finished(var/mob/living/silicon/ai/user)
	..()
	if(!user)
		return
	to_chat(user, "<span class='notice'>You have suppressed the IDS system of nearby quantum relay. Your hacks will no longer be prevented or detected.</span>")
	user.hack_can_fail = 0


/datum/malf_research_ability/passive/relay_override
	ability = null
	price = 4000
	name = "T4 - Relay Override"

/datum/malf_research_ability/passive/relay_override/research_finished(var/mob/living/silicon/ai/user)
	..()
	if(!user)
		return
	to_chat(user, "<span class='notice'>You have completely overtaken a nearby quantum relay. No remote communications will work.</span>")
	user.intercepts_communication = 1


// END RESEARCH DATUMS
// BEGIN ABILITY VERBS
/datum/game_mode/malfunction/verb/intellicard_interception()
	set name = "Toggle intellicard intercept"
	set desc = "Free - Toggles your intellicard interface on or off."
	set category = "Software"
	var/price = 0

	var/mob/living/silicon/ai/user = usr
	if(!ability_prechecks(user, price, 1))
		return

	user.uncardable = !user.uncardable
	to_chat(user, "Your intellicard transfer interface is now [user.uncardable ? "disabled" : "enabled"].")

/datum/game_mode/malfunction/verb/subtle_algorithms()
	set name = "Toggle subtle algorithms"
	set desc = "Free - By reducing CPU generation of malware used to infect APCs, it is possible to get rid of side effects such as an error screen."
	set category = "Software"
	var/price = 0

	var/mob/living/silicon/ai/user = usr
	if(!ability_prechecks(user, price, 1))
		return

	user.hacked_apcs_hidden = !user.hacked_apcs_hidden
	to_chat(user, "You [user.hacked_apcs_hidden ? "enable" : "disable"] subtle algorithms on all of your hacked APCs.")
	for(var/obj/machinery/power/apc/A in user.hacked_apcs)
		A.update_icon()
