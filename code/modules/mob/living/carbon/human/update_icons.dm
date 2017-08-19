/*
	Global associative list for caching humanoid icons.
	Index format m or f, followed by a string of 0 and 1 to represent bodyparts followed by husk fat hulk skeleton 1 or 0.
	TODO: Proper documentation
	icon_key is [species.race_key][g][husk][fat][hulk][skeleton][s_tone]
*/
var/global/list/human_icon_cache = list()
var/global/list/tail_icon_cache = list() //key is [species.race_key][r_skin][g_skin][b_skin]
var/global/list/light_overlay_cache = list()

/proc/overlay_image(icon,icon_state,color,flags)
	var/image/ret = image(icon,icon_state)
	ret.color = color
	ret.appearance_flags = flags
	return ret

	///////////////////////
	//UPDATE_ICONS SYSTEM//
	///////////////////////
/*
Calling this  a system is perhaps a bit trumped up. It is essentially update_clothing dismantled into its
core parts. The key difference is that when we generate overlays we do not generate either lying or standing
versions. Instead, we generate both and store them in two fixed-length lists, both using the same list-index
(The indexes are in update_icons.dm): Each list for humans is (at the time of writing) of length 19.
This will hopefully be reduced as the system is refined.

	var/overlays_lying[19]			//For the lying down stance
	var/overlays_standing[19]		//For the standing stance

When we call update_icons, the 'lying' variable is checked and then the appropriate list is assigned to our overlays!
That in itself uses a tiny bit more memory (no more than all the ridiculous lists the game has already mind you).

On the other-hand, it should be very CPU cheap in comparison to the old system.
In the old system, we updated all our overlays every life() call, even if we were standing still inside a crate!
or dead!. 25ish overlays, all generated from scratch every second for every xeno/human/monkey and then applied.
More often than not update_clothing was being called a few times in addition to that! CPU was not the only issue,
all those icons had to be sent to every client. So really the cost was extremely cumulative. To the point where
update_clothing would frequently appear in the top 10 most CPU intensive procs during profiling.

Another feature of this new system is that our lists are indexed. This means we can update specific overlays!
So we only regenerate icons when we need them to be updated! This is the main saving for this system.

In practice this means that:
	everytime you fall over, we just switch between precompiled lists. Which is fast and cheap.
	Everytime you do something minor like take a pen out of your pocket, we only update the in-hand overlay
	etc...


There are several things that need to be remembered:

>	Whenever we do something that should cause an overlay to update (which doesn't use standard procs
	( i.e. you do something like l_hand = /obj/item/something new(src) )
	You will need to call the relevant update_inv_* proc:
		update_inv_head()
		update_inv_wear_suit()
		update_inv_gloves()
		update_inv_shoes()
		update_inv_w_uniform()
		update_inv_glasse()
		update_inv_l_hand()
		update_inv_r_hand()
		update_inv_belt()
		update_inv_wear_id()
		update_inv_ears()
		update_inv_s_store()
		update_inv_pockets()
		update_inv_back()
		update_inv_handcuffed()
		update_inv_wear_mask()

	All of these are named after the variable they update from. They are defined at the mob/ level like
	update_clothing was, so you won't cause undefined proc runtimes with usr.update_inv_wear_id() if the usr is a
	slime etc. Instead, it'll just return without doing any work. So no harm in calling it for slimes and such.


>	There are also these special cases:
		update_mutations()	//handles updating your appearance for certain mutations.  e.g TK head-glows
		UpdateDamageIcon()	//handles damage overlays for brute/burn damage //(will rename this when I geta round to it)
		update_body()	//Handles updating your mob's icon to reflect their gender/race/complexion etc
		update_hair()	//Handles updating your hair overlay (used to be update_face, but mouth and
																			...eyes were merged into update_body)
		update_targeted() // Updates the target overlay when someone points a gun at you

>	All of these procs update our overlays_lying and overlays_standing, and then call update_icons() by default.
	If you wish to update several overlays at once, you can set the argument to 0 to disable the update and call
	it manually:
		e.g.
		update_inv_head(0)
		update_inv_l_hand(0)
		update_inv_r_hand()		//<---calls update_icons()

	or equivillantly:
		update_inv_head(0)
		update_inv_l_hand(0)
		update_inv_r_hand(0)
		update_icons()

>	If you need to update all overlays you can use regenerate_icons(). it works exactly like update_clothing used to.

>	I reimplimented an old unused variable which was in the code called (coincidentally) var/update_icon
	It can be used as another method of triggering regenerate_icons(). It's basically a flag that when set to non-zero
	will call regenerate_icons() at the next life() call and then reset itself to 0.
	The idea behind it is icons are regenerated only once, even if multiple events requested it.

This system is confusing and is still a WIP. It's primary goal is speeding up the controls of the game whilst
reducing processing costs. So please bear with me while I iron out the kinks. It will be worth it, I promise.
If I can eventually free var/lying stuff from the life() process altogether, stuns/death/status stuff
will become less affected by lag-spikes and will be instantaneous! :3

If you have any questions/constructive-comments/bugs-to-report/or have a massivly devestated butt...
Please contact me on #coderbus IRC. ~Carn x
*/

