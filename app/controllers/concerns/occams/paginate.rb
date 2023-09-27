# frozen_string_literal: true

module Occams::Paginate
  def occams_paginate(scope, per_page: 50)
    return unless defined?(Kaminari)

    scope.page(params[:page]).per(per_page)
  end
end
