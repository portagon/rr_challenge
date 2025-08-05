if Rails.env.development? || Rails.env.test?
  Dir[Rails.root.join("app/platforms/*.rb")].each do |file|
    require_dependency file
  end
end

PLATFORM_CLASSES_AND_TITLES = Platforms::Base.descendants.map do |klass|
  [klass.name, klass.title]
end
PLATFORM_CLASSES_AND_TITLES.freeze

PLATFORM_CLASS_AND_NAME_MAP = Platforms::Base.descendants.each_with_object({}) do |klass, hash|
  hash[klass.name] = klass
end
PLATFORM_CLASS_AND_NAME_MAP.freeze
