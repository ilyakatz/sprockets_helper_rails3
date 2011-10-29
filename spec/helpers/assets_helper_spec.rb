require 'spec_helper'
require 'action_view'
require 'sprockets'

include ActionView::Helpers::AssetTagHelper

puts Rails.root
Assets = Sprockets::Environment.new("#{Rails.root}/test/rails_app") do |env|
  assets = ["javascripts", "stylesheets"]
  paths = ["app/assets/"].map { |path|
    assets.map do |folder|
      "#{path}#{folder}"
    end
  }.flatten

  paths.each do |path|
    env.append_path path
  end
end

describe ActionView::Helpers::AssetTagHelper do

  describe "validate javascript sprockets helper" do

    it "use sprockets if name doesn't contain assets but sprockets manages the file" do
      fingerprint = Assets["application"].digest
      javascript_include_tag("application").should == %Q[<script src="/assets/application.js?#{fingerprint}" type="text/javascript"></script>]
    end

    it "use sprockets if name  contain assets but sprockets manages the file" do
      fingerprint = Assets["application"].digest
      javascript_include_tag("/assets/application").should == %Q[<script src="/assets/application.js?#{fingerprint}" type="text/javascript"></script>]
    end

    it "should not use assets path if file is not managed by sprockets" do
      javascript_include_tag("asdfasdf").should == %Q[<script src="/javascripts/asdfasdf.js" type="text/javascript"></script>]
    end

    it "make sure can handle names with extension js" do
      fingerprint = Assets["application"].digest
      javascript_include_tag("/assets/application.js").should == %Q[<script src="/assets/application.js?#{fingerprint}" type="text/javascript"></script>]

      javascript_include_tag("asdfasdf.js").should == %Q[<script src="/javascripts/asdfasdf.js" type="text/javascript"></script>]
    end

  end

  describe "css helper" do

    it "should correctly show plain ol' css file" do
      stylesheet_link_tag("ie.css", :media=>:all).should include("/stylesheets/ie.css")
    end

    it "should render sprockets css" do
      fingerprint = Assets["application.css"].digest
      stylesheet_link_tag("application.css").should == "<link href=\"/assets/application.css?#{fingerprint}\" media=\"screen\" rel=\"stylesheet\" type=\"text/css\" />"
    end

    it "should verify that can pass in extra arguments" do
      fingerprint = Assets["application.css"].digest
      stylesheet_link_tag("application.css", :media=>:all).should == "<link href=\"/assets/application.css?#{fingerprint}\" media=\"all\" rel=\"stylesheet\" type=\"text/css\" />"
    end

    it "should be resilient to /assets directory" do
      fingerprint = Assets["application.css"].digest
      stylesheet_link_tag("/assets/application.css", :media=>:all).should == "<link href=\"/assets/application.css?#{fingerprint}\" media=\"all\" rel=\"stylesheet\" type=\"text/css\" />"
    end

    it "should be resilient to missing extention directory" do
      fingerprint = Assets["application.css"].digest
      stylesheet_link_tag("application", :media=>:all).should == "<link href=\"/assets/application.css?#{fingerprint}\" media=\"all\" rel=\"stylesheet\" type=\"text/css\" />"
    end


  end

end