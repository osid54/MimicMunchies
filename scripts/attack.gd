extends Area2D

var eType = 0

func adjust():
	match eType:
		0:
			$knight.visible = true
			$knight.disabled = false
		1:
			$archer.visible = true
			$archer.disabled = false
		2:
			$mage1.visible = true
			$mage1.disabled = false
			$mage2.visible = true
			$mage2.disabled = false

func _on_area_entered(area):
	area.get_parent().visible = false