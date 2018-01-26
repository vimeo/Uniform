Pod::Spec.new do |s|
  s.name             = 'Uniform'
  s.version          = '0.1.0'
  s.summary          = 'A framework for keeping in-memory objects consistent and up to date.'

  s.description      = <<-DESC
  Uniform is a framework for keeping in-memory objects consistent and up to date.
                       DESC

  s.homepage         = 'https://github.com/vimeo/Uniform'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Gavin King' => 'gavin@vimeo.com' }
  s.source           = { :git => 'git@github.com:vimeo/Uniform.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'

  s.source_files = 'Uniform/Classes/**/*'

end