//Human Overlays Indexes/////////
#define MUTATIONS_LAYER			1
#define DAMAGE_LAYER			2
#define SURGERY_LEVEL			3		//bs12 specific.
#define UNDERWEAR_LAYER         4
#define UNIFORM_LAYER			5
#define ID_LAYER				6
#define SHOES_LAYER				7
#define GLOVES_LAYER			8
#define BELT_LAYER				9
#define SUIT_LAYER				10
#define TAIL_LAYER				11		//bs12 specific. this hack is probably gonna come back to haunt me
#define GLASSES_LAYER			12
#define BELT_LAYER_ALT			13
#define SUIT_STORE_LAYER		14
#define BACK_LAYER				15
#define HAIR_LAYER				16		//TODO: make part of head layer?
#define EARS_LAYER				17
#define FACEMASK_LAYER			18
#define HEAD_LAYER				19
#define COLLAR_LAYER			20
#define HANDCUFF_LAYER			21
#define L_HAND_LAYER			22
#define R_HAND_LAYER			23
#define FIRE_LAYER				24		//If you're on fire
#define TARGETED_LAYER			25		//BS12: Layer for the target overlay from weapon targeting system
#define TOTAL_LAYERS			25
//////////////////////////////////

/mob/living/carbon/human
	var/list/overlays_standing[TOTAL_LAYERS]
	var/previous_damage_appearance // store what the body last looked like, so we only have to update it if something changed

//UPDATES OVERLAYS FROM OVERLAYS_LYING/OVERLAYS_STANDING
//this proc is messy as I was forced to include some old laggy cloaking code to it so that I don't break cloakers
//I'll work on removing that stuff by rewriting some of the cloaking stuff at a later date.
/mob/living/carbon/human/update_icons()
	lying_prev = lying	//so we don't update overlays for lying/standing unless our stance changes again
	update_hud()		//TODO: remove the need for this
	overlays.Cut()

	if (icon_update)

		if(cloaked)

			icon = 'icons/mob/human.dmi'
			icon_state = "blank"

			for(var/entry in list(overlays_standing[R_HAND_LAYER], overlays_standing[L_HAND_LAYER]))
				if(istype(entry, /image))
					overlays += entry
				else if(istype(entry, /list))
					for(var/inner_entry in entry)
						overlays += inner_entry

			if(species.has_floating_eyes)
				overlays |= species.get_eyes(src)

		else

			icon = stand_icon
			icon_state = null

			for(var/entry in overlays_standing)
				if(istype(entry, /image))
					overlays += entry
				else if(istype(entry, /list))
					for(var/inner_entry in entry)
						overlays += inner_entry
			if(species.has_floating_eyes)
				overlays |= species.get_eyes(src)

	var/matrix/M = matrix()
	if(lying && !species.prone_icon) //Only rotate them if we're not drawing a specific icon for being prone.
		M.Turn(90)
		M.Scale(size_multiplier)
		M.Translate(1,-6)
	else
		M.Scale(size_multiplier)
		M.Translate(0, 16*(size_multiplier-1))
	transform = M

