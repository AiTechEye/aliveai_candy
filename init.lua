aliveai.create_bot({
		attack_players=1,
		name="ball",
		team="candy",
		type="monster",
		texture="aliveai_candy_icecreammonstermaster.png^[colorize:#ff75ec55",
		mesh="aliveai_candy_icecreamball.b3d",
		animation={
			stand={x=0,y=0,speed=0},
			lay={x=0,y=0,speed=0},
			walk={x=1,y=80,speed=-40},
			mine={x=1,y=8,speed=-60},
		},
		collisionbox={-0.2,-0.25,-0.2,0.2,0.25,0.2},
		talking=0,
		light=0,
		building=0,
		hp=60,
		arm=2,
		dmg=2,
		name_color="",
		escape=0,
		attack_chance=2,
		smartfight=0,
		drop_dead_body=0,
		spawn_on={"group:candy_ground"},
		basey=0,
		visual_size={x=0.5,y=0.5},
	death=function(self,puncher)
		local pos=self.object:get_pos()
		aliveai.lookat(self,pos)
		minetest.add_particlespawner({
			amount = 5,
			time =0.05,
			minpos = pos,
			maxpos = pos,
			minvel = {x=-2, y=-2, z=-2},
			maxvel = {x=1, y=0.5, z=1},
			minacc = {x=0, y=-8, z=0},
			maxacc = {x=0, y=-10, z=0},
			minexptime = 2,
			maxexptime = 1,
			minsize = 0.2,
			maxsize = 2,
			texture = "aliveai_candy_icecreammonstermaster.png^[colorize:#ff75ec55",
			collisiondetection = true,
		})
	end
})


aliveai.create_bot({
		attack_players=1,
		name="gingerbread",
		team="candy",
		type="monster",
		texture="aliveai_candy_gingerbread.png",
		mesh="aliveai_candy_gingerbread.b3d",
		animation={
			stand={x=31,y=35,speed=0},
			walk={x=0,y=20,speed=60},
			mine={x=21,y=30,speed=30},
		},
		collisionbox={-0.2,-0.25,-0.2,0.2,0.25,0.2},
		talking=0,
		light=0,
		building=0,
		hp=1,
		arm=2,
		name_color="",
		escape=0,
		attack_chance=2,
		smartfight=0,
		drop_dead_body=0,
		spawn_on={"group:candy_underground","group:candy_ground"},
		start_with_items={["aliveai_candy:gingerbread_piece1"]=1,["aliveai_candy:gingerbread_piece2"]=1},
		basey=0,
	on_punched=function(self,puncher)
		local pos=self.object:get_pos()
		aliveai.lookat(self,pos)
		minetest.add_particlespawner({
			amount = 5,
			time =0.05,
			minpos = pos,
			maxpos = pos,
			minvel = {x=-2, y=-2, z=-2},
			maxvel = {x=1, y=0.5, z=1},
			minacc = {x=0, y=-8, z=0},
			maxacc = {x=0, y=-10, z=0},
			minexptime = 2,
			maxexptime = 1,
			minsize = 0.2,
			maxsize = 2,
			texture = "aliveai_candy_gingerbread_piece1.png",
			collisiondetection = true,
		})
	end
})


