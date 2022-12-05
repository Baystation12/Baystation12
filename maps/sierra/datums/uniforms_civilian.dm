/* ENGINEERING
 * ===========
 */

/singleton/hierarchy/mil_uniform/civilian/eng
	name = "Civilian Engineering"
	departments = ENG

	dress_hat = list(\
		/obj/item/clothing/head/soft/yellow, /obj/item/clothing/head/hardhat)
	dress_under = list(\
		/obj/item/clothing/under/rank/engineer, /obj/item/clothing/under/rank/atmospheric_technician, \
		/obj/item/clothing/under/hazard)
	dress_shoes = list(\
		/obj/item/clothing/shoes/workboots, /obj/item/clothing/shoes/workboots)

/singleton/hierarchy/mil_uniform/civilian/eng/head
	name = "Civilian Engineering Head"
	departments = ENG|COM

	dress_hat = list(\
		/obj/item/clothing/head/soft/yellow, /obj/item/clothing/head/hardhat/white, \
		/obj/item/clothing/head/beret/infinity/engineer_ce)
	dress_under = list(\
		/obj/item/clothing/under/rank/chief_engineer)

/* SUPPLY
 * ======
 */

/singleton/hierarchy/mil_uniform/civilian/sup
	name = "Civilian Supply"
	departments = SUP

	dress_hat = list(\
		/obj/item/clothing/head/soft/yellow, /obj/item/clothing/head/beret/infinity/cargo)
	dress_under = list(\
		/obj/item/clothing/under/rank/cargotech)
	dress_shoes = list(\
		/obj/item/clothing/shoes/brown, /obj/item/clothing/shoes/dutyboots)

/singleton/hierarchy/mil_uniform/civilian/sup/head
	name = "Civilian Supply Head"
	departments = SUP|COM

	dress_hat = list(\
		/obj/item/clothing/head/soft/yellow,
		/obj/item/clothing/head/beret/infinity/cargo
		)
	dress_under = list(
		/obj/item/clothing/under/rank/cargo
		)

/* SECURITY
 * ========
 */

/singleton/hierarchy/mil_uniform/civilian/sec
	name = "Civilian Security"
	departments = SEC

	dress_hat = list(\
		/obj/item/clothing/head/beret/sec/corporate/officer, /obj/item/clothing/head/beret/sec/navy/officer, \
		/obj/item/clothing/head/beret/sec, /obj/item/clothing/head/soft/sec, \
		/obj/item/clothing/head/soft/sec/corp, /obj/item/clothing/head/soft/sec/corp/guard, \
		/obj/item/clothing/head/beret/guard)
	dress_under = list(\
		/obj/item/clothing/under/rank/security, /obj/item/clothing/under/rank/security/alt, \
		/obj/item/clothing/under/rank/security/corp, /obj/item/clothing/under/rank/security/corp/alt, \
		/obj/item/clothing/under/rank/security/navyblue, /obj/item/clothing/under/rank/security/navyblue/alt, \
		/obj/item/clothing/under/rank/security2)
	dress_shoes = list(\
		/obj/item/clothing/shoes/jackboots)

/singleton/hierarchy/mil_uniform/civilian/sec/head
	name = "Civilian Security Head"
	departments = SEC|COM

	dress_hat = list(\
		/obj/item/clothing/head/beret/sec/corporate/hos,
		/obj/item/clothing/head/HoS,
		/obj/item/clothing/head/beret/sec/navy/hos
		)
	dress_under = list(\
		/obj/item/clothing/under/rank/head_of_security, /obj/item/clothing/under/rank/head_of_security/jensen, \
		/obj/item/clothing/under/rank/head_of_security/navyblue, /obj/item/clothing/under/rank/head_of_security/navyblue/alt, \
		/obj/item/clothing/under/rank/head_of_security/corp, /obj/item/clothing/under/rank/head_of_security/corp/alt, \
		/obj/item/clothing/under/hosformalfem, /obj/item/clothing/under/hosformalmale)

/* MEDICAL
 * =======
 */

