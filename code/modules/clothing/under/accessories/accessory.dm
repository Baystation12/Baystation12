/obj/item/clothing/accessory
	name = "tie"
	desc = "A neosilk clip-on tie."
	icon = 'icons/obj/clothing/ties.dmi'
	icon_state = "bluetie"
	item_state = ""	//no inhands
	slot_flags = SLOT_TIE
	w_class = ITEM_SIZE_SMALL
	var/slot = "decor"
	var/obj/item/clothing/has_suit = null		//the suit the tie may be attached to
	var/image/inv_overlay = null	//overlay used when attached to clothing.
	var/list/mob_overlay = list()
	var/overlay_state = null
	var/list/accessory_icons = list(slot_w_uniform_str = 'icons/mob/ties.dmi')
	sprite_sheets = list("Resomi" = 'icons/mob/species/resomi/ties.dmi') // for species where human variants do not fit

/obj/item/clothing/accessory/Destroy()
	on_removed()
	return ..()

/obj/item/clothing/accessory/proc/get_inv_overlay()
	if(!inv_overlay)
		var/tmp_icon_state = overlay_state? overlay_state : icon_state
		if(icon_override && ("[tmp_icon_state]_tie" in icon_states(icon_override)))
			inv_overlay = image(icon = icon_override, icon_state = "[tmp_icon_state]_tie", dir = SOUTH)
		else
			inv_overlay = image(icon = default_onmob_icons[slot_tie_str], icon_state = tmp_icon_state, dir = SOUTH)
	inv_overlay.color = color
	return inv_overlay

/obj/item/clothing/accessory/get_mob_overlay(mob/user_mob, slot)
	if(!istype(loc,/obj/item/clothing/))	//don't need special handling if it's worn as normal item.
		return ..()
	var/bodytype = "Default"
	if(ishuman(user_mob))
		var/mob/living/carbon/human/user_human = user_mob
		if(user_human.species.get_bodytype(user_human) in sprite_sheets)
			bodytype = user_human.species.get_bodytype(user_human)

		var/tmp_icon_state = overlay_state? overlay_state : icon_state
		var/use_sprite_sheet = accessory_icons[slot]
		if(sprite_sheets[bodytype])
			use_sprite_sheet = sprite_sheets[bodytype]

		if(icon_override && ("[tmp_icon_state]_mob" in icon_states(icon_override)))
			return overlay_image(icon_override, "[tmp_icon_state]_mob", color, RESET_COLOR)
		else
			return overlay_image(use_sprite_sheet, tmp_icon_state, color, RESET_COLOR)

//when user attached an accessory to S
/obj/item/clothing/accessory/proc/on_attached(var/obj/item/clothing/S, var/mob/user)
	if(!istype(S))
		return
	has_suit = S
	forceMove(has_suit)
	has_suit.overlays += get_inv_overlay()

	if(user)
		to_chat(user, "<span class='notice'>You attach \the [src] to \the [has_suit].</span>")
		src.add_fingerprint(user)

/obj/item/clothing/accessory/proc/on_removed(var/mob/user)
	if(!has_suit)
		return
	has_suit.overlays -= get_inv_overlay()
	has_suit = null
	if(user)
		usr.put_in_hands(src)
		src.add_fingerprint(user)
	else
		src.forceMove(get_turf(src))

//default attackby behaviour
/obj/item/clothing/accessory/attackby(obj/item/I, mob/user)
	..()

//default attack_hand behaviour
/obj/item/clothing/accessory/attack_hand(mob/user as mob)
	if(has_suit)
		return	//we aren't an object on the ground so don't call parent
	..()

/obj/item/clothing/accessory/blue
	name = "blue tie"
	icon_state = "bluetie"

/obj/item/clothing/accessory/red
	name = "red tie"
	icon_state = "redtie"

/obj/item/clothing/accessory/blue_clip
	name = "blue tie with a clip"
	icon_state = "bluecliptie"

/obj/item/clothing/accessory/red_long
	name = "red long tie"
	icon_state = "redlongtie"

/obj/item/clothing/accessory/black
	name = "black tie"
	icon_state = "blacktie"

/obj/item/clothing/accessory/yellow
	name = "yellow tie"
	icon_state = "yellowtie"

/obj/item/clothing/accessory/navy
	name = "navy tie"
	icon_state = "navytie"

/obj/item/clothing/accessory/horrible
	name = "horrible tie"
	desc = "A neosilk clip-on tie. This one is disgusting."
	icon_state = "horribletie"

