module Gitlab
  class Namespaces < Grape::API
    before { authenticate! }

    resource :namespaces do
      # Get a list of namespaces for the current user
      #
      # Example Request:
      #   GET /namespaces
      get do
        @namespaces = current_user.namespaces
        present @namespaces, with: Entities::Namespace
      end
    end
  end
end