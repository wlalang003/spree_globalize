module Spree::Api::V2::BaseControllerDecorator
  Spree::Api::V2::BaseController.include(SpreeGlobalize::ControllerGlobalizeHelper)
end

::Spree::Api::V2::BaseController.prepend(Spree::Api::V2::BaseControllerDecorator)
