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
    self._background = Entity.create(self._world)
    SpriteRenderer.create(self._background, Vector2(0,0), self._view_size)
    SpriteRenderer.set_material(self._background, self._background_material)
    --Drawable.set_depth(self._background, -1)
    
    self._rocket = Rocket()
    self._rocket:spawn(self._world)
    Engine.load_resource("sprite", "sprites/ground.sprite")
    self._background_material = Engine.load_resource("material", "sprites/ground.material")
    self._ground = Entity.create(self._world)
    SpriteRenderer.create(self._ground, Vector2(0,0), Vector2(1280,400))
    SpriteRenderer.set_material(self._ground, self._background_material)
    Transform.set_position(self._ground, Vector2(-443,600))
end

function Game:deinit()
    local engine = Engine.engine()
    World.destroy(engine, self._world)
end

t = 0

function Game:update(dt)
    t = t + dt


    self._rocket:update(dt, self._view_size)
    local rocket_pos = self._rocket:position()
    Transform.set_position(self._background, rocket_pos - self._view_size * 0.5)
    self._view_pos = rocket_pos * -1 + self._view_size * 0.5
    Material.set_uniform_value(self._background_material, "height", Vector4(1+(rocket_pos.y/10000), 0, 0, 0))
    World.update(self._world)
end

function Game:draw()
    World.draw(self._world, self._view_pos, self._view_size)
end

return Game