var/global/list/damage_icon_parts = list()

//DAMAGE OVERLAYS
//constructs damage icon for each organ from mask * damage field and saves it in our overlays_ lists
/mob/living/carbon/human/UpdateDamageIcon(var/update_icons=1)
	// first check whether something actually changed about damage appearance
	var/damage_appearance = ""

	if(!species.damage_overlays || !species.damage_mask)
		return

	for(var/obj/item/organ/external/O in organs)
		if(O.is_stump())
			continue
		damage_appearance += O.damage_state

	if(damage_appearance == previous_damage_appearance)
		// nothing to do here
		return

	previous_damage_appearance = damage_appearance

	var/image/standing_image = image(species.damage_overlays, icon_state = "00")

	// blend the individual damage states with our icons
	for(var/obj/item/organ/external/O in organs)
		if(O.is_stump())
			continue

		O.update_damstate()
		O.update_icon()
		if(O.damage_state == "00") continue
		var/icon/DI
		var/use_colour = ((O.robotic >= ORGAN_ROBOT) ? SYNTH_BLOOD_COLOUR : O.species.get_blood_colour(src))
		var/cache_index = "[O.damage_state]/[O.icon_name]/[use_colour]/[species.get_bodytype(src)]"
		if(damage_icon_parts[cache_index] == null)
			DI = new /icon(species.get_damage_overlays(src), O.damage_state)			// the damage icon for whole human
			DI.Blend(new /icon(species.get_damage_mask(src), O.icon_name), ICON_MULTIPLY)	// mask with this organ's pixels
			DI.Blend(use_colour, ICON_MULTIPLY)
			damage_icon_parts[cache_index] = DI
		else
			DI = damage_icon_parts[cache_index]

		standing_image.overlays += DI

	overlays_standing[DAMAGE_LAYER]	= standing_image

	if(update_icons)   update_icons()

