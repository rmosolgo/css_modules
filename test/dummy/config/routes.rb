Rails.application.routes.draw do
  resource :page, only: :show
end
