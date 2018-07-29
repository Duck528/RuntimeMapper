platform :ios, '10.0'
workspace 'RuntimeMapper'
use_frameworks!

target 'RuntimeMapper' do
    pod 'Runtime'
    
    target 'RuntimeMapperTests' do
        inherit! :search_paths
    end
    
    target 'SampleApp' do
        project 'SampleApp/SampleApp.xcodeproj'
    end
end
