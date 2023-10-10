extends Area


func _ready():
	self.connect("delete", self, "delete")

func delete():
	queue_free()
