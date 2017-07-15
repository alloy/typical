require "spec_helper"
require "typical/dsl"

module Boolean; end
TrueClass.send(:include, Boolean)
FalseClass.send(:include, Boolean)

module Typical
  DSL.define_scalar_type(Boolean)

  describe DSL do
    include DSL

    it "returns a NilClass type" do
      null.must_equal Type.new(NilClass)
    end

    it "defines DSL methods for a scalar type" do
      Boolean!.must_equal Type.new(Boolean)
      Boolean?.must_equal Type.new(Boolean) | null
    end

    it "makes builtin scalar types available" do
      DSL::BUILTIN_SCALAR_TYPES.each do |klass|
        send("#{klass.name}!").must_equal Type.new(klass)
        send("#{klass.name}?").must_equal Type.new(klass) | null
      end
    end

    it "makes hash types available" do
      expected = Type::Hash.new(Type.new(String) => Type::Array.new(Type.new(String), Type.new(Integer)) | null).normalize
      Hash!(String! => Array?(String!, Integer!)).normalize.must_equal expected
      Hash?(String! => Array?(String!, Integer!)).normalize.must_equal expected | null
    end

    it "makes array types available" do
      expected = Type::Array.new(Type.new(String), Type.new(Boolean), Type.new(NilClass)).normalize
      Array!(String?, Boolean?).normalize.must_equal expected
      Array?(String?, Boolean?).normalize.must_equal expected | null
    end

    it "makes set types available" do
      expected = Type::Set.new(Type.new(String), Type.new(Boolean), Type.new(NilClass)).normalize
      Set!(String?, Boolean?).normalize.must_equal expected
      Set?(String?, Boolean?).normalize.must_equal expected | null
    end

    it "makes reference types available" do
      expected = Type::Reference.new("A reference")
      Reference!("A reference").normalize.must_equal expected
      Reference?("A reference").normalize.must_equal expected | null
    end
  end
end
