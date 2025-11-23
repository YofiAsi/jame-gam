class_name SimpleGuy extends Man

func _ready() -> void:
	job = Job.FOOD
	super._ready()

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