/obj/item/clothing/accessory/brown
	name = "brown tie"
	icon_state = "browntie"

/obj/item/clothing/accessory/stethoscope
	name = "stethoscope"
	desc = "An outdated medical apparatus for listening to the sounds of the human body. It also makes you look like you know what you're doing."
	icon_state = "stethoscope"

/obj/item/clothing/accessory/stethoscope/attack(mob/living/carbon/human/M, mob/living/user)
	if(ishuman(M) && isliving(user))
		if(user.a_intent == I_HELP)
			var/body_part = parse_zone(user.zone_sel.selecting)
			if(body_part)
				var/their = "their"
				switch(M.gender)
					if(MALE)	their = "his"
					if(FEMALE)	their = "her"

				var/sound = "heartbeat"
				var/sound_strength = "cannot hear"
				var/heartbeat = 0
				var/obj/item/organ/internal/heart/heart = M.internal_organs_by_name[BP_HEART]
				if(heart && !(heart.robotic >= ORGAN_ROBOT))
					heartbeat = 1
				if(M.stat == DEAD || (M.status_flags&FAKEDEATH))
					sound_strength = "cannot hear"
					sound = "anything"
				else
					switch(body_part)
						if(BP_CHEST)
							sound_strength = "hear"
							sound = "no heartbeat"
							if(heartbeat)
								if(heart.is_bruised() || M.getOxyLoss() > 50)
									sound = "[pick("odd noises in","weak")] heartbeat"
								else
									sound = "healthy heartbeat"

							var/obj/item/organ/internal/lungs/L = M.internal_organs_by_name[BP_LUNGS]
							if(!L || M.losebreath)
								sound += " and no respiration"
							else if(M.is_lung_ruptured() || M.getOxyLoss() > 50)
								sound += " and [pick("wheezing","gurgling")] sounds"
							else
								sound += " and healthy respiration"
						if(BP_EYES,BP_MOUTH)
							sound_strength = "cannot hear"
							sound = "anything"
						else
							if(heartbeat)
								sound_strength = "hear a weak"
								sound = "pulse"

				user.visible_message("[user] places [src] against [M]'s [body_part] and listens attentively.", "You place [src] against [their] [body_part]. You [sound_strength] [sound].")
				return
	return ..(M,user)


//Medals
/obj/item/clothing/accessory/medal
	name = "medal"
	desc = "A simple medal."
	icon_state = "bronze"

/obj/item/clothing/accessory/medal/iron
	name = "iron medal"
	desc = "A simple iron medal."
	icon_state = "iron"
	item_state = "iron"

/obj/item/clothing/accessory/medal/iron/star
	name = "iron star medal"
	desc = "An iron star awarded to members of the SCG for meritorious achievement or service in a combat zone."
	icon_state = "iron_star"

/obj/item/clothing/accessory/medal/iron/nanotrasen
	name = "\improper NanoTrasen merit medal"
	desc = "An iron medal awarded to NanoTrasen employees for merit."
	icon_state = "iron_nt"

/obj/item/clothing/accessory/medal/iron/sol
	name = "\improper Sol expeditionary medal"
	desc = "An iron medal awarded to members of the SCG for service outside of the borders of the Sol Central Government."
	icon_state = "iron_sol"

/obj/item/clothing/accessory/medal/bronze
	name = "bronze medal"
	desc = "A simple bronze medal."
	icon_state = "bronze"
	item_state = "bronze"

/obj/item/clothing/accessory/medal/bronze/heart
	name = "bronze heart medal"
	desc = "A bronze heart awarded to members of the SCG for injury or death in the line of duty."
	icon_state = "bronze_heart"

/obj/item/clothing/accessory/medal/bronze/nanotrasen
	name = "\improper NanoTrasen sciences medal"
	desc = "A bronze medal awarded to NanoTrasen employees for signifigant contributions to the fields of science or engineering."
	icon_state = "bronze_nt"

/obj/item/clothing/accessory/medal/bronze/sol
	name = "\improper Sol defensive operations medal"
	desc = "A bronze medal awarded for members of the SCG for service defending the border regions."
	icon_state = "bronze_sol"

/obj/item/clothing/accessory/medal/silver
	name = "silver medal"
	desc = "A simple silver medal."
	icon_state = "silver"
	item_state = "silver"

