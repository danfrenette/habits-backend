require "rails_helper"

RSpec.describe UuidMatcher do
  describe ".match?" do
    it "returns true given a valid UUID" do
      expect(UuidMatcher.match?("01234567-89ab-cdef-0123-456789abcdef")).to eq(true)
    end

    it "returns false given a UUID with leading or trailing space" do
      expect(UuidMatcher.match?(" 01234567-89ab-cdef-0123-456789abcdef")).to eq(false)
      expect(UuidMatcher.match?("01234567-89ab-cdef-0123-456789abcdef ")).to eq(false)
    end

    it "does not match invalid UUIDs" do
      expect(UuidMatcher.match?("x1234567-89ab-cdef-0123-456789abcdef")).to eq(false)
      expect(UuidMatcher.match?("0123456789abcdef0123456789abcdef")).to eq(false)
      expect(UuidMatcher.match?("01234567-89ab-cdef-0123-456789abcde")).to eq(false)
      expect(UuidMatcher.match?("01234567-89ab-cdef-0123-456789abcdef0")).to eq(false)
    end
  end
end
