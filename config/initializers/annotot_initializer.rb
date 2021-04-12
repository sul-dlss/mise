ActiveSupport::Reloader.to_prepare do
  Annotot::Annotation.belongs_to :project, class_name: '::Project'
end