/obj/item/clothing/accessory/medal/silver/sword
	name = "combat action medal"
	desc = "A silver medal awarded to members of the SCG for honorable service while under enemy fire."
	icon_state = "silver_sword"

/obj/item/clothing/accessory/medal/silver/nanotrasen
	name = "\improper NanoTrasen service medal"
	desc = "A silver medal awarded to NanoTrasen employees for distinguished service in support of corporate interests."
	icon_state = "silver_nt"

/obj/item/clothing/accessory/medal/silver/sol
	name = "\improper Sol valor medal"
	desc = "A silver medal awarded for members of the SCG for acts of exceptional valor."
	icon_state = "silver_sol"

/obj/item/clothing/accessory/medal/gold
	name = "gold medal"
	desc = "A simple gold medal."
	icon_state = "gold"
	item_state = "gold"

/obj/item/clothing/accessory/medal/gold/star
	name = "gold star medal"
	desc = "A gold star awarded to members of the SCG for acts of heroism in a combat zone."
	icon_state = "gold_star"

/obj/item/clothing/accessory/medal/gold/sun
	name = "solar service medal"
	desc = "A gold medal awarded to members of the SCG by the Secretary General for significant contributions to the Sol Central Government."
	icon_state = "gold_sun"

/obj/item/clothing/accessory/medal/gold/crest
	name = "solar honor medal"
	desc = "A gold medal awarded to members of the Defense Forces by the Secretary General for personal acts of valor and heroism above and beyond the call of duty."
	icon_state = "gold_crest"

/obj/item/clothing/accessory/medal/gold/nanotrasen
	name = "\improper NanoTrasen command medal"
	desc = "A gold medal awarded to NanoTrasen employees for service as the Captain of a NanoTrasen facility, station, or vessel."
	icon_state = "gold_nt"

/obj/item/clothing/accessory/medal/gold/sol
	name = "\improper Sol sapientarian medal"
	desc = "A gold medal awarded for members of the SCG for significant contributions to sapient rights."
	icon_state = "gold_sol"

/obj/item/clothing/accessory/medal/heart
	name = "medical medal"
	desc = "A white heart emblazoned with a red cross awarded to members of the SCG for service as a medical professional in a combat zone."
	icon_state = "white_heart"

//Ribbons
/obj/item/clothing/accessory/ribbon
	name = "ribbon"
	desc = "A simple military decoration."
	icon_state = "ribbon_marksman"

/obj/item/clothing/accessory/ribbon/marksman
	name = "marksmanship ribbon"
	desc = "A military decoration awarded to members of the SCG for good marksmanship scores in training. Common in the days of energy weapons."
	icon_state = "ribbon_marksman"

/obj/item/clothing/accessory/ribbon/peace
	name = "peacekeeping ribbon"
	desc = "A military decoration awarded to members of the SCG for service during a peacekeeping operation."
	icon_state = "ribbon_peace"

/obj/item/clothing/accessory/ribbon/frontier
	name = "frontier ribbon"
	desc = "A military decoration awarded to members of the SCG for service along the frontier."
	icon_state = "ribbon_frontier"

/obj/item/clothing/accessory/ribbon/instructor
	name = "instructor ribbon"
	desc = "A military decoration awarded to members of the SCG for service as an instructor."
	icon_state = "ribbon_instructor"

//Specialty Pins
/obj/item/clothing/accessory/specialty
	name = "speciality blaze"
	desc = "A color blaze denoting fleet personnel in some special role. This one is silver."
	icon_state = "marinerank_command"

/obj/item/clothing/accessory/specialty/janitor
	name = "custodial blazes"
	desc = "Purple blazes denoting a custodial technician."
	icon_state = "fleetspec_janitor"

/obj/item/clothing/accessory/specialty/brig
	name = "brig blazes"
	desc = "Red blazes denoting a brig officer."
	icon_state = "fleetspec_brig"

/obj/item/clothing/accessory/specialty/forensic
	name = "forensics blazes"
	desc = "Steel blazes denoting a forensic technician."
	icon_state = "fleetspec_forensic"

/obj/item/clothing/accessory/specialty/atmos
	name = "atmospherics blazes"
	desc = "Turquoise blazes denoting an atmospheric technician."
	icon_state = "fleetspec_atmos"

/obj/item/clothing/accessory/specialty/counselor
	name = "counselor blazes"
	desc = "Blue blazes denoting a counselor."
	icon_state = "fleetspec_counselor"

