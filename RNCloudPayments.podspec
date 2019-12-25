Pod::Spec.new do |spec|
    spec.name         = "RNCloudPayments"
    spec.version      = "1.0.0"
    spec.summary      = "React Native library for using CloudPayments SDK"
    spec.description  = "React Native library for using CloudPayments SDK"
    spec.homepage     = "https://github.com/kakadu-dev/react-native-cloudpayments"
    spec.license      = { :type => "MIT" }
    spec.author       = { "Nikolay Polukhin" => "polu-hin@mail.ru" }
    spec.platform     = :ios
    spec.ios.deployment_target = "9.0"
    spec.source       = { :git => "https://github.com/kakadu-dev/react-native-cloudpayments.git", :tag => "#{spec.version}" }
    spec.source_files  = "RNCloudPayments", "ios/*.{h,m}", "ios/Extensions/*.{h,m}", "ios/SDK/NSDataENBase64.{h,m}", "ios/SDWebViewController/*.{h,m}"
    spec.dependency "React"
  end
