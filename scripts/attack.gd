extends Area2D

var eType = 0
var isEnemy := true
var isCoin := false

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

func disAll():
	match eType:
		0:
			$knight.disabled = true
			await get_tree().create_timer(1).timeout
			$knight.disabled = false
		1:
			$archer.disabled = true
			await get_tree().create_timer(1).timeout
			$archer.disabled = false
		2:
			$mage1.disabled = true
			$mage2.disabled = true
			await get_tree().create_timer(1).timeout
			$mage1.disabled = false
			$mage2.disabled = false
