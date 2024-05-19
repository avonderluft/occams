# frozen_string_literal: true

module Occams::Paginate
  def occams_paginate(scope, per_page: 50)
    if defined?(Kaminari)
      scope.page(params[:page]).per(per_page)
    else
      scope
    end
  end
end