//BASE MOB SPRITE
/mob/living/carbon/human/proc/update_body(var/update_icons=1)
	var/husk_color_mod = rgb(96,88,80)
	var/hulk_color_mod = rgb(48,224,40)

	var/husk = (HUSK in src.mutations)
	var/fat = (FAT in src.mutations)
	var/hulk = (HULK in src.mutations)
	var/skeleton = (SKELETON in src.mutations)

	//CACHING: Generate an index key from visible bodyparts.
	//0 = destroyed, 1 = normal, 2 = robotic, 3 = necrotic.

	//Create a new, blank icon for our mob to use.
	if(stand_icon)
		qdel(stand_icon)
	stand_icon = new(species.icon_template ? species.icon_template : 'icons/mob/human.dmi',"blank")

	var/g = "male"
	if(gender == FEMALE)
		g = "female"

	var/icon_key = "[species.get_race_key(src)][g][s_tone][r_skin][g_skin][b_skin]"
	if(lip_style)
		icon_key += "[lip_style]"
	else
		icon_key += "nolips"
	var/obj/item/organ/internal/eyes/eyes = internal_organs_by_name[species.vision_organ ? species.vision_organ : BP_EYES]
	if(istype(eyes))
		icon_key += "[rgb(eyes.eye_colour[1], eyes.eye_colour[2], eyes.eye_colour[3])]"
	else
		icon_key += "#000000"

	for(var/organ_tag in species.has_limbs)
		var/obj/item/organ/external/part = organs_by_name[organ_tag]
		if(isnull(part) || part.is_stump())
			icon_key += "0"
			continue
		if(part)
			icon_key += "[part.species.get_race_key(part.owner)]"
			icon_key += "[part.dna.GetUIState(DNA_UI_GENDER)]"
			icon_key += "[part.s_tone]"
			if(part.s_col && part.s_col.len >= 3)
				icon_key += "[rgb(part.s_col[1],part.s_col[2],part.s_col[3])]"
				icon_key += "[part.s_col_blend]"
			if(part.body_hair && part.h_col && part.h_col.len >= 3)
				icon_key += "[rgb(part.h_col[1],part.h_col[2],part.h_col[3])]"
			else
				icon_key += "#000000"
		if(part.robotic >= ORGAN_ROBOT)
			icon_key += "2[part.model ? "-[part.model]": ""]"
		else if(part.status & ORGAN_DEAD)
			icon_key += "3"
		else
			icon_key += "1"

	icon_key = "[icon_key][husk ? 1 : 0][fat ? 1 : 0][hulk ? 1 : 0][skeleton ? 1 : 0]"

	var/icon/base_icon
	if(human_icon_cache[icon_key])
		base_icon = human_icon_cache[icon_key]
	else
		//BEGIN CACHED ICON GENERATION.
		var/obj/item/organ/external/chest = get_organ(BP_CHEST)
		base_icon = chest.get_icon()

		for(var/obj/item/organ/external/part in (organs-chest))
			var/icon/temp = part.get_icon()
			//That part makes left and right legs drawn topmost and lowermost when human looks WEST or EAST
			//And no change in rendering for other parts (they icon_position is 0, so goes to 'else' part)
			if(part.icon_position&(LEFT|RIGHT))
				var/icon/temp2 = new('icons/mob/human.dmi',"blank")
				temp2.Insert(new/icon(temp,dir=NORTH),dir=NORTH)
				temp2.Insert(new/icon(temp,dir=SOUTH),dir=SOUTH)
				if(!(part.icon_position & LEFT))
					temp2.Insert(new/icon(temp,dir=EAST),dir=EAST)
				if(!(part.icon_position & RIGHT))
					temp2.Insert(new/icon(temp,dir=WEST),dir=WEST)
				base_icon.Blend(temp2, ICON_OVERLAY)
				if(part.icon_position & LEFT)
					temp2.Insert(new/icon(temp,dir=EAST),dir=EAST)
				if(part.icon_position & RIGHT)
					temp2.Insert(new/icon(temp,dir=WEST),dir=WEST)
				base_icon.Blend(temp2, ICON_UNDERLAY)
			else
				base_icon.Blend(temp, ICON_OVERLAY)

		if(!skeleton)
			if(husk)
				base_icon.ColorTone(husk_color_mod)
			else if(hulk)
				var/list/tone = ReadRGB(hulk_color_mod)
				base_icon.MapColors(rgb(tone[1],0,0),rgb(0,tone[2],0),rgb(0,0,tone[3]))

		//Handle husk overlay.
		if(husk && ("overlay_husk" in icon_states(species.get_icobase(src))))
			var/icon/mask = new(base_icon)
			var/icon/husk_over = new(species.get_icobase(src),"overlay_husk")
			mask.MapColors(0,0,0,1, 0,0,0,1, 0,0,0,1, 0,0,0,1, 0,0,0,0)
			husk_over.Blend(mask, ICON_ADD)
			base_icon.Blend(husk_over, ICON_OVERLAY)

		human_icon_cache[icon_key] = base_icon

	//END CACHED ICON GENERATION.
	stand_icon.Blend(base_icon,ICON_OVERLAY)

	if(update_icons)
		update_icons()

	//tail
	update_tail_showing(0)

//UNDERWEAR OVERLAY

/mob/living/carbon/human/proc/update_underwear(var/update_icons=1)
	overlays_standing[UNDERWEAR_LAYER] = list()
	for(var/entry in worn_underwear)
		var/obj/item/underwear/UW = entry

		var/image/I = image(icon = UW.icon, icon_state = UW.icon_state)
		I.appearance_flags = RESET_COLOR
		I.color = UW.color

		overlays_standing[UNDERWEAR_LAYER] += I

	if(update_icons)   update_icons()

