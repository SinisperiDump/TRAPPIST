class_name AlienData extends Resource

enum CombatType { SWARMER, SPEWER, JAGGERNAUT }
@export var combat_type: CombatType
@export var max_health: float
@export var speed: float
@export var damage: float

var name: String:
	get():
		match combat_type:
			CombatType.SWARMER:
				return "Swarmer"
			CombatType.SPEWER:
				return "Spewer"
			CombatType.JAGGERNAUT:
				return "Jaggernaut"
			_:
				return "Undefined"
