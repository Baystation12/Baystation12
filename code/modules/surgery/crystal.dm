/decl/surgery_step/generic/cut_open/crystal
	name = "Drill keyhole incision"
	allowed_tools = list(
		/obj/item/weapon/pickaxe/drill = 80,
		/obj/item/weapon/surgicaldrill = 100
	)
	fail_string = "cracking"
	access_string = "a neat hole"
	surgery_candidate_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_STUMP | SURGERY_NO_FLESH

/decl/surgery_step/generic/cauterize/crystal
	name = "Close keyhole incision"
	allowed_tools = list(
		/obj/item/stack/medical/resin = 100
	)
	surgery_candidate_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_FLESH
	cauterize_term = "seal"
	post_cauterize_term = "seals"

/decl/surgery_step/open_encased/crystal
	name = "Saw through crystal"
	allowed_tools = list(
		/obj/item/weapon/circular_saw = 100
	)
	surgery_candidate_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_STUMP | SURGERY_NEEDS_RETRACTED | SURGERY_NO_FLESH

/decl/surgery_step/bone/glue/crystal
	name = "Begin crystalline bone repair"
	allowed_tools = list(
		/obj/item/stack/medical/resin = 100
	)
	surgery_candidate_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_FLESH

/decl/surgery_step/bone/finish/crystal
	name = "Finish crystalline bone repair"
	allowed_tools = list(
		/obj/item/stack/medical/resin = 100
	)
	surgery_candidate_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_FLESH

/decl/surgery_step/internal/detatch_organ/crystal
	name = "Detach crystalline internal organ"
	allowed_tools = list(
		/obj/item/weapon/pickaxe/drill = 80,
		/obj/item/weapon/surgicaldrill = 100
	)
	surgery_candidate_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_STUMP | SURGERY_NEEDS_ENCASEMENT | SURGERY_NO_FLESH

/decl/surgery_step/internal/attach_organ/crystal
	name = "Attach crystalline internal organ"
	allowed_tools = list(
		/obj/item/stack/medical/resin = 100
	)
	surgery_candidate_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_STUMP | SURGERY_NEEDS_ENCASEMENT | SURGERY_NO_FLESH

/decl/surgery_step/internal/fix_organ/crystal
	name = "Repair crystalline internal organ"
	allowed_tools = list(
		/obj/item/stack/medical/resin = 100
	)
	surgery_candidate_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_STUMP | SURGERY_NO_FLESH

/decl/surgery_step/fix_vein/crystal
	name = "Repair arteries in crystalline beings"
	allowed_tools = list(
		/obj/item/stack/medical/resin = 100
	)
	surgery_candidate_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_STUMP | SURGERY_NO_FLESH