//HAIR OVERLAY
/mob/living/carbon/human/proc/update_hair(var/update_icons=1)
	//Reset our hair
	overlays_standing[HAIR_LAYER]	= null

	var/obj/item/organ/external/head/head_organ = get_organ(BP_HEAD)
	if(!head_organ || head_organ.is_stump() )
		if(update_icons)   update_icons()
		return

	//masks and helmets can obscure our hair.
	if( (head && (head.flags_inv & BLOCKHAIR)) || (wear_mask && (wear_mask.flags_inv & BLOCKHAIR)))
		if(update_icons)   update_icons()
		return

	overlays_standing[HAIR_LAYER]	= head_organ.get_hair_icon()

	if(update_icons)   update_icons()

/mob/living/carbon/human/update_mutations(var/update_icons=1)
	var/fat
	if(FAT in mutations)
		fat = "fat"

	var/image/standing	= overlay_image('icons/effects/genetics.dmi', flags=RESET_COLOR)
	var/add_image = 0
	var/g = "m"
	if(gender == FEMALE)	g = "f"
	// DNA2 - Drawing underlays.
	for(var/datum/dna/gene/gene in dna_genes)
		if(!gene.block)
			continue
		if(gene.is_active(src))
			var/underlay=gene.OnDrawUnderlays(src,g,fat)
			if(underlay)
				standing.underlays += underlay
				add_image = 1
	for(var/mut in mutations)
		switch(mut)
			if(LASER)
				standing.overlays	+= "lasereyes_s"
				add_image = 1
	if(add_image)
		overlays_standing[MUTATIONS_LAYER]	= standing
	else
		overlays_standing[MUTATIONS_LAYER]	= null
	if(update_icons)   update_icons()

/* --------------------------------------- */
//For legacy support.
/mob/living/carbon/human/regenerate_icons()
	..()
	if(transforming || QDELETED(src))		return

	update_mutations(0)
	update_body(0)
	update_underwear(0)
	update_hair(0)
	update_inv_w_uniform(0)
	update_inv_wear_id(0)
	update_inv_gloves(0)
	update_inv_glasses(0)
	update_inv_ears(0)
	update_inv_shoes(0)
	update_inv_s_store(0)
	update_inv_wear_mask(0)
	update_inv_head(0)
	update_inv_belt(0)
	update_inv_back(0)
	update_inv_wear_suit(0)
	update_inv_r_hand(0)
	update_inv_l_hand(0)
	update_inv_handcuffed(0)
	update_inv_pockets(0)
	update_fire(0)
	update_surgery(0)
	UpdateDamageIcon()
	update_icons()
	//Hud Stuff
	update_hud()

/* --------------------------------------- */
//vvvvvv UPDATE_INV PROCS vvvvvv

/mob/living/carbon/human/update_inv_w_uniform(var/update_icons=1)
	if(istype(w_uniform, /obj/item/clothing/under) && !(wear_suit && wear_suit.flags_inv & HIDEJUMPSUIT))
		overlays_standing[UNIFORM_LAYER]	= w_uniform.get_mob_overlay(src,slot_w_uniform_str)
	else
		overlays_standing[UNIFORM_LAYER]	= null

	if(update_icons)
		update_icons()

/mob/living/carbon/human/update_inv_wear_id(var/update_icons=1)
	if(wear_id)
		if(w_uniform && w_uniform:displays_id)
			overlays_standing[ID_LAYER] = wear_id.get_mob_overlay(src,slot_wear_id_str)
		else
			overlays_standing[ID_LAYER]	= null
	else
		overlays_standing[ID_LAYER]	= null

	BITSET(hud_updateflag, ID_HUD)
	BITSET(hud_updateflag, WANTED_HUD)

	if(update_icons)   update_icons()

/mob/living/carbon/human/update_inv_gloves(var/update_icons=1)
	if(gloves && !(wear_suit && wear_suit.flags_inv & HIDEGLOVES))
		overlays_standing[GLOVES_LAYER]	= gloves.get_mob_overlay(src,slot_gloves_str)
	else
		if(blood_DNA && species.blood_mask)
			var/image/bloodsies	= overlay_image(species.blood_mask, "bloodyhands", hand_blood_color, RESET_COLOR)
			overlays_standing[GLOVES_LAYER]	= bloodsies
		else
			overlays_standing[GLOVES_LAYER]	= null
	if(update_icons)   update_icons()


