require 'open-uri'

class HomeController < ApplicationController
  def index
    @divisions = Division.with_rebellions.order("division_date DESC", "clock_time DESC", "division_name", "division_number DESC").limit(5)
  end

  def faq
  end

  def search
    @postcode = params[:query] if params[:query] =~ /^\d{4}$/

    electorates = JSON.parse(open("http://www.openaustralia.org/api/getDivisions?output=js&key=CcV3KBBX2Em7GQeV3RA8qzgS&postcode=#{@postcode}").read)

    if electorates.count == 1
      # FIXME: We should redirect but this is how the PHP app does it currently
      render nothing: true, location: view_context.electorate_path(Member.find_by_constituency(electorates.first['name']))
    end
  end
end
