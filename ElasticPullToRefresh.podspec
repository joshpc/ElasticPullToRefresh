Pod::Spec.new do |s|
  s.name         = "ElasticPullToRefresh"
  s.version      = "1.4.3"
  s.summary      = "A pull to refresh control that has a simple, elegant spinner"
  s.homepage     = "https://github.com/joshpc/ElasticPullToRefresh"
  s.license      = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author       = { "Joshua Tessier" => "joshpc@gmail.com" }
  s.platform     = :ios, "11.0"
  s.swift_version = "4.0"

  s.source       = { :git => "https://github.com/joshpc/ElasticPullToRefresh.git", :tag => '1.4.3' }
  s.source_files = "ElasticPullToRefresh"
end