/mob/living/carbon/human/update_inv_glasses(var/update_icons=1)
	if(glasses)
		overlays_standing[GLASSES_LAYER] = glasses.get_mob_overlay(src,slot_glasses_str)
	else
		overlays_standing[GLASSES_LAYER]	= null
	if(update_icons)   update_icons()

/mob/living/carbon/human/update_inv_ears(var/update_icons=1)
	overlays_standing[EARS_LAYER] = null
	if( (head && (head.flags_inv & (BLOCKHAIR | BLOCKHEADHAIR))) || (wear_mask && (wear_mask.flags_inv & (BLOCKHAIR | BLOCKHEADHAIR))))
		if(update_icons)   update_icons()
		return

	if(l_ear || r_ear)
		// Blank image upon which to layer left & right overlays.
		var/image/both = image("icon" = 'icons/effects/effects.dmi', "icon_state" = "nothing")
		if(l_ear)
			both.overlays += l_ear.get_mob_overlay(src,slot_l_ear_str)
		if(r_ear)
			both.overlays += r_ear.get_mob_overlay(src,slot_r_ear_str)
		overlays_standing[EARS_LAYER] = both

	else
		overlays_standing[EARS_LAYER]	= null
	if(update_icons)   update_icons()

/mob/living/carbon/human/update_inv_shoes(var/update_icons=1)
	if(shoes && !(wear_suit && wear_suit.flags_inv & HIDESHOES))
		overlays_standing[SHOES_LAYER] = shoes.get_mob_overlay(src,slot_shoes_str)
	else
		if(feet_blood_DNA && species.blood_mask)
			var/image/bloodsies = overlay_image(species.blood_mask, "shoeblood", hand_blood_color, RESET_COLOR)
			overlays_standing[SHOES_LAYER] = bloodsies
		else
			overlays_standing[SHOES_LAYER] = null
	if(update_icons)   update_icons()

/mob/living/carbon/human/update_inv_s_store(var/update_icons=1)
	if(s_store)
		overlays_standing[SUIT_STORE_LAYER]	= s_store.get_mob_overlay(src,slot_s_store_str)
	else
		overlays_standing[SUIT_STORE_LAYER]	= null
	if(update_icons)   update_icons()


/mob/living/carbon/human/update_inv_head(var/update_icons=1)
	if(head)
		overlays_standing[HEAD_LAYER] = head.get_mob_overlay(src,slot_head_str)
	else
		overlays_standing[HEAD_LAYER]	= null
	if(update_icons)   update_icons()

/mob/living/carbon/human/update_inv_belt(var/update_icons=1)
	if(belt)
		var/belt_layer = BELT_LAYER
		if(istype(belt, /obj/item/weapon/storage/belt))
			var/obj/item/weapon/storage/belt/ubelt = belt
			if(ubelt.show_above_suit)
				overlays_standing[BELT_LAYER] = null
				belt_layer = BELT_LAYER_ALT
			else
				overlays_standing[BELT_LAYER_ALT] = null

		overlays_standing[belt_layer] = belt.get_mob_overlay(src,slot_belt_str)
	else
		overlays_standing[BELT_LAYER] = null
		overlays_standing[BELT_LAYER_ALT] = null
	if(update_icons)   update_icons()


/mob/living/carbon/human/update_inv_wear_suit(var/update_icons=1)

	if(wear_suit)
		overlays_standing[SUIT_LAYER]	= wear_suit.get_mob_overlay(src,slot_wear_suit_str)
		update_tail_showing(0)
	else
		overlays_standing[SUIT_LAYER]	= null
		update_tail_showing(0)
		update_inv_w_uniform(0)
		update_inv_shoes(0)
		update_inv_gloves(0)

	update_collar(0)

	if(update_icons)   update_icons()

/mob/living/carbon/human/update_inv_pockets(var/update_icons=1)
	if(update_icons)	update_icons()


