var/const/ENG               =(1<<0)
var/const/SEC               =(1<<1)
var/const/MED               =(1<<2)
var/const/SCI               =(1<<3)
var/const/CIV               =(1<<4)
var/const/COM               =(1<<5)
var/const/CRG               =(1<<6)
var/const/MSC               =(1<<7)
var/const/SRV               =(1<<8)
var/const/SUP               =(1<<9)
var/const/SPT				=(1<<10)

var/list/assistant_occupations = list(
)

var/list/command_positions = list(
)

var/list/engineering_positions = list(
)

var/list/medical_positions = list(
)

var/list/science_positions = list(
)

var/list/cargo_positions = list(
)

var/list/civilian_positions = list(
)


var/list/security_positions = list(
)

var/list/nonhuman_positions = list(
	"pAI"
)

var/list/service_positions = list(
)

var/list/supply_positions = list(
)

var/list/support_positions = list(
)


/proc/guest_jobbans(var/job)
	return ((job in command_positions) || (job in nonhuman_positions) || (job in security_positions))

/proc/get_job_datums()
	var/list/occupations = list()
	var/list/all_jobs = typesof(/datum/job)

	for(var/A in all_jobs)
		var/datum/job/job = new A()
		if(!job)	continue
		occupations += job

	return occupations

/proc/get_alternate_titles(var/job)
	var/list/jobs = get_job_datums()
	var/list/titles = list()

	for(var/datum/job/J in jobs)
		if(J.title == job)
			titles = J.alt_titles

	return titles
