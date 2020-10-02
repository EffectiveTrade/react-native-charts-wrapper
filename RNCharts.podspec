require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

# min cocoapods version 1.8.4
system("mkdir -p #{__dir__}/../../.temp")
zipfile = "#{__dir__}/../../.temp/#{package["name"]}.zip"
system("rm -rf #{zipfile} && cd ios && zip -r #{zipfile} . > /dev/null")

Pod::Spec.new do |s|
  s.name         = 'RNCharts'
  s.version      = package["version"]
  s.summary      = package["description"]
  s.author       = package["author"]

  s.homepage     = package["homepage"]

  s.license      = package["license"]
  s.platform     = :ios, "9.0"

  s.source       = { :http => "file://#{zipfile}" }
  s.source_files = "ReactNativeCharts/**/*.{h,m,swift}"
  s.static_framework = true

  s.swift_version = '5.0'
  s.dependency 'React'
  s.dependency 'SwiftyJSON', '5.0'
  s.dependency 'Charts'


end