/mob/living/carbon/human/update_inv_wear_mask(var/update_icons=1)
	if( wear_mask && ( istype(wear_mask, /obj/item/clothing/mask) || istype(wear_mask, /obj/item/clothing/accessory) ) && !(head && head.flags_inv & HIDEMASK))
		overlays_standing[FACEMASK_LAYER]	= wear_mask.get_mob_overlay(src,slot_wear_mask_str)
	else
		overlays_standing[FACEMASK_LAYER]	= null
	if(update_icons)   update_icons()

/mob/living/carbon/human/update_inv_back(var/update_icons=1)
	if(back)
		overlays_standing[BACK_LAYER] = back.get_mob_overlay(src,slot_back_str)
	else
		overlays_standing[BACK_LAYER] = null

	if(update_icons)
		update_icons()


/mob/living/carbon/human/update_hud()	//TODO: do away with this if possible
	if(client)
		client.screen |= contents
		if(hud_used)
			hud_used.hidden_inventory_update() 	//Updates the screenloc of the items on the 'other' inventory bar


/mob/living/carbon/human/update_inv_handcuffed(var/update_icons=1)
	if(handcuffed)
		overlays_standing[HANDCUFF_LAYER] = handcuffed.get_mob_overlay(src,slot_handcuffed_str)
	else
		overlays_standing[HANDCUFF_LAYER]	= null
	if(update_icons)   update_icons()

/mob/living/carbon/human/update_inv_r_hand(var/update_icons=1)
	if(r_hand)
		var/image/standing = r_hand.get_mob_overlay(src,slot_r_hand_str)
		if(standing)
			standing.appearance_flags |= RESET_ALPHA
		overlays_standing[R_HAND_LAYER] = standing

		if (handcuffed) drop_r_hand() //this should be moved out of icon code
	else
		overlays_standing[R_HAND_LAYER] = null

	if(update_icons) update_icons()


/mob/living/carbon/human/update_inv_l_hand(var/update_icons=1)
	if(l_hand)
		var/image/standing = l_hand.get_mob_overlay(src,slot_l_hand_str)
		if(standing)
			standing.appearance_flags |= RESET_ALPHA
		overlays_standing[L_HAND_LAYER] = standing

		if (handcuffed) drop_l_hand() //This probably should not be here
	else
		overlays_standing[L_HAND_LAYER] = null

	if(update_icons) update_icons()

/mob/living/carbon/human/proc/update_tail_showing(var/update_icons=1)
	overlays_standing[TAIL_LAYER] = null

	var/species_tail = species.get_tail(src)

	if(species_tail && !(wear_suit && wear_suit.flags_inv & HIDETAIL))
		var/icon/tail_s = get_tail_icon()
		overlays_standing[TAIL_LAYER] = image(tail_s, icon_state = "[species_tail]_s")
		animate_tail_reset(0)

	if(update_icons)
		update_icons()

/mob/living/carbon/human/proc/get_tail_icon()
	var/icon_key = "[species.get_race_key(src)][r_skin][g_skin][b_skin][r_hair][g_hair][b_hair]"
	var/icon/tail_icon = tail_icon_cache[icon_key]
	if(!tail_icon)
		//generate a new one
		var/species_tail_anim = species.get_tail_animation(src)
		if(!species_tail_anim) species_tail_anim = 'icons/effects/species.dmi'
		tail_icon = new/icon(species_tail_anim)
		tail_icon.Blend(rgb(r_skin, g_skin, b_skin), ICON_ADD)
		// The following will not work with animated tails.
		var/use_species_tail = species.get_tail_hair(src)
		if(use_species_tail)
			var/icon/hair_icon = icon('icons/effects/species.dmi', "[species.get_tail(src)]_[use_species_tail]")
			hair_icon.Blend(rgb(r_hair, g_hair, b_hair), ICON_ADD)
			tail_icon.Blend(hair_icon, ICON_OVERLAY)
		tail_icon_cache[icon_key] = tail_icon

	return tail_icon


/mob/living/carbon/human/proc/set_tail_state(var/t_state)
	var/image/tail_overlay = overlays_standing[TAIL_LAYER]

	if(tail_overlay && species.get_tail_animation(src))
		tail_overlay.icon_state = t_state
		return tail_overlay
	return null

