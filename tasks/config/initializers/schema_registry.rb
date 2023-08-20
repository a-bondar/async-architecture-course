# frozen_string_literal: true

SchemaRegistry.configure do |cfg|
  cfg.schemas_root_path = Rails.root.join('app', 'schemas')
end

