extends Node3D

var animal:PackedScene = preload("res://scenes/obstacles/animal.tscn")
@export var chunkScenes:Array[PackedScene]
@export var chunkCount:float = 3
@export var chunkLength:float = 4

func _ready():
	for i in range(chunkCount):
		generate_chunk(i, 0 if i == 0 else -1)

func generate_chunk(offset:int = chunkCount/2, chunkId:int = -1):
	var chunk_to_create:PackedScene = chunkScenes.pick_random() if chunkId == -1 else chunkScenes[chunkId]
	var chunk:Node3D = chunk_to_create.instantiate()
	
	self.add_child(chunk)
	chunk.position.z = offset*chunkLength
	
	for c in chunk.get_children():
		if c.is_in_group("spawn") && randi()%4 == 0:
			# print("Spawing animal in chunk %d at z=%d" % [offset, chunk.global_position.z])
			var a = animal.instantiate()
			get_parent().add_child.call_deferred(a)
			a.global_position = c.global_position
			a.targetX = a.position.x
	
func _process(delta):
	GameManager.distance += GameManager.playerSpeed*delta
	# GameManager.playerSpeed += delta * 0.25
	for c in get_children():
		c.position.z -= GameManager.playerSpeed*delta
		if c.position.z < -chunkLength*2:
			# print("Removing old chunk")
			c.queue_free()
			generate_chunk()

func reset():
	# clear
	for c in get_children():
		c.queue_free()