//Not really once, since BYOND can't do that.
//Update this if the ability to flick() images or make looping animation start at the first frame is ever added.
/mob/living/carbon/human/proc/animate_tail_once(var/update_icons=1)
	var/t_state = "[species.get_tail(src)]_once"

	var/image/tail_overlay = overlays_standing[TAIL_LAYER]
	if(tail_overlay && tail_overlay.icon_state == t_state)
		return //let the existing animation finish

	tail_overlay = set_tail_state(t_state)
	if(tail_overlay)
		spawn(20)
			//check that the animation hasn't changed in the meantime
			if(overlays_standing[TAIL_LAYER] == tail_overlay && tail_overlay.icon_state == t_state)
				animate_tail_stop()

	if(update_icons)
		update_icons()

/mob/living/carbon/human/proc/animate_tail_start(var/update_icons=1)
	set_tail_state("[species.get_tail(src)]_slow[rand(0,9)]")

	if(update_icons)
		update_icons()

/mob/living/carbon/human/proc/animate_tail_fast(var/update_icons=1)
	set_tail_state("[species.get_tail(src)]_loop[rand(0,9)]")

	if(update_icons)
		update_icons()

/mob/living/carbon/human/proc/animate_tail_reset(var/update_icons=1)
	if(stat != DEAD)
		set_tail_state("[species.get_tail(src)]_idle[rand(0,9)]")
	else
		set_tail_state("[species.get_tail(src)]_static")

	if(update_icons)
		update_icons()

/mob/living/carbon/human/proc/animate_tail_stop(var/update_icons=1)
	set_tail_state("[species.get_tail(src)]_static")

	if(update_icons)
		update_icons()


//Adds a collar overlay above the helmet layer if the suit has one
//	Suit needs an identically named sprite in icons/mob/collar.dmi
/mob/living/carbon/human/proc/update_collar(var/update_icons=1)
	if(istype(wear_suit,/obj/item/clothing/suit))
		var/obj/item/clothing/suit/S = wear_suit
		overlays_standing[COLLAR_LAYER]	= S.get_collar()
	else
		overlays_standing[COLLAR_LAYER]	= null

	if(update_icons)   update_icons()


/mob/living/carbon/human/update_fire(var/update_icons=1)
	overlays_standing[FIRE_LAYER] = null
	if(on_fire)
		var/image/standing = overlay_image('icons/mob/OnFire.dmi', "Standing", RESET_COLOR)
		overlays_standing[FIRE_LAYER] = standing
	if(update_icons)   update_icons()

/mob/living/carbon/human/proc/update_surgery(var/update_icons=1)
	overlays_standing[SURGERY_LEVEL] = null
	var/image/total = new
	for(var/obj/item/organ/external/E in organs)
		if(E.robotic < ORGAN_ROBOT && E.open())
			var/image/I = image("icon"='icons/mob/surgery.dmi', "icon_state"="[E.icon_name][round(E.open())]", "layer"=-SURGERY_LEVEL)
			total.overlays += I
	total.appearance_flags = RESET_COLOR
	overlays_standing[SURGERY_LEVEL] = total
	if(update_icons)   update_icons()

//Human Overlays Indexes/////////
#undef MUTATIONS_LAYER
#undef DAMAGE_LAYER
#undef SURGERY_LEVEL
#undef UNIFORM_LAYER
#undef ID_LAYER
#undef SHOES_LAYER
#undef GLOVES_LAYER
#undef EARS_LAYER
#undef SUIT_LAYER
#undef TAIL_LAYER
#undef GLASSES_LAYER
#undef FACEMASK_LAYER
#undef BELT_LAYER
#undef SUIT_STORE_LAYER
#undef BACK_LAYER
#undef HAIR_LAYER
#undef HEAD_LAYER
#undef COLLAR_LAYER
#undef HANDCUFF_LAYER
#undef LEGCUFF_LAYER
#undef L_HAND_LAYER
#undef R_HAND_LAYER
#undef TARGETED_LAYER
#undef FIRE_LAYER
#undef TOTAL_LAYERS
