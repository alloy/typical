require "typical/type"

module Typical
  module DSL
    module Define
      private def define_scalar_type(mod, name = nil)
        name ||= mod.name.split("::").last
        define_method("#{name}!") { Type.new(mod) }
        define_method("#{name}?") { Type.new(mod) | null }
      end
    end

    BUILTIN_SCALAR_TYPES = [
      Integer,
      Float,
      Object,
      Range,
      Regexp,
      String,
      Symbol,
      Time,
    ].freeze

    extend Define
    BUILTIN_SCALAR_TYPES.each do |klass|
      define_scalar_type(klass)
    end

    def null
      Type.new(NilClass)
    end

    def Hash!(types = {})
      Type::Hash.new(types)
    end

    def Hash?(types = {})
      Hash!(types) | null
    end

    def Set!(*types)
      Type::Set.new(*types)
    end

    # TODO: It actually appears that mongo/mongoid does not return `null` for set fields.
    def Set?(*types)
      Set!(*types) | null
    end

    def Array!(*types)
      Type::Array.new(types)
    end

    def Array?(*types)
      Array!(*types) | null
    end

    def Reference!(reference)
      Type::Reference.new(reference)
    end

    def Reference?(reference)
      Reference!(reference) | null
    end
  end
end
