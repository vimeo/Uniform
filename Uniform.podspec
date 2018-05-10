Pod::Spec.new do |s|
  s.name             = 'Uniform'
  s.version          = '1.0.1'
  s.summary          = 'A framework for maintaining in-memory object consistency.'

  s.description      = <<-DESC
  Uniform is a framework for maintaining in-memory object consistency.
                       DESC

  s.homepage         = 'https://github.com/vimeo/Uniform'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Gavin King' => 'gavin@vimeo.com' }
  s.source           = { :git => 'https://github.com/vimeo/Uniform.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'

  s.source_files = 'Uniform/Classes/**/*'

end
