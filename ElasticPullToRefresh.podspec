Pod::Spec.new do |s|
  s.name         = "ElasticPullToRefresh"
  s.version      = "0.0.1"
  s.summary      = "A pull to refresh control that has a simple, elegant spinner"
  s.homepage     = "https://github.com/joshpc/ElasticPullToRefresh"
  s.license      = { :type => 'MIT' }
  s.author       = { "Joshua Tessier" => "joshpc@gmail.com" }
  s.platform     = :ios, "9.0"

  s.source       = { :git => "https://github.com/joshpc/ElasticPullToRefresh.git", :tag => '1.0' }
  s.source_files = "ElasticPullToRefresh"
end
