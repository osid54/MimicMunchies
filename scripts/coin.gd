extends Area2D

var isCoin := true
var isEnemy := false

func _ready():
	modulate = Color(1,1,1,0)
	var tween = get_tree().create_tween()
	tween.tween_property(self,"modulate",Color.WHITE,.2)
