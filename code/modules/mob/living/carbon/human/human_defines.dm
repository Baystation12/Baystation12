/mob/living/carbon/human
	mob_bump_flag = HUMAN
	mob_push_flags = ~HEAVY
	mob_swap_flags = ~HEAVY

	/// The style of head hair applied to this mob
	var/head_hair_style = "Bald"

	/// The color of head hair applied to this mob
	var/head_hair_color = "#000000"

	/// The style of facial hair applied to this mob
	var/facial_hair_style = "Shaved"

	/// The color of facial hair applied to this mob
	var/facial_hair_color = "#000000"

	/// The color that will be used for the eyes of this mob
	var/eye_color = "#000000"

	/// The skin color that will be applied to this mob if it does not use a tone
	var/skin_color = "#000000"

	/// The skin tone scale that will be applied to this mob if it does not use a color
	var/skin_tone = 0

	/// The base icon that will be used for this mob if it allows more than one
	var/base_skin = ""

	/// The style of makeup applied to this mob
	var/makeup_style

	var/age = 30		//Player's age (pure fluff)
	var/b_type = "A+"	//Player's bloodtype

	/// The amount this mob's age has been changed in the round, if it has
	var/changed_age = 0

	var/list/worn_underwear = list()

	var/datum/backpack_setup/backpack_setup

	var/list/cultural_info = list()

	//Equipment slots
	var/obj/item/wear_suit
	var/obj/item/w_uniform
	var/obj/item/shoes
	var/obj/item/belt
	var/obj/item/gloves
	var/obj/item/glasses
	var/obj/item/head
	var/obj/item/l_ear
	var/obj/item/r_ear
	var/obj/item/wear_id
	var/obj/item/r_store
	var/obj/item/l_store
	var/obj/item/s_store

	var/icon/stand_icon
	var/icon/lying_icon

	var/voice = ""	//Instead of new say code calling GetVoice() over and over and over, we're just going to ask this variable, which gets updated in Life()

	var/last_dam = -1	//Used for determining if we need to process all organs or just some or even none.
	var/list/bad_external_organs = list()// organs we check until they are good.

	var/xylophone = 0 //For the spoooooooky xylophone cooldown

	var/mob/remoteview_target
	var/hand_blood_color

	var/list/flavor_texts = list()
	var/pulling_punches    // Are you trying not to hurt your opponent?
	var/full_prosthetic    // We are a robutt.
	var/robolimb_count = 0 // Number of robot limbs.
	var/last_attack = 0    // The world_time where an unarmed attack was done

	var/flash_protection = 0				// Total level of flash protection
	var/equipment_tint_total = 0			// Total level of visualy impairing items
	var/equipment_darkness_modifier			// Darkvision modifier from equipped items
	var/equipment_vision_flags				// Extra vision flags from equipped items
	var/equipment_see_invis					// Max see invibility level granted by equipped items
	var/equipment_prescription				// Eye prescription granted by equipped items
	var/equipment_light_protection
	var/list/equipment_overlays = list()	// Extra overlays from equipped items

	var/public_record = ""
	var/med_record = ""
	var/sec_record = ""
	var/gen_record = ""
	var/exploit_record = ""

	var/datum/mil_branch/char_branch
	var/datum/mil_rank/char_rank

	var/stance_damage = 0 //Whether this mob's ability to stand has been affected

	var/datum/unarmed_attack/default_attack	//default unarmed attack

	var/obj/machinery/machine_visual //machine that is currently applying visual effects to this mob. Only used for camera monitors currently.
	var/shock_stage

	var/obj/item/grab/current_grab_type 	// What type of grab they use when they grab someone.

	var/list/descriptors

	var/last_smelt = 0
