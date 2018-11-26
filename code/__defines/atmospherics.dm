#define PIPE_SIMPLE_STRAIGHT	0
#define PIPE_SIMPLE_BENT		1
#define PIPE_HE_STRAIGHT		2
#define PIPE_HE_BENT			3
#define PIPE_CONNECTOR			4
#define PIPE_MANIFOLD			5
#define PIPE_JUNCTION			6
#define PIPE_UVENT				7
#define PIPE_MVALVE				8
#define PIPE_DVALVE				9
#define PIPE_PUMP				10
#define PIPE_SCRUBBER			11
//#define unsed	12
#define PIPE_GAS_FILTER			13
#define PIPE_GAS_MIXER			14
#define PIPE_PASSIVE_GATE       15
#define PIPE_VOLUME_PUMP        16
#define PIPE_HEAT_EXCHANGE      17
#define PIPE_MTVALVE			18
#define PIPE_MANIFOLD4W			19
#define PIPE_CAP				20
///// Z-Level stuff
#define PIPE_UP					21
#define PIPE_DOWN				22
///// Z-Level stuff
#define PIPE_GAS_FILTER_M		23
#define PIPE_GAS_MIXER_T		24
#define PIPE_GAS_MIXER_M		25
#define PIPE_OMNI_MIXER			26
#define PIPE_OMNI_FILTER		27
///// Supply, scrubbers and universal pipes
#define PIPE_UNIVERSAL				28
#define PIPE_SUPPLY_STRAIGHT		29
#define PIPE_SUPPLY_BENT			30
#define PIPE_SCRUBBERS_STRAIGHT		31
#define PIPE_SCRUBBERS_BENT			32
#define PIPE_SUPPLY_MANIFOLD		33
#define PIPE_SCRUBBERS_MANIFOLD		34
#define PIPE_SUPPLY_MANIFOLD4W		35
#define PIPE_SCRUBBERS_MANIFOLD4W	36
#define PIPE_SUPPLY_UP				37
#define PIPE_SCRUBBERS_UP			38
#define PIPE_SUPPLY_DOWN			39
#define PIPE_SCRUBBERS_DOWN			40
#define PIPE_SUPPLY_CAP				41
#define PIPE_SCRUBBERS_CAP			42
///// Mirrored T-valve ~ because I couldn't be bothered re-sorting all of the defines
#define PIPE_MTVALVEM				43
///// I also couldn't be bothered sorting, so automatic shutoff valve.
#define PIPE_SVALVE					44

#define PIPE_FUEL_STRAIGHT       45
#define PIPE_FUEL_BENT           46
#define PIPE_FUEL_MANIFOLD       47
#define PIPE_FUEL_MANIFOLD4W     48
#define PIPE_FUEL_UP             49
#define PIPE_FUEL_DOWN           50
#define PIPE_FUEL_CAP            51

#define CONNECT_TYPE_REGULAR	1
#define CONNECT_TYPE_SUPPLY		2
#define CONNECT_TYPE_SCRUBBER	4
#define CONNECT_TYPE_HE			8

#define ADIABATIC_EXPONENT 0.667 //Actually adiabatic exponent - 1.
