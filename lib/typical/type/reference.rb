require "typical/type"

module Typical
  class Type
    class Reference < Type
      def inspect
        "#<Type:Reference(#{type})>"
      end
    end
  end
end
