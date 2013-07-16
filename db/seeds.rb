# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.collection.insert([{email: "firstuser@chwink.com", password: "qwerty", encrypted_password: "qwertyuiopasdfgjklzxcvbnm"}])

Category.collection.insert( [
    { name: "Daily Use" },
    { name: "Living Creatures" },
    { name: "Transport" },
    { name: "Medicine" },
    { name: "Personal Care" },
    { name: "Home Appliances" },
    { name: "Science & Technology" }
])

Chwink.collection.insert([ 
    { name: "Wax Candles", category_id: Category.where(name: "Daily Use").first.id, user_id: User.first.id,
end_year: 2015, description: "Wax candles may soon be replaced with long lasting batteris. By 2015, we may not need them!", votes: { "2015" => 1},
    },
    { name: "Postage Stamps", category_id: Category.where(name: "Daily Use").first.id, user_id: User.first.id,
end_year: 2020, description: "Who uses them anyway? In all likelyhood, we may not have snail mail at all.", votes: { "2020" => 1},
    },
    { name: "Maps and World Atlas", category_id: Category.where(name: "Daily Use").first.id, user_id: User.first.id,
end_year: 2017, description: "With the advent of the internet, online maps - the traditional world atlas is fast losing its need", votes: { "2017" => 1},
    },
    { name: "World Globe", category_id: Category.where(name: "Daily Use").first.id, user_id: User.first.id,
end_year: 2010, description: "Haven't seem them around anymore! All of know the earth is a sphere .. well almost", votes: { "2010" => 1},
    },
    { name: "Light Bulb", category_id: Category.where(name: "Daily Use").first.id, user_id: User.first.id,
end_year: 2020, description: "These yellow incandesent bulbs are now a thing of the past. With CFL tubes and lamps, these bulbs are not needed now!", votes: { "2020" => 1},
    },
    { name: "Mosquitoes", category_id: Category.where(name: "Living Creatures").first.id, user_id: User.first.id,
end_year: 2025, description: "I am hoping they get eradicated by 2025. It will indeed make this world a safer place to live in!", votes: { "2025" => 1},
    },
    { name: "House Fly", category_id: Category.where(name: "Living Creatures").first.id, user_id: User.first.id,
end_year: 2050, description: "It's about time we got them. The only thing interesting about them is the movie!! The Common house fly is one strong contender but we should get them by 2050!", votes: { "2050" => 1},
    },
    { name: "Bengal Tiger", category_id: Category.where(name: "Living Creatures").first.id, user_id: User.first.id,
end_year: 2018, description: "Help save them! They seem to have all but gone extinct. If we dont do anything now, our childerd would indeed never know about them!", votes: { "2018" => 1},
    },
    { name: "Floppy Disk", category_id: Category.where(name: "Science & Technology").first.id, user_id: User.first.id,
end_year: 2000, description: "Those were the days, digital storage is restricted and digital storage medias are easy get corrupted. With evaluation CDs, DVDs, USB flash drives. I haven't seen floppy disks for a decade!", votes: { "2000" => 1},
    },
    { name: "Steam Engine", category_id: Category.where(name: "Transport").first.id, user_id: User.first.id,
end_year: 1996, description: "Its time kids realized that steam was not just coming from tea-spouts!", votes: { "1996" => 1},
    },
    { name: "Chicken Pox", category_id: Category.where(name: "Medicine").first.id, user_id: User.first.id,
end_year: 2029, description: "Its only a matter of time Chicken Pox goes away for good !", votes: { "2029" => 1},
    },
    { name: "Shaving blades", category_id: Category.where(name: "Personal Care").first.id, user_id: User.first.id,
end_year: 2000, description: "Mach-1, Mach-2, Mach-3 -- its too much speed. I loved my rickety old blades and the cuts they induced - ouch!", votes: { "2000" => 1},
    },
    { name: "Dial tone phone", category_id: Category.where(name: "Home Appliances").first.id, user_id: User.first.id,
end_year: 1995, description: "I would love to tell children that I put my finger in the 0 and turned it around completely and SPOKE to an operator!!", votes: { "1995" => 1},
    },
])

IMAGES = {
  "Wax Candles" => "http://farm2.static.flickr.com/1344/1387236619_5bcd3beaac.jpg",
  "Postage Stamps" => "http://z.hubpages.com/u/1530916_f496.jpg",
  "Maps and World Atlas" => "http://www.worldpress.org/images/maps/world_600w.jpg",
  "World Globe" => "http://upload.wikimedia.org/wikipedia/commons/e/ee/World_globe.jpg",
  "Light Bulb" => "http://www.businesspundit.com/wp-content/uploads/2009/07/zzlightbulb.jpg",
  "Mosquitoes" => "http://upload.wikimedia.org/wikipedia/commons/thumb/d/dc/Mosquito_2007-2.jpg/220px-Mosquito_2007-2.jpg",
  "House Fly" => "http://www.dontwaste.com.au/wp-content/themes/shopperpress/thumbs/HouseFlyLg.jpg",
  "Bengal Tiger" => "http://www.karmakerala.com/news/wp-content/uploads/2010/03/bengal_tiger_31.jpg",
  "Floppy Disk" => "http://chris.pirillo.com/wp-content/uploads/2010/04/FloppyDisk.jpg",
  "Steam Engine" => "http://fwallpapers.com/files/imagecache/content600/images/steam-engine-4.png",
  "Chicken Pox" => "http://goeshealth.com/wp-content/uploads/2012/02/chickenpox.jpg",
  "Shaving blades" => "http://www.shaving-shack.com/blog/wp-content/uploads/2011/09/c80a44716148147b2f18efeb293c9085.jpg",
  "Dial tone phone" => "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcTu-E8Or2kMl28VElr1nI4twDJhoJF8ecS4Lwu8roUXUNICYuXK"

}

IMAGES.each do |name, image|
  c = Chwink.where(name: name).first
  c.image = open(image)
  c.save
end

# Setup initial random seed data for chwinks!
#200.times { c = Chwink.all.sample; c.vote({:up => (1980..2030).to_a.sample}) }
