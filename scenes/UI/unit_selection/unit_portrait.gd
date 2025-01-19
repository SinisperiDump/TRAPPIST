extends PanelContainer


var portrait: Texture2D:
	set(texture_in):
		texture_rect.texture = texture_in

@onready var texture_rect: TextureRect = %TextureRect
