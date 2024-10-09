extends Object
class_name Bullet

const BULLET_COUNT: int = 1000

var position: Vector2
var velocity: Vector2
var active: bool = false

static var multiMesh: MultiMeshInstance2D
static var activeBulletCount: int = 0
static var bullets: Array[Bullet] = []
static var inactiveBullets: Array[Bullet] = []

func _init() -> void:
	position = Vector2.ZERO
	velocity = Vector2.ZERO
	inactiveBullets.append(self)

static func initializeBullets(_multiMesh: MultiMeshInstance2D):
	multiMesh = _multiMesh
	multiMesh.multimesh.instance_count = BULLET_COUNT
	for i in BULLET_COUNT:
		bullets.append(Bullet.new())

static func cleanupBullets():
	assert(!bullets.is_empty())
	for bullet in bullets:
		bullet.deactivate()

static func getBullet() -> Bullet:
	assert(!inactiveBullets.is_empty())
	activeBulletCount += 1
	return inactiveBullets.pop_back()


static func processBullets(delta: float):
	for i in bullets.size():
		if bullets[i].active:
			bullets[i].move(delta)
			var bulletTransform: Transform2D = Transform2D.IDENTITY
			bulletTransform.origin = bullets[i].position
			if bullets[i].outOfBounds():
				bullets[i].deactivate()
			multiMesh.multimesh.set_instance_color(i, Color.WHITE)
			multiMesh.multimesh.set_instance_transform_2d(i, bulletTransform)
		else:
			multiMesh.multimesh.set_instance_color(i, Color.TRANSPARENT)
	

func move(delta: float):
	position += velocity * delta

func outOfBounds() -> bool:
	return position.x < 0 || position.x > 1280 || position.y < 0 || position.y > 720

func activate(_pos: Vector2, _vel: Vector2):
	position = _pos
	velocity = _vel
	active = true

func deactivate():
	velocity = Vector2.ZERO
	position = Vector2.ZERO
	activeBulletCount -= 1
	active = false
	inactiveBullets.append(self)
