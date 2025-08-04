Dir[Rails.root.join("app/platforms/*.rb")].each do |file|
  require_dependency file
end

PLATFORM_CLASSES_AND_TITLES = Platforms::Base.descendants.map do |klass|
  [klass.name, klass.title]
end