aliveai.create_bot({
		attack_players=1,
		name="icecreammonstermaster",
		team="candy",
		type="monster",
		texture="aliveai_candy_icecreammonstermaster.png",
		mesh="aliveai_candy_icecreammaster.b3d",
		animation={
			stand={x=40,y=80,speed=30},
			walk={x=0,y=30,speed=30},
			mine={x=80,y=105,speed=90},
			lay={x=142,y=149,speed=0},
			throw={x=105,y=140,speed=30}
		},
		collisionbox={-1,-1.0,-1,1,3,1},
		talking=0,
		light=0,
		building=0,
		hp=40,
		dmg=0,
		arm=5,
		name_color="",
		escape=0,
		attack_chance=2,
		smartfight=0,
		mindamage=3,
		spawn_on={"group:candy_underground","group:candy_ground"},
	spawn=function(self)
		self.inv={["aliveai_candy:icecreamball"]=9}
	end,
	on_step=function(self,dtime)
		if not self.throwing and self.fight and aliveai.visiable(self,self.fight) and aliveai.viewfield(self,self.fight) then
			local pos2=self.fight:get_pos()
			local pos1=self.object:get_pos()
			local d=aliveai.distance(pos1,pos2)
			if d>5 then
				self.is_throwing=1
				self.throwing=1
				self.time=self.otime
				aliveai.stand(self)
				aliveai.lookat(self,pos2)
				aliveai.anim(self,"throw")
				d=d*0.05
				local p=aliveai.pointat(self,4)
				minetest.after(0.7, function(p,d,self)
					local pos2=self.fight:get_pos()
					local pos1=self.object:get_pos()
					if not (pos1 and pos2 and self) then return end
					local d={x=aliveai.nan((pos2.x-pos1.x)*d),y=aliveai.nan((pos2.y-pos1.y)*d),z=aliveai.nan((pos2.z-pos1.z)*d)}
					aliveai.lookat(self,pos2)
					minetest.add_entity({x=p.x,y=p.y+3,z=p.z}, "aliveai_candy:icecreamball"):setvelocity(d)
				end,p,d,self)
					minetest.after(1.2, function(self)
						if not self then return end
						self.throwing=nil
						aliveai.stand(self)
					end,self)
				return self
			end
		elseif not self.throwing and self.is_throwing then
			self.is_throwing=nil
			aliveai.stand(self)
		elseif self.throwing and self.fight then
			aliveai.lookat(self,self.fight:get_pos())
			return self
		end
	end,
	on_punch_hit=function(self,target)
		local pos=self.object:get_pos()
		pos.y=pos.y-0.5
		for _, ob in ipairs(minetest.get_objects_inside_radius(pos, 5)) do
			local pos2=aliveai.roundpos(ob:get_pos())
			if aliveai.team(ob)~=self.team and aliveai.visiable(self,pos2) and aliveai.viewfield(self,pos2) then
				if ob:is_player() then
					local p2={x=pos2.x-pos.x, y=pos2.y-pos.y, z=pos2.z-pos.z}
					local a
					local ii1
					local ii2
					for i=1,10,1 do
						ii=i+1
						ii2=i
						if aliveai.def({x=pos.x+(p2.x*ii), y=pos.y+(p2.y*ii)+2, z=pos.z+(p2.z*ii)},"walkable") then
							break
						end
					end
					ob:set_pos({x=pos.x+(p2.x*ii2), y=pos.y+(p2.y*ii2)+2, z=pos.z+(p2.z*ii2)})
					aliveai.punch(self,ob,10)
				elseif ob then
					aliveai.punch(self,ob,10)
					ob:setvelocity({x=(pos2.x-pos.x)*20, y=((pos2.y-pos.y))*30, z=(pos2.z-pos.z)*20})


				end
			end
end
	end,
	on_punched=function(self,puncher)
		local pos=self.object:get_pos()
		aliveai.lookat(self,pos)
		aliveai.anim(self,"throw")
		minetest.add_particlespawner({
			amount = 5,
			time =0.05,
			minpos = pos,
			maxpos = pos,
			minvel = {x=-2, y=-2, z=-2},
			maxvel = {x=1, y=0.5, z=1},
			minacc = {x=0, y=-8, z=0},
			maxacc = {x=0, y=-10, z=0},
			minexptime = 2,
			maxexptime = 1,
			minsize = 0.5,
			maxsize = 2,
			texture = "aliveai_candy_icecreamball.png",
			collisiondetection = true,
		})
	end
})

minetest.register_tool("aliveai_candy:icecreamball", {
	description = "Icecream ball",
	range = 1,
	inventory_image = "aliveai_candy_icecreamball.png",
	on_use = function(itemstack, user, pointed_thing)
		local dir=user:get_look_dir()
		local pos=user:get_pos()
		pos.y=pos.y+1.5
		local d={x=dir.x*15,y=dir.y*15,z=dir.z*15}
		local e=minetest.add_entity({x=pos.x+(dir.x*3),y=pos.y+(dir.y*3),z=pos.z+(dir.z*3)}, "aliveai_candy:icecreamball")
		e:setvelocity(d)
		itemstack:add_wear(65536)
		return itemstack
	end,
})


minetest.register_entity("aliveai_candy:icecreamball",{
	hp_max = 10,
	physical =false,
	visual = "mesh",
	mesh="aliveai_candy_icecreamball.b3d",
	textures ={"aliveai_candy_icecreammonstermaster.png"},
	on_activate=function(self, staticdata)
		self.object:set_animation({x=1,y=80,},30,0)
		self.object:setacceleration({x=0,y=-10,z =0})
		self.att={}
	end,
	on_step=function(self, dtime)
		local pos=self.object:getpos()
		local p
		for _, ob in ipairs(minetest.get_objects_inside_radius(pos, 2.5)) do
			if aliveai.team(ob)~="candy" and not ob:get_attach() and aliveai.visiable(self,ob:get_pos()) then
				aliveai.punchdmg(ob,10)
				table.insert(self.att,ob)
				ob:set_attach(self.object, "", {x=0,y=0,z=0}, {x=0,y=0,z=0})
			end
		end
		if aliveai.def(pos,"walkable") then
			for _, ob in pairs(self.att) do
				if ob then
					ob:set_detach()
				end
			end
			self.object:remove()
		end
	end,
	team="candy",
})



