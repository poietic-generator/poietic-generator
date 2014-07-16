##############################################################################
#                                                                            #
#  Poietic Generator Reloaded is a multiplayer and collaborative art         #
#  experience.                                                               #
#                                                                            #
#  Copyright (C) 2011-2013 - Gnuside                                         #
#                                                                            #
#  This program is free software: you can redistribute it and/or modify it   #
#  under the terms of the GNU Affero General Public License as published by  #
#  the Free Software Foundation, either version 3 of the License, or (at     #
#  your option) any later version.                                           #
#                                                                            #
#  This program is distributed in the hope that it will be useful, but       #
#  WITHOUT ANY WARRANTY; without even the implied warranty of                #
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero  #
#  General Public License for more details.                                  #
#                                                                            #
#  You should have received a copy of the GNU Affero General Public License  #
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.     #
#                                                                            #
##############################################################################

require 'poieticgen/zone'
require 'poieticgen/timeline'

module PoieticGen

	class Stroke
		include DataMapper::Resource

		property :id,	Serial
		property :color, String, :required => true
		property :changes, Text, :required => true, :lazy => false
		
		belongs_to :timeline, :key => true
		belongs_to :zone

		def self.create_stroke color, changes, timestamp, zone
			begin
				create ({
					:color => color,
					:changes => changes,
					:zone => zone,
					:timeline => (Timeline.create_with_time timestamp, zone.board)
				})
			rescue DataMapper::SaveFailureError => e
				rdebug "Saving failure : %s" % e.resource.errors.inspect
				raise e
			end
		end

		def to_hash ref
			res = {
				:id => self.timeline.id,
				:zone => self.zone.index,
				:color => self.color,
				:changes => JSON.parse( self.changes ),
				:diffstamp => self.timeline.timestamp - ref
			}
			return res
		end
	end
end