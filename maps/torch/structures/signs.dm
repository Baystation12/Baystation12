/obj/structure/sign/dedicationplaque
	name = "\improper SEV Torch dedication plaque"
	desc = "S.E.V. Torch - Mako Class - Sol Expeditionary Corps Registry 95519 - Shiva Fleet Yards, Mars - First Vessel To Bear The Name - Launched 2560 - Sol Central Government - 'Never was anything great achieved without danger.'"
	icon = 'maps/torch/icons/obj/solgov-decals.dmi'
	icon_state = "lightplaque"

/obj/structure/sign/ecplaque
	name = "\improper Expeditionary Directives"
	desc = "A plaque with Expeditionary Corps logo etched in it."
	icon = 'maps/torch/icons/obj/solgov-decals.dmi'
	icon_state = "ecplaque"
	var/directives = {"<hr><center>
		1. <b>Exploring the unknown is your Primary Mission</b><br>

		You are to look for land and resources that can be used by Humanity to advance and prosper. Explore. Document. Explain. Knowledge is the most valuable resource.<br>

		2. <b>Every member of the Expeditionary Corps is an explorer</b><br>

		Some are Explorers by rank or position, but everyone has to be one when duty calls. You should always expect being assigned to an expedition if needed. You have already volunteered when you signed up.<br>

		3. <b>Danger is a part of the mission - avoid, not run away</b> <br>

		Keep your crew alive and hull intact, but remember - you are not here to sightsee. Dangers are obstacles to be cleared, not the roadblocks. Weigh risks carefully and keep your Primary Mission in mind.
		</center><hr>"}

/obj/structure/sign/ecplaque/examine()
	..()
	to_chat(usr, "The founding principles of EC are written there: <A href='?src=\ref[src];show_info=1'>Expeditionary Directives</A>")

/obj/structure/sign/ecplaque/CanUseTopic()
	return STATUS_INTERACTIVE

/obj/structure/sign/ecplaque/OnTopic(href, href_list)
	if(href_list["show_info"])
		to_chat(usr, directives)
		return TOPIC_HANDLED

/obj/effect/floor_decal/scglogo
	alpha = 230
	icon = 'maps/torch/icons/obj/solgov_floor.dmi'
	icon_state = "1,1"

/obj/structure/sign/solgov
	name = "\improper SolGov Seal"
	desc = "A sign which signifies who this vessel belongs to."
	icon = 'maps/torch/icons/obj/solgov-decals.dmi'
	icon_state = "solgovseal"

/obj/structure/sign/double/solgovflag
	name = "Sol Central Government Flag"
	desc = "The flag of the Sol Central Government, a symbol of many things to many people."
	icon = 'maps/torch/icons/obj/solgov-decals.dmi'

/obj/structure/sign/double/solgovflag/left
	icon_state = "solgovflag-left"

/obj/structure/sign/double/solgovflag/right
	icon_state = "solgovflag-right"
