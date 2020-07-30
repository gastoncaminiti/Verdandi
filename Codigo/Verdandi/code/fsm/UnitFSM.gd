extends AnimationTree

func _ready():
	update_brain_choises()
	# INIT IN BRAIN
	self.get("parameters/playback").start("BRAIN")

func update_brain_choises():
	reset_brain_choises()
	# CONDITIONS: DIRECCTION SELECT
	match get_parent().unit_stats.orientation:
		0:
			self["parameters/conditions/LookN"]  = true
		1:
			self["parameters/conditions/LookNE"] = true
		2:
			self["parameters/conditions/LookE"]  = true
		3:
			self["parameters/conditions/LookSE"] = true
		4:
			self["parameters/conditions/LookS"]  = true
		5:
			self["parameters/conditions/LookSW"] = true
		6:
			self["parameters/conditions/LookW"]  = true
		7:
			self["parameters/conditions/LookNW"] = true

func reset_brain_choises():
	self["parameters/conditions/LookN"]  = false
	self["parameters/conditions/LookNE"] = false
	self["parameters/conditions/LookE"]  = false
	self["parameters/conditions/LookSE"] = false
	self["parameters/conditions/LookS"]  = false
	self["parameters/conditions/LookSW"] = false
	self["parameters/conditions/LookW"]  = false
	self["parameters/conditions/LookNW"] = false

func update_idle_choises():
	reset_idle_choises()
	# CONDITIONS: DIRECCTION SELECT
	match get_parent().unit_stats.orientation:
		0:
			self["parameters/conditions/NotLookN"]  = true
		1:
			self["parameters/conditions/NotLookNE"] = true
		2:
			self["parameters/conditions/NotLookE"]  = true
		3:
			self["parameters/conditions/NotLookSE"] = true
		4:
			self["parameters/conditions/NotLookS"]  = true
		5:
			self["parameters/conditions/NotLookSW"] = true
		6:
			self["parameters/conditions/NotLookW"]  = true
		7:
			self["parameters/conditions/NotLookNW"] = true

func reset_idle_choises():
	self["parameters/conditions/NotLookN"]  = false
	self["parameters/conditions/NotLookNE"] = false
	self["parameters/conditions/NotLookE"]  = false
	self["parameters/conditions/NotLookSE"] = false
	self["parameters/conditions/NotLookS"]  = false
	self["parameters/conditions/NotLookSW"] = false
	self["parameters/conditions/NotLookW"]  = false
	self["parameters/conditions/NotLookNW"] = false

func update_walk_choise():
	if get_parent().is_status("WALK"):
		self["parameters/conditions/Walk"]    = true
		self["parameters/conditions/NotWalk"] = false
	else:
		self["parameters/conditions/NotWalk"] = true
		self["parameters/conditions/Walk"]    = false

func update_attack_choise():
	if get_parent().is_status("ATTACK"):
		self["parameters/conditions/Attack"]    = true
		self["parameters/conditions/NotAttack"] = false
	else:
		self["parameters/conditions/Attack"]    = false
		self["parameters/conditions/NotAttack"] = true
