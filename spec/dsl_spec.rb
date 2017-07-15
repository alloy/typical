require "spec_helper"
require "typical/dsl"

module Typical
  describe DSL do
    include DSL

    it "returns a NilClass type" do
      null.must_equal Type.new(NilClass)
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
      expected = Type::Array.new(Type.new(String), Type.new(Integer), Type.new(NilClass)).normalize
      Array!(String?, Integer?).normalize.must_equal expected
      Array?(String?, Integer?).normalize.must_equal expected | null
    end

    it "makes set types available" do
      expected = Type::Set.new(Type.new(String), Type.new(Integer), Type.new(NilClass)).normalize
      Set!(String?, Integer?).normalize.must_equal expected
      Set?(String?, Integer?).normalize.must_equal expected | null
    end

    it "makes reference types available" do
      expected = Type::Reference.new("A reference")
      Reference!("A reference").normalize.must_equal expected
      Reference?("A reference").normalize.must_equal expected | null
    end
  end

  module CustomDSL
    class CustomType
    end

    include DSL
    extend DSL::Define

    define_scalar_type CustomType
    define_scalar_type CustomType, "String"
  end

  describe DSL::Define do
    include CustomDSL

    it "allows you to add scalar types to your own DSL module" do
      CustomType!.must_equal Type.new(CustomDSL::CustomType)
      CustomType?.must_equal Type.new(CustomDSL::CustomType) | null
    end

    it "allows you to override scalar types from the regular DSL module" do
      String!.must_equal Type.new(CustomDSL::CustomType)
      String?.must_equal Type.new(CustomDSL::CustomType) | null
    end
  end
end
