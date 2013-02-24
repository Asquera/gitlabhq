module Gitlab
  class Namespaces < Grape::API
    before { authenticate! }

    resource :namespaces do
      # Get a list of namespaces for the current user
      #
      # Example Request:
      #   GET /namespaces
      get do
        error!("Current user not found", 404) unless current_user
        @namespaces = current_user.namespaces
        present @namespaces, with: Entities::Namespace
      end

      # Get a single namespace for the current user
      #
      # Paramters:
      #   id (required) - The ID of the namespace
      #
      # Example Request:
      #   GET /namespaces/:id
      get ":id" do
        @namespace = Namespace.find(params[:id])
        if current_user.namespaces.include? @namespace
          present @namespace, with: Entities::Namespace
        else
          not_found!
        end
      end
    end
  end
end