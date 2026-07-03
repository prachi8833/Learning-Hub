-- Science starter question set — 48 questions across all 8 Science topics
-- (Plant Paradise, Human Body Lab, Animal Kingdom, Weather World, Volcano Valley,
--  Space Station, Forces & Matter, Living World)
-- topic = the module 'key' column, so questions link to the right learning topic.
-- Grade 1 rows -> Kairav, level 1. Grade 3 rows -> Riaan, level 2.

insert into questions (subject_key, topic, level, grade, question, answer, wrong1, wrong2, wrong3, explanation, active) values

-- Plant Paradise (plants)
('science','plants',1,1,'What part of the plant grows under the ground?','Roots','Leaves','Flower','Stem','Roots grow under the ground and help the plant drink water.',true),
('science','plants',1,1,'What do plants need to make their own food?','Sunlight','Darkness','Ice','Sand','Plants use sunlight to make their food.',true),
('science','plants',1,1,'What part of the plant makes seeds?','Flower','Root','Stem','Leaf','Flowers make seeds that grow into new plants.',true),
('science','plants',2,3,'Which part of a plant absorbs sunlight to make food?','Leaves','Roots','Petals','Seeds','Leaves capture sunlight and make food for the whole plant.',true),
('science','plants',2,3,'What is it called when a seed starts to sprout and grow?','Germination','Pollination','Photosynthesis','Evaporation','Germination is when a seed begins to sprout and grow into a new plant.',true),
('science','plants',2,3,'Which part of the plant takes in water from the soil?','Roots','Petals','Stem','Flower','Roots soak up water and nutrients from the soil.',true),

-- Human Body Lab (body)
('science','body',1,1,'How many senses do people have?','Five','Three','Seven','Ten','We have five senses: sight, hearing, smell, taste, and touch.',true),
('science','body',1,1,'Which body part do you use to hear?','Ears','Eyes','Nose','Hands','Ears help us hear sounds around us.',true),
('science','body',1,1,'Which body part pumps blood around your body?','Heart','Lungs','Stomach','Brain','Your heart pumps blood to every part of your body.',true),
('science','body',2,3,'Which body system helps you breathe?','Respiratory system','Digestive system','Skeletal system','Nervous system','The respiratory system, including your lungs, helps you breathe.',true),
('science','body',2,3,'What do we call the framework of bones inside your body?','Skeleton','Muscle','Skin','Organ','Your skeleton is made of bones that support and protect your body.',true),
('science','body',2,3,'Which organ controls your body and helps you think?','Brain','Heart','Liver','Stomach','The brain controls your body and helps you think, learn, and feel.',true),

-- Animal Kingdom (animals)
('science','animals',1,1,'What do we call a baby dog?','Puppy','Kitten','Cub','Foal','A baby dog is called a puppy.',true),
('science','animals',1,1,'Which animal group has feathers and lays eggs?','Birds','Mammals','Fish','Reptiles','Birds have feathers, lay eggs, and most of them can fly.',true),
('science','animals',1,1,'What body part do fish use to breathe underwater?','Gills','Lungs','Nose','Skin','Fish use gills to breathe underwater.',true),
('science','animals',2,3,'Which group of animals feeds its babies milk?','Mammals','Reptiles','Amphibians','Insects','Mammals feed their babies milk and usually have fur.',true),
('science','animals',2,3,'What is it called when an animal takes a long winter sleep to save energy?','Hibernation','Migration','Camouflage','Adaptation','Hibernation is a long winter sleep some animals take to save energy.',true),
('science','animals',2,3,'What do we call animals that eat both plants and meat?','Omnivores','Herbivores','Carnivores','Vegetarians','Omnivores eat both plants and meat.',true),

-- Weather World (weather)
('science','weather',1,1,'Which season is usually the coldest in Canada?','Winter','Summer','Spring','Fall','Winter is usually the coldest season in Canada.',true),
('science','weather',1,1,'What do we call frozen rain that falls in winter?','Snow','Rain','Fog','Wind','Snow is frozen water that falls from clouds in winter.',true),
('science','weather',1,1,'What tool do we use to measure temperature?','Thermometer','Ruler','Clock','Scale','A thermometer measures how hot or cold it is.',true),
('science','weather',2,3,'What is it called when water heats up and turns into vapour?','Evaporation','Condensation','Precipitation','Collection','Evaporation is when water heats up and turns into vapour that rises into the air.',true),
('science','weather',2,3,'What is it called when water vapour cools and forms clouds?','Condensation','Evaporation','Precipitation','Germination','Condensation is when water vapour cools and turns into tiny droplets that form clouds.',true),
('science','weather',2,3,'Which BC city is known for getting a lot of rain?','Vancouver','Kamloops','Kelowna','Prince George','Vancouver, on the coast, gets a lot of rain each year.',true),

