require "acts_as_meritocracy/model"


if defined?(ActiveRecord::Base)
  ActiveRecord::Base.send :include, ActsAsMeritocracy
end
