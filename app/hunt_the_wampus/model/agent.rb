class HuntTheWampus
  module Model
    class Agent
      attr_accessor :location, :alive, :has_arrow
    
      def initialize
        restart
      end
      
      def restart
        @has_arrow = true
        @alive = true
        @location = [3, 0]
      end
      
      def has_arrow?
        @has_arrow
      end
      
      def alive?
        @alive
      end
      
      def dead?
        !alive?
      end
    end
  end
end