aliveai.create_bot({
		attack_players=1,
		name="candycane",
		team="candy",
		type="monster",
		texture="aliveai_candy_candycane.png",
		mesh="aliveai_candy_candycane.b3d",
		animation={
			stand={x=1,y=150,speed=30,loop=0},
			walk={x=155,y=170,speed=30,loop=0},
			mine={x=180,y=195,speed=30,loop=0},
			lay={x=201,y=211,speed=0,loop=0}
		},
		collisionbox={-0.35,-1.0,-0.35,0.35,0.8,0.35},
		talking=0,
		light=0,
		building=0,
		hp=40,
		dmg=4,
		arm=2,
		name_color="",
		escape=0,
		attack_chance=2,
		smartfight=0,
		spawn_on={"group:candy_underground","group:candy_ground"},
	spawn=function(self)
		local n=0
		local t="0123456789ABCDEF"
		self.storge1=""
  		for i=1,6,1 do
        			n=math.random(1,16)
       			self.storge1=self.storge1 .. string.sub(t,n,n)
		end
		self.object:set_properties({textures={"aliveai_grey.png^[colorize:#" .. self.storge1 .."ff^aliveai_candy_candycane.png"}})
		print("aliveai_air.png^[colorize:#" .. self.storge1 .."ff^aliveai_candy_candycane.png")
	end,
	on_load=function(self)
		if not self.storge1 then
			self.spawn(self)
			return self
		end
		self.object:set_properties({textures={"aliveai_grey.png^[colorize:#" .. self.storge1 .."ff^aliveai_candy_candycane.png"}})
	end,
	on_punched=function(self,puncher)
		local pos=self.object:get_pos()
		aliveai.lookat(self,pos)
		minetest.add_particlespawner({
			amount = 5,
			time =0.05,
			minpos = pos,
			maxpos = pos,
			minvel = {x=-2, y=-2, z=-2},
			maxvel = {x=1, y=0.5, z=1},
			minacc = {x=0, y=-8, z=0},
			maxacc = {x=0, y=-10, z=0},
			minexptime = 2,
			maxexptime = 1,
			minsize = 0.2,
			maxsize = 2,
			texture = "aliveai_candy_candycane_piece.png^[colorize:#" .. self.storge1 .."ff^aliveai_candy_candycane.png",
			collisiondetection = true,
		})
	end,
	death=function(self,puncher,pos)
		aliveai.invadd(self,"aliveai_candy:candycane_piece",1)
	end,
})

aliveai.create_bot({
		attack_players=1,
		name="lollipop",
		team="candy",
		type="monster",
		texture="aliveai_candy_lollipop.png",
		mesh="aliveai_candy_lollipop.b3d",
		animation={
			stand={x=20,y=360,speed=30},
			walk={x=1,y=20,speed=30},
			mine={x=370,y=380,speed=30},
			lay={x=381,y=386,speed=0}
		},
		collisionbox={-0.35,-1.0,-0.35,0.35,1,0.35},
		talking=0,
		light=0,
		building=0,
		hp=40,
		dmg=4,
		arm=2,
		name_color="",
		escape=0,
		attack_chance=2,
		smartfight=0,
		spawn_on={"group:candy_underground","group:candy_ground"},
	on_punched=function(self,puncher)
		local pos=self.object:get_pos()
		aliveai.lookat(self,pos)
		minetest.add_particlespawner({
			amount = 5,
			time =0.05,
			minpos = pos,
			maxpos = pos,
			minvel = {x=-2, y=-2, z=-2},
			maxvel = {x=1, y=0.5, z=1},
			minacc = {x=0, y=-8, z=0},
			maxacc = {x=0, y=-10, z=0},
			minexptime = 2,
			maxexptime = 1,
			minsize = 0.2,
			maxsize = 2,
			texture = "aliveai_candy_lollipop_piece.png",
			collisiondetection = true,
		})
	end,
	death=function(self,puncher,pos)
		aliveai.invadd(self,"aliveai_candy:lollipop_piece",1)
	end,
})


minetest.register_biome({
	name="candyland",
	--node_dust="",
	node_top="aliveai_candy:sugar_with_glaze",
	depth_top=1,
	node_filler="aliveai_candy:sugar",
	depth_filler=5,
	node_stone="aliveai_candy:sponge_cake",
	--node_water_top="",
	--depth_water_top=10,
	node_water="aliveai_candy:gel2",
	node_river_water="aliveai_candy:gel",
	--node_riverbed="",
	--depth_riverbed=2,
	y_min=-50,
	y_max=31000,
	heat_point=60,
	humidity_point=67,
})



minetest.register_node("aliveai_candy:sugar", {
	description = "Sugar",
	groups = {crumbly=3,soil=1,candy_ground=1},
	tiles = {"aliveai_candy_sugar.png"},
	sounds=default.node_sound_dirt_defaults({footstep={name="default_snow_footstep"},dug={name="default_snow_footstep"},dig={name="default_snow_footstep"}}),
})

