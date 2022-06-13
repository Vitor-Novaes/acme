# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from ActionController::RoutingError, with: :render_not_found_route
  rescue_from ActiveRecord::RecordInvalid, with: :render_active_record_invalid
  rescue_from ActiveRecord::RecordNotFound, with: :render_active_record_not_found
  rescue_from ArgumentError, with: :render_argument_error

  private

  def render_not_found_route(exception)
    render json: { errors: { message: "Route Not Found: #{exception.message}" } }, status: :not_found
  end

  def render_active_record_invalid(exception)
    render json: { errors: exception.record.errors }, status: :unprocessable_entity
  end

  def render_argument_error(exception)
    render json: { errors: { message: exception } }, status: :bad_request
  end

  def render_active_record_not_found(exception)
    render json: { errors: { message: exception.message } }, status: :not_found
  end
end
