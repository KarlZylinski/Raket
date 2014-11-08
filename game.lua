require "rocket"

Game = class(Game)

function Game:init()
    local engine = Engine.engine()
    Engine.load_resource("material", "default.material")
    Engine.set_default_resource("material", "default.material")
    self._world = World.create(engine)
    self._view_pos = Vector2(0, 0)
    self._view_size = Vector2(1280, 720)
    self._background_material = Engine.load_resource("material", "background.material")
    self._background = Rectangle.spawn(self._world, Vector2(0,0), self._view_size, Color(1, 1, 1, 1))
    Drawable.set_material(self._background, self._background_material)
    Drawable.set_depth(self._background, -1)
    self._rocket = Rocket()
    self._rocket:spawn(self._world)
    Engine.load_resource("sprite", "sprites/ground.sprite")
    self._sprite = Sprite.spawn(self._world, "sprites/ground.sprite", 25)
    self._ground = Drawable.set_position(self._sprite, Vector2(-443,600))

    self._test_entity = Entity.create()
    self._test_rectangle_comp = RectangleRendererComponent.create(self._test_entity, self._world, Vector2(0,0), Vector2(300, 300))
    local test_transform = TransformComponent.get(self._test_entity, self._world)
    TransformComponent.set_position(test_transform, Vector2(400, 400))
    TransformComponent.set_pivot(test_transform, Vector2(150, 150))

    self._test_entity2 = Entity.create()
    self._test_rectangle_comp2 = RectangleRendererComponent.create(self._test_entity2, self._world, Vector2(0,0), Vector2(50, 50), Color(1, 0, 0, 1))
    TransformComponent.set_position(TransformComponent.get(self._test_entity2, self._world), Vector2(50, 50))
    TransformComponent.set_parent(TransformComponent.get(self._test_entity2, self._world), self._test_entity)

    self._test_entity3 = Entity.create()
    self._test_rectangle_comp3 = RectangleRendererComponent.create(self._test_entity3, self._world, Vector2(0,0), Vector2(10, 10), Color(0, 1, 0, 1))
    TransformComponent.set_parent(TransformComponent.get(self._test_entity3, self._world), self._test_entity2)
    TransformComponent.set_position(TransformComponent.get(self._test_entity3, self._world), Vector2(10, 10))
end

function Game:deinit()
    local engine = Engine.engine()
    World.destroy(engine, self._world)
end

t = 0

function Game:update(dt)
    t = t + dt

    local test_transform = TransformComponent.get(self._test_entity, self._world)
    TransformComponent.set_rotation(test_transform, t)

    TransformComponent.set_rotation(TransformComponent.get(self._test_entity3, self._world), -t*10)

    --[[self._rocket:update(dt, self._view_size)
    local rocket_pos = self._rocket:position()
    Drawable.set_position(self._background, rocket_pos - self._view_size * 0.5)
    self._view_pos = rocket_pos * -1 + self._view_size * 0.5
    Material.set_uniform_value(self._background_material, "height", Vector4(1+(rocket_pos.y/10000), 0, 0, 0))]]
    World.update(self._world)
end

function Game:draw()
    World.draw(self._world, self._view_pos, self._view_size)
end

return Game
