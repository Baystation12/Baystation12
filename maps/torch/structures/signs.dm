/obj/structure/sign/dedicationplaque
	name = "\improper TRCV Sandros dedication plaque"
	icon_state = "lightplaque"

/obj/structure/sign/dedicationplaque/Initialize()
	. = ..()
	desc = "T.R.C.V. Sandros - Yammato Class - Terran Defence Force Registry 19512 - Hidekio Prefecture , Earth - First Vessel To Bear The Name - Launched [game_year-37] - Terran Amalgamated Republics - 'We walk into darkness, fear, and death. But remember,when death is closing fast. It's when you try your hardest, for the darkness will not last.'"

/obj/structure/sign/ecplaque
	name = "\improper Sandros Mission Directives"
	desc = "A plaque with the Terran Crest etched in it."
	icon = 'maps/torch/icons/obj/solgov-decals.dmi'
	icon_state = "ecplaque"
	var/directives = {"<hr><center>
		1. <b>Settlement Colonization is your primary directive.</b><br>

		You are to look for a suitable location, particularly one that can sustain human life if at all possible with a minimal of terraforming, and colonize it to report back to Terra.<br>

		2. <b>Every Man, Woman, Soldier, or Child aboard is a colonist.</b><br>

		Some are Colonists by rank, but everyone has to be one when you find home. It takes all hands on deck to bring us to a location we can thrive in. You're responsible for your future.<br>

		3. <b>Danger is a part of the mission - avoid, not run away</b> <br>

		Keep your crew alive and hull intact, but remember - you are not here to sightsee. Dangers are obstacles to be cleared, not the roadblocks. Weigh risks carefully and keep your Primary Mission in mind.
		</center><hr>"}

/obj/structure/sign/ecplaque/examine()
	..()
	to_chat(usr, "The founding principles of Sandros Mission are written there: <A href='?src=\ref[src];show_info=1'>Sandros Mission Directives</A>")

/obj/structure/sign/ecplaque/CanUseTopic()
	return STATUS_INTERACTIVE

/obj/structure/sign/ecplaque/OnTopic(href, href_list)
	if(href_list["show_info"])
		to_chat(usr, directives)
		return TOPIC_HANDLED

/obj/structure/sign/ecplaque/attackby(var/obj/I, var/mob/user)
	if(istype(I, /obj/item/grab))
		var/obj/item/grab/G = I
		if(!ishuman(G.affecting))
			return
		G.affecting.apply_damage(5, BRUTE, BP_HEAD, used_weapon="Metal Plaque")
		visible_message("<span class='warning'>[G.assailant] smashes [G.assailant] into \the [src] face-first!</span>")
		playsound(get_turf(src), 'sound/weapons/tablehit1.ogg', 50)
		to_chat(G.affecting, "<span class='danger'>[directives]</span>")
		admin_attack_log(user, G.affecting, "educated victim on \the [src].", "Was educated on \the [src].", "used \a [src] to educate")
		G.force_drop()
	else
		..()

/obj/effect/floor_decal/scglogo
	alpha = 230
	icon = 'maps/torch/icons/obj/solgov_floor.dmi'
	icon_state = "center"

/obj/structure/sign/solgov
	name = "\improper TAR Seal"
	desc = "A sign which signifies who this vessel belongs to."
	icon = 'maps/torch/icons/obj/solgov-decals.dmi'
	icon_state = "solgovseal"

/obj/structure/sign/double/solgovflag
	name = "TAR Flag"
	desc = "The flag of the TAR, a symbol of many things to many people."
	icon = 'maps/torch/icons/obj/solgov-decals.dmi'

/obj/structure/sign/double/solgovflag/left
	icon_state = "solgovflag-left"

/obj/structure/sign/double/solgovflag/right
	icon_state = "solgovflag-right"
