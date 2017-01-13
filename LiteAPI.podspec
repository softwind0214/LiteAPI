Pod::Spec.new do |s|
  s.name         = "LiteAPI"
  s.version      = "0.1"
  s.summary      = "A lite API framework."
  s.description  = <<-DESC
					A chaining supported API framework.
                   DESC
  s.homepage     = "https://github.com/softwind0214/LiteAPI"
  s.license      = { :type => "MIT" }
  s.author             = { "Softwind Tang" => "softwind0214@gmail.com" }
  s.ios.deployment_target = '7.0'
  s.source       = { :git => "https://github.com/softwind0214/LiteAPI.git", :tag => s.version.to_s }

  s.source_files = 'Lib/**/*.{h,m}'
  s.dependency "AFNetworking"

end

