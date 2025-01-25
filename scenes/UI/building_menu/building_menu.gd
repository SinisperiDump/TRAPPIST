extends PanelContainer

@onready var building_list: GridContainer = %BuildingList
@onready var building_description: Label = %BuildingDescription


func _ready() -> void:
	for i in building_list.get_children():
		i.button_hovered.connect(_on_building_button_over)


func _on_building_button_over(des: String) -> void:
	building_description.text = des
