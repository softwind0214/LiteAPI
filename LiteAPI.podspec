Pod::Spec.new do |s|
  s.name         = "LiteAPI"
  s.version      = "0.1"
  s.summary      = "A lite API framework."
  s.description  = <<-DESC
					A chaining supported API framework.
                   DESC
  s.homepage     = "https://github.com/softwind0214/LiteAPI"
  s.license      = "MIT"
  s.author             = { "Softwind Tang" => "softwind0214@gmail.com" }
  s.ios.deployment_target = '7.0'
  s.source       = { :git => "https://github.com/softwind0214/LiteAPI.git", :tag => "0.1" }

  s.source_files = 'Lib/**/*.{h,m}'
  s.dependency "AFNetworking"

end

