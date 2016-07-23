/var/list/static_gas_constants = list(
	"MOLES_O2STANDARD" = MOLES_O2STANDARD,
	"MOLES_N2STANDARD" = MOLES_N2STANDARD,

	"MOLES_O2ATMOS" = MOLES_O2ATMOS,
	"MOLES_N2ATMOS" = MOLES_N2ATMOS,

	"ATMOSTANK_NITROGEN" = ATMOSTANK_NITROGEN,
	"ATMOSTANK_OXYGEN" = ATMOSTANK_OXYGEN,
	"ATMOSTANK_CO2" = ATMOSTANK_CO2,
	"ATMOSTANK_PHORON" = ATMOSTANK_PHORON,
	"ATMOSTANK_NITROUSOXIDE" = ATMOSTANK_NITROUSOXIDE,

	"T0C" = T0C,
	"T20C" = T20C,
	"TCMB" = TCMB
)

/var/list/static_gas = list()
/var/list/static_gas_list = list()

/proc/get_static_gas(gas_str)
	. = static_gas[gas_str]
	if(!.)
		register_static_gas(gas_str)
		return static_gas[gas_str]

/proc/get_static_gas_list(gas_str)
	. = static_gas_list[gas_str]
	if(!.)
		register_static_gas(gas_str)
		return static_gas_list[gas_str]

/proc/register_static_gas(gas_str)
	var/list/gas_list = params2list(gas_str)

	var/g
	for(var/gasid in gas_list)
		g = static_gas_constants[gas_list[gasid]]
		if(!g)
			g = text2num(gas_list[gasid])
		gas_list[gasid] = g
	
	static_gas[gas_str] = new /datum/gas_mixture(gas_in = gas_list)
	static_gas_list[gas_str] = gas_list
