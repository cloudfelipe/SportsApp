# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def testing_pods
    pod 'Quick'
    pod 'Nimble'
    # pod 'Swinject'
    # pod 'SwinjectStoryboard'
    pod 'ObjectMapper', '~> 3.4'
    pod 'RxBlocking', '~> 4.0'
    pod 'RxTest',     '~> 4.0'
end

def main_pods 
	pod 'ObjectMapper', '~> 3.4'
	pod 'Alamofire'
	pod 'Moya', '~> 12.0'
	# pod 'Moya-ObjectMapper'
	pod 'RxSwift',    '~> 4.0'
	pod 'RxCocoa',    '~> 4.0'
	pod 'SwiftLint'
	pod 'TPKeyboardAvoiding'
	pod 'SVProgressHUD'
end

target 'SportsApp' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  main_pods

  target 'SportsAppTests' do
    inherit! :search_paths
    testing_pods
  end

end