/obj/item/clothing/accessory/specialty/chemist
	name = "chemistry blazes"
	desc = "Orange blazes denoting a chemist."
	icon_state = "fleetspec_chemist"

/obj/item/clothing/accessory/specialty/enlisted
	name = "enlisted qualification pin"
	desc = "An iron pin denoting some special qualification."
	icon_state = "fleetpin_enlisted"

/obj/item/clothing/accessory/specialty/officer
	name = "officer's qualification pin"
	desc = "A golden pin denoting some special qualification."
	icon_state = "fleetpin_officer"

//Ranks
/obj/item/clothing/accessory/rank
	name = "ranks"
	desc = "Insignia denoting rank of some kind. These appear blank."
	icon_state = "fleetrank"
	slot = "rank"

/obj/item/clothing/accessory/rank/fleet
	name = "naval ranks"
	desc = "Insignia denoting naval rank of some kind. These appear blank."
	icon_state = "fleetrank"

/obj/item/clothing/accessory/rank/fleet/enlisted
	name = "ranks (crewman recruit)"
	desc = "Insignia denoting the rank of Crewman Recruit."
	icon_state = "fleetrank_enlisted"

/obj/item/clothing/accessory/rank/fleet/enlisted/e2
	name = "ranks (crewman apprentice)"
	desc = "Insignia denoting the rank of Crewman Apprentice."

/obj/item/clothing/accessory/rank/fleet/enlisted/e3
	name = "ranks (crewman)"
	desc = "Insignia denoting the rank of Crewman."

/obj/item/clothing/accessory/rank/fleet/enlisted/e4
	name = "ranks (petty officer third class)"
	desc = "Insignia denoting the rank of Petty Officer Third Class."

/obj/item/clothing/accessory/rank/fleet/enlisted/e5
	name = "ranks (petty officer second class)"
	desc = "Insignia denoting the rank of Petty Officer Second Class."

/obj/item/clothing/accessory/rank/fleet/enlisted/e6
	name = "ranks (petty officer first class)"
	desc = "Insignia denoting the rank of Petty Officer First Class."

/obj/item/clothing/accessory/rank/fleet/enlisted/e7
	name = "ranks (chief petty officer)"
	desc = "Insignia denoting the rank of Chief Petty Officer."

/obj/item/clothing/accessory/rank/fleet/enlisted/e8
	name = "ranks (senior chief petty officer)"
	desc = "Insignia denoting the rank of Senior Chief Petty Officer."

/obj/item/clothing/accessory/rank/fleet/enlisted/e9
	name = "ranks (master chief petty officer)"
	desc = "Insignia denoting the rank of Master Chief Petty Officer."

/obj/item/clothing/accessory/rank/fleet/officer
	name = "ranks (ensign)"
	desc = "Insignia denoting the rank of Ensign."
	icon_state = "fleetrank_officer"

/obj/item/clothing/accessory/rank/fleet/officer/o2
	name = "ranks (lieutenant junior grade)"
	desc = "Insignia denoting the rank of Lieutenant Junior Grade."

/obj/item/clothing/accessory/rank/fleet/officer/o3
	name = "ranks (lieutenant ranks)"
	desc = "Insignia denoting the rank of Lieutenant."

/obj/item/clothing/accessory/rank/fleet/officer/o4
	name = "ranks (lieutenant commander)"
	desc = "Insignia denoting the rank of Lieutenant Commander."

/obj/item/clothing/accessory/rank/fleet/officer/o5
	name = "ranks (commander)"
	desc = "Insignia denoting the rank of Commander."

/obj/item/clothing/accessory/rank/fleet/officer/o6
	name = "ranks (captain)"
	desc = "Insignia denoting the rank of Captain."
	icon_state = "fleetrank_command"

/obj/item/clothing/accessory/rank/fleet/flag
	name = "ranks (rear admiral lower half)"
	desc = "Insignia denoting the rank of Rear Admiral Lower Half."
	icon_state = "fleetrank_command"

/obj/item/clothing/accessory/rank/fleet/flag/o8
	name = "ranks (rear admiral upper half)"
	desc = "Insignia denoting the rank of Rear Admiral Upper Half."

/obj/item/clothing/accessory/rank/fleet/flag/o9
	name = "ranks (vice admiral)"
	desc = "Insignia denoting the rank of Vice Admiral."

/obj/item/clothing/accessory/rank/fleet/flag/o10
	name = "ranks (admiral)"
	desc = "Insignia denoting the rank of Admiral."

