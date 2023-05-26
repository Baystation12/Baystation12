#define SKILL_UNSKILLED   1
#define SKILL_BASIC       2
#define SKILL_TRAINED     3
#define SKILL_EXPERIENCED 4
#define SKILL_MASTER      5
#define HAS_PERK          SKILL_UNSKILLED + 1

/// Min skill value selectable
#define SKILL_MIN      SKILL_UNSKILLED
/// Max skill value selectable
#define SKILL_MAX      SKILL_MASTER
/// Default skill value for mobs
#define SKILL_DEFAULT  SKILL_EXPERIENCED
/// Baseline skill level used for determining mechanical skill multipliers.
#define SKILL_BASELINE SKILL_TRAINED

#define SKILL_EASY     SKILL_UNSKILLED
#define SKILL_AVERAGE  SKILL_BASIC
#define SKILL_HARD     SKILL_EXPERIENCED

#define SKILL_BUREAUCRACY   /singleton/hierarchy/skill/organizational/bureaucracy
#define SKILL_FINANCE       /singleton/hierarchy/skill/organizational/finance
#define SKILL_EVA           /singleton/hierarchy/skill/general/EVA
#define SKILL_MECH          /singleton/hierarchy/skill/general/EVA/mech
#define SKILL_PILOT         /singleton/hierarchy/skill/general/pilot
#define SKILL_HAULING       /singleton/hierarchy/skill/general/hauling
#define SKILL_COMPUTER      /singleton/hierarchy/skill/general/computer
#define SKILL_BOTANY        /singleton/hierarchy/skill/service/botany
#define SKILL_COOKING       /singleton/hierarchy/skill/service/cooking
#define SKILL_COMBAT        /singleton/hierarchy/skill/security/combat
#define SKILL_WEAPONS       /singleton/hierarchy/skill/security/weapons
#define SKILL_FORENSICS     /singleton/hierarchy/skill/security/forensics
#define SKILL_CONSTRUCTION  /singleton/hierarchy/skill/engineering/construction
#define SKILL_ELECTRICAL    /singleton/hierarchy/skill/engineering/electrical
#define SKILL_ATMOS         /singleton/hierarchy/skill/engineering/atmos
#define SKILL_ENGINES       /singleton/hierarchy/skill/engineering/engines
#define SKILL_DEVICES       /singleton/hierarchy/skill/research/devices
#define SKILL_SCIENCE       /singleton/hierarchy/skill/research/science
#define SKILL_MEDICAL       /singleton/hierarchy/skill/medical/medical
#define SKILL_ANATOMY       /singleton/hierarchy/skill/medical/anatomy
#define SKILL_CHEMISTRY     /singleton/hierarchy/skill/medical/chemistry
