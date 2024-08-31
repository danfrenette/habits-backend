module UuidMatcher
  MATCHER = /\A([a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}){1}\z/

  def self.match?(value)
    !!value&.match?(MATCHER)
  end
end
