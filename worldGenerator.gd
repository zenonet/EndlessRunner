extends Node3D

@export var chunkScenes:Array[PackedScene]
@export var chunkCount:float = 3
@export var chunkLength:float = 4
@export var speed:float = 12


func _ready():
	for i in range(chunkCount):
		generate_chunk(i)

func generate_chunk(offset:int = chunkCount/2):
	var chunk_to_create:PackedScene = chunkScenes.pick_random()
	var chunk:Node3D = chunk_to_create.instantiate()
	
	self.add_child(chunk)
	chunk.position.z = offset*chunkLength
	
func _process(delta):
	for c in get_children():
		c.position.z -= speed*delta
		if c.position.z < -chunkLength*2:
			print("Removing old chunk")
			c.queue_free()
			generate_chunk()
