Pod::Spec.new do |s|
  s.name         = "LiteAPI"
  s.version      = "0.0.1"
  s.summary      = "A lite-weight API framework."
  s.description  = <<-DESC
                   DESC
  s.homepage     = "http://EXAMPLE/LiteAPI"
  s.license      = "MIT"
  s.author             = { "Softwind Tang" => "softwind0214@gmail.com" }
  s.ios.deployment_target = '7.0'
  s.source       = { :git => "http://EXAMPLE/LiteAPI.git", :tag => "0.0.1" }

  s.source_files = 'Lib/*.{h,m}'
  s.subspec 'Core' do |ss|
    ss.source_files = 'Lib/Core/*.{h,m}'
  end

  s.subspec 'Property' do |ss|
    ss.source_files = 'Lib/Property/*.{h,m}'
  end

  s.subspec 'Request' do |ss|
    ss.source_files = 'Lib/Request/*.{h,m}'
  end

  s.dependency "AFNetworking"

end