-- Volcano Valley (earth)
('science','earth',1,1,'What do we call a mountain that can erupt with hot melted rock?','Volcano','Hill','Cave','Cliff','A volcano is a mountain that can erupt with hot melted rock called lava.',true),
('science','earth',1,1,'What is the hot melted rock deep inside the Earth called?','Magma','Sand','Water','Ice','Magma is hot melted rock found deep inside the Earth.',true),
('science','earth',1,1,'What is the hard outer layer of the Earth called?','Crust','Core','Mantle','Shell','The crust is the hard outer layer of the Earth we live on.',true),
('science','earth',2,3,'What do we call melted rock once it flows out of a volcano?','Lava','Magma','Ash','Steam','Lava is what we call magma once it flows out onto the surface.',true),
('science','earth',2,3,'What is the very centre layer of the Earth called?','Core','Crust','Mantle','Surface','The core is the very centre of the Earth, and it is extremely hot.',true),
('science','earth',2,3,'What do we call rocks that form when lava cools and hardens?','Igneous rocks','Sedimentary rocks','Metamorphic rocks','Fossil rocks','Igneous rocks form when lava or magma cools and hardens.',true),

-- Space Station (space)
('science','space',1,1,'What is the closest star to Earth?','The Sun','The Moon','Mars','Venus','The Sun is the closest star to Earth and gives us light and warmth.',true),
('science','space',1,1,'What do we call the object that circles Earth and we often see at night?','The Moon','A star','A planet','A comet','The Moon circles around Earth and we often see it at night.',true),
('science','space',1,1,'Which planet do we live on?','Earth','Mars','Jupiter','Venus','We live on the planet Earth.',true),
('science','space',2,3,'How many planets are in our solar system?','Eight','Seven','Nine','Ten','There are eight planets in our solar system.',true),
('science','space',2,3,'Which planet is known as the Red Planet?','Mars','Venus','Jupiter','Saturn','Mars is called the Red Planet because of its reddish colour.',true),
('science','space',2,3,'What do we call a group of stars that forms a pattern in the sky?','Constellation','Galaxy','Nebula','Meteor','A constellation is a group of stars that forms a pattern in the sky.',true),

-- Forces & Matter (forces)
('science','forces',1,1,'What do we call it when you push or pull something?','Force','Energy','Motion','Sound','A push or a pull is called a force.',true),
('science','forces',1,1,'Which of these is a solid?','A rock','Water','Juice','Air','A rock keeps its own shape, so it is a solid.',true),
('science','forces',1,1,'Which of these is a liquid?','Water','A rock','A book','A chair','Water can be poured and takes the shape of its container, so it is a liquid.',true),
('science','forces',2,3,'What force pulls objects down toward the Earth?','Gravity','Friction','Magnetism','Pressure','Gravity is the force that pulls objects down toward the Earth.',true),
('science','forces',2,3,'What do we call the force that slows down objects when surfaces rub together?','Friction','Gravity','Magnetism','Tension','Friction is a force that slows things down when surfaces rub together.',true),
('science','forces',2,3,'What happens to water when it gets very cold?','It freezes into ice','It boils','It disappears','It turns into gas','When water gets very cold, it freezes and turns into solid ice.',true),

-- Living World (ecosystems)
('science','ecosystems',1,1,'What do we call the place where an animal naturally lives?','Habitat','Ecosystem','Nest','Zoo','A habitat is the natural home of an animal.',true),
('science','ecosystems',1,1,'Which of these is a habitat for fish?','Ocean','Desert','Forest','Mountain','Fish live in water habitats like oceans, rivers, and lakes.',true),
('science','ecosystems',1,1,'What do we call animals that eat only plants?','Herbivores','Carnivores','Omnivores','Predators','Herbivores are animals that eat only plants.',true),
('science','ecosystems',2,3,'What do we call the path showing who eats whom, like grass to rabbit to fox?','Food chain','Food web','Life cycle','Ecosystem','A food chain shows how energy passes from one living thing to another.',true),
('science','ecosystems',2,3,'What do we call living and non-living things working together in one place, like a forest?','Ecosystem','Habitat','Food chain','Community','An ecosystem includes all the living and non-living things in an area working together.',true),
('science','ecosystems',2,3,'What is it called when a feature helps an animal survive in its environment, like a polar bear''s white fur?','Adaptation','Habitat','Hibernation','Migration','An adaptation is a special feature that helps an animal survive in its environment.',true);