minetest.register_node("aliveai_candy:sugar_with_glaze", {
	description = "Sugar with glaze",
	groups = {crumbly=3,spreading_dirt_type=1,candy_ground=1},
	tiles = {"aliveai_candy_glaze.png","aliveai_candy_sugar.png","aliveai_candy_sugar.png^aliveai_candy_glaze_side.png"},
	sounds=default.node_sound_dirt_defaults({footstep={name="default_snow_footstep"},dug={name="default_snow_footstep"},dig={name="default_snow_footstep"}}),
})

minetest.register_node("aliveai_candy:sponge_cake", {
	description = "Sponge cake",
	groups = {cracky=3,candy_underground=1},
	tiles = {"aliveai_candy_spongecake.png"},
	sounds=default.node_sound_wood_defaults(),
})


minetest.register_node("aliveai_candy:gel", {
	description = "Gel",
	drawtype = "liquid",
	tiles = {"default_water.png^[colorize:#00ff1155"},
	alpha=200,
	paramtype = "light",
	walkable = false,
	buildable_to = true,
	is_ground_content = false,
	drowning = 1,
	liquidtype = "source",
	liquid_range = 2,
	liquid_alternative_flowing = "aliveai_candy:gel_flowing",
	liquid_alternative_source = "aliveai_candy:gel",
	liquid_viscosity = 15,
	post_effect_color = {a=160,r=0,g=150,b=100},
	groups = {liquid = 4,crumbly = 1, sand = 1},
})

minetest.register_node("aliveai_candy:gel_flowing", {
	description = "Gel flowing",
	drawtype = "flowingliquid",
	tiles = {"default_water.png^[colorize:#00ff1155"},
	special_tiles = {
		{
			name = "default_water.png^[colorize:#00ff1155",
			backface_culling = false,
		},
		{
			name = "default_water.png^[colorize:#00ff1155",
			backface_culling = true,
		},
	},
	paramtype2 = "flowingliquid",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "flowing",
	liquid_alternative_flowing = "aliveai_candy:gel_flowing",
	liquid_alternative_source = "aliveai_candy:gel",
	liquid_viscosity = 1,
	liquid_range = 2,
	post_effect_color = {a=160,r=0,g=150,b=100},
	groups = {liquid = 4, not_in_creative_inventory = 1},
})

minetest.register_node("aliveai_candy:gel2", {
	description = "Gel 2",
	drawtype = "liquid",
	tiles = {"default_clay.png^[colorize:#00ff0055"},
	alpha=200,
	paramtype = "light",
	walkable = false,
	buildable_to = true,
	is_ground_content = false,
	drowning = 1,
	liquidtype = "source",
	liquid_range = 2,
	liquid_alternative_flowing = "aliveai_candy:gel_flowing2",
	liquid_alternative_source = "aliveai_candy:gel2",
	liquid_viscosity = 15,
	post_effect_color = {a=60,r=0,g=150,b=0},
	groups = {liquid = 4,crumbly = 1, sand = 1},
})

minetest.register_node("aliveai_candy:gel_flowing2", {
	description = "Gel flowing",
	drawtype = "flowingliquid",
	tiles = {"default_clay.png^[colorize:#00ff0055"},
	special_tiles = {
		{
			name = "default_clay.png^[colorize:#00ff0055",
			backface_culling = false,
		},
		{
			name = "default_clay.png^[colorize:#00ff0055",
			backface_culling = true,
		},
	},
	paramtype2 = "flowingliquid",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "flowing",
	liquid_alternative_flowing = "aliveai_candy:gel_flowing2",
	liquid_alternative_source = "aliveai_candy:gel2",
	liquid_viscosity = 1,
	liquid_range = 2,
	post_effect_color = {a=60,r=0,g=150,b=0},
	groups = {liquid = 4, not_in_creative_inventory = 1},
})

minetest.register_craftitem("aliveai_candy:gingerbread_piece1", {
	description = "Gingerbread piece",
	inventory_image = "aliveai_candy_gingerbread_piece1.png",
	on_use =minetest.item_eat(1)
})
minetest.register_craftitem("aliveai_candy:gingerbread_piece2", {
	description = "Gingerbread piece",
	inventory_image = "aliveai_candy_gingerbread_piece2.png",
	on_use =minetest.item_eat(1)
})
minetest.register_craftitem("aliveai_candy:lollipop_piece", {
	description = "Lollipop piece",
	inventory_image = "aliveai_candy_lollipop_piece.png",
	on_use =minetest.item_eat(5)
})
minetest.register_craftitem("aliveai_candy:candycane_piece", {
	description = "Candycane piece",
	inventory_image = "aliveai_candy_candycane_piece.png",
	on_use =minetest.item_eat(5)
})