/singleton/hierarchy/mil_uniform/civilian/med
	name = "Civilian Medical"
	departments = MED

	dress_hat = list(\
		/obj/item/clothing/head/soft/mime, /obj/item/clothing/head/nursehat, \
		/obj/item/clothing/head/surgery, /obj/item/clothing/head/surgery/purple, \
		/obj/item/clothing/head/surgery/blue, /obj/item/clothing/head/surgery/green, \
		/obj/item/clothing/head/surgery/black, /obj/item/clothing/head/surgery/navyblue, \
		/obj/item/clothing/head/surgery/lilac, /obj/item/clothing/head/surgery/teal, \
		/obj/item/clothing/head/surgery/heliodor, /obj/item/clothing/head/hardhat/EMS, \
		/obj/item/clothing/head/beret/infinity/medical)
	dress_under = list(\
		/obj/item/clothing/under/rank/chemist, /obj/item/clothing/under/rank/chemist_new, \
		/obj/item/clothing/under/rank/medical, /obj/item/clothing/under/rank/medical/paramedic, \
		/obj/item/clothing/under/rank/nurse, /obj/item/clothing/under/rank/nursesuit, \
		/obj/item/clothing/under/rank/orderly, /obj/item/clothing/under/rank/virologist, \
		/obj/item/clothing/under/rank/virologist_new, \
		/obj/item/clothing/under/rank/medical/scrubs, /obj/item/clothing/under/rank/medical/scrubs/blue, \
		/obj/item/clothing/under/rank/medical/scrubs/green, /obj/item/clothing/under/rank/medical/scrubs/purple, \
		/obj/item/clothing/under/rank/medical/scrubs/black, /obj/item/clothing/under/rank/medical/scrubs/navyblue, \
		/obj/item/clothing/under/rank/medical/scrubs/lilac, /obj/item/clothing/under/rank/medical/scrubs/teal, \
		/obj/item/clothing/under/rank/medical/scrubs/heliodor)
	dress_shoes = list(\
		/obj/item/clothing/shoes/white)

/singleton/hierarchy/mil_uniform/civilian/med/head
	name = "Civilian Medical Head"
	departments = MED|COM

	dress_hat = list(\
		/obj/item/clothing/head/surgery, /obj/item/clothing/head/surgery/purple, \
		/obj/item/clothing/head/surgery/blue, /obj/item/clothing/head/surgery/green, \
		/obj/item/clothing/head/surgery/black, /obj/item/clothing/head/surgery/navyblue, \
		/obj/item/clothing/head/surgery/lilac, /obj/item/clothing/head/surgery/teal, \
		/obj/item/clothing/head/surgery/heliodor, /obj/item/clothing/head/beret/infinity/medical, \
		/obj/item/clothing/head/beret/infinity/medical_cmo)
	dress_under = list(\
		/obj/item/clothing/under/rank/chief_medical_officer, /obj/item/clothing/under/sterile, \
		/obj/item/clothing/under/rank/medical/scrubs, /obj/item/clothing/under/rank/medical/scrubs/blue, \
		/obj/item/clothing/under/rank/medical/scrubs/green, /obj/item/clothing/under/rank/medical/scrubs/purple, \
		/obj/item/clothing/under/rank/medical/scrubs/black, /obj/item/clothing/under/rank/medical/scrubs/navyblue, \
		/obj/item/clothing/under/rank/medical/scrubs/lilac, /obj/item/clothing/under/rank/medical/scrubs/teal, \
		/obj/item/clothing/under/rank/medical/scrubs/heliodor)

/* RESEARCH
 * ========
 */

/singleton/hierarchy/mil_uniform/civilian/res
	name = "Civilian Research"
	departments = SCI

	dress_hat = list(\
		/obj/item/clothing/head/beret/infinity/science)
	dress_under = list(\
		/obj/item/clothing/under/sterile, /obj/item/clothing/under/rank/scientist, \
		/obj/item/clothing/under/rank/scientist_new)
	dress_shoes = list(\
		/obj/item/clothing/shoes/white)

/singleton/hierarchy/mil_uniform/civilian/res/head
	name = "Civilian Research Head"
	departments = SCI|COM

	dress_hat = list(\
		/obj/item/clothing/head/beret/infinity/science
		)
	dress_under = list(
		/obj/item/clothing/under/rank/research_director,
		/obj/item/clothing/under/rank/research_director/dress_rd,
		/obj/item/clothing/under/rank/research_director/rdalt
		)

/* EXPLORATION
 * ========
 */
/singleton/hierarchy/mil_uniform/civilian/exp
	name = "Civilian Exploration"
	departments = EXP

	dress_hat = list(\
		/obj/item/clothing/head/beret/infinity/exploration
		)

/* COMMAND
 * =======
 */

/singleton/hierarchy/mil_uniform/civilian/com
	name = "Civilian Command"
	departments = COM
