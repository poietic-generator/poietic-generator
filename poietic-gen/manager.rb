
require 'poietic-gen/palette'


module PoieticGen


	ZONE_INIT = []

	#
	# manage a pool of users
	#
	class Manager
		def initialize
			# a 16-char long random string
			@id = (0...16).map{ ('a'..'z').to_a[rand(26)] }.join

			@palette = Palette.new
			@width = 32
			@height = 32

			@users = []

			# total count of users seen
			@users_seen = 0

			@zones = [ ZONE_INIT ]
		end


		#
		# generates an unpredictible user id based on session id & user counter
		#
		def join
			user_id = File.join @id, @users_seen.to_s
			@users_seen += 1
			#zone = self.zone_alloc user_id

			return user_id
		end


		def leave user_id
			zone_idx = @users[user_id].zone

			self.zone_free zone_idx
		end

		def zone_free zone_idx
			zone = @zones[zone_idx]
			zone.user = nil
		end

		#
		# allocates a zone for a new user
		# uses the minimal index zone if it exists
		# or creates one if necessary
		#
		def zone_alloc user_id
			zone_result = nil

			zones_free = @zones.select do |zone_item|
				zone_item.user.nil? 
			end
			if zones_free.empty? then
				self.expand!
			end

			zone = zones_free.first
			zone.user = user_id
			return zone
		end

		#
		# expend map creating new allocatable zones
		#
		def world_expand
			# choose a side (using a spiral growth)
			# expand that side
			zone_past = @zones.last

			zone_present = Zone.create_next zone_past
			zone_future = Zone.create_next zone_past

			# if the following collides, then keep the same vector
			res = @zones.select do |zone_item|
				( zone_item.position <=> zone_future ) == 0
			end
			unless res.empty? then
				#collision with existing zone coordinates
				zone_present.vector = zone_past.vector
			end
			@zones << zone_present
		end

		#
		# reduce map removing unused zones from the border
		#
		def world_reduce
			while true
				zone = @zones.last
				break if @zones.last
			end
		end

		# post
		#  * <user-id> changes
		#
		# returns 
		#  * latest content since last update
		def sync user_id
			# 
			#draw user

			return
		end

		#
		# Relocate user offset
		def draw user_id, change

		end
	end
end