/obj/item/clothing/accessory/rank/marine
	name = "marine ranks"
	desc = "Insignia denoting marine rank of some kind. These appear blank."
	icon_state = "marinerank_enlisted"

/obj/item/clothing/accessory/rank/marine/enlisted
	name = "ranks (private)"
	desc = "Insignia denoting the rank of Private."
	icon_state = "marinerank_enlisted"

/obj/item/clothing/accessory/rank/marine/e2
	name = "ranks (private first class)"
	desc = "Insignia denoting the rank of Private First Class."

/obj/item/clothing/accessory/rank/marine/e3
	name = "ranks (lance corporal)"
	desc = "Insignia denoting the rank of Lance Corporal."

/obj/item/clothing/accessory/rank/marine/e4
	name = "ranks (corporal)"
	desc = "Insignia denoting the rank of Corporal."

/obj/item/clothing/accessory/rank/marine/e5
	name = "ranks (sergeant)"
	desc = "Insignia denoting the rank of Sergeant."

/obj/item/clothing/accessory/rank/marine/e6
	name = "ranks (staff sergeant)"
	desc = "Insignia denoting the rank of Staff Sergeant."

/obj/item/clothing/accessory/rank/marine/e7
	name = "ranks (gunnery sergeant)"
	desc = "Insignia denoting the rank of Gunnery Sergeant."

/obj/item/clothing/accessory/rank/marine/e8
	name = "ranks (master sergeant)"
	desc = "Insignia denoting the rank of Master Sergeant."

/obj/item/clothing/accessory/rank/marine/e8alt
	name = "ranks (first sergeant)"
	desc = "Insignia denoting the rank of First Sergeant."

/obj/item/clothing/accessory/rank/marine/e9
	name = "ranks (master gunnery sergeant)"
	desc = "Insignia denoting the rank of Master Gunnery Sergeant."

/obj/item/clothing/accessory/rank/marine/e9alt
	name = "ranks (sergeant major)"
	desc = "Insignia denoting the rank of Sergeant Major."

/obj/item/clothing/accessory/rank/marine/officer
	name = "ranks (second lieutenant)"
	desc = "Insignia denoting the rank of Second Lieutenant."
	icon_state = "marinerank_officer"

/obj/item/clothing/accessory/rank/marine/officer/o2
	name = "ranks (first lieutenant)"
	desc = "Insignia denoting the rank of First Lieutenant."

/obj/item/clothing/accessory/rank/marine/officer/o3
	name = "ranks (captain)"
	desc = "Insignia denoting the rank of Captain."

/obj/item/clothing/accessory/rank/marine/officer/o4
	name = "ranks (major)"
	desc = "Insignia denoting the rank of Major."

/obj/item/clothing/accessory/rank/marine/officer/o5
	name = "ranks (lieutenant commander)"
	desc = "Insignia denoting the rank of Lieutenant Commander."

/obj/item/clothing/accessory/rank/marine/officer/o6
	name = "ranks (colonel)"
	desc = "Insignia denoting the rank of Colonel."

/obj/item/clothing/accessory/rank/marine/flag
	name = "ranks (brigadier general)"
	desc = "Insignia denoting the rank of Brigadier General."
	icon_state = "marinerank_command"

/obj/item/clothing/accessory/rank/marine/flag/o8
	name = "ranks (major general)"
	desc = "Insignia denoting the rank of Major General."

/obj/item/clothing/accessory/rank/marine/flag/o9
	name = "ranks (lieutenant general)"
	desc = "Insignia denoting the rank of lieutenant general."

/obj/item/clothing/accessory/rank/marine/flag/o10
	name = "ranks (general)"
	desc = "Insignia denoting the rank of General."


//Necklaces
/obj/item/clothing/accessory/necklace
	name = "necklace"
	desc = "A simple necklace."
	icon_state = "necklace"
	slot_flags = SLOT_MASK | SLOT_TIE


//Misc
/obj/item/clothing/accessory/kneepads
	name = "kneepads"
	desc = "A pair of synthetic kneepads. Doesn't provide protection from more than arthritis."
	icon_state = "kneepads"

//Scarves
/obj/item/clothing/accessory/scarf
	name = "scarf"
	desc = "A stylish scarf. The perfect winter accessory for those with a keen fashion sense, and those who just can't handle a cold breeze on their necks."
	icon_state = "whitescarf"
