json.variants @variants do |variant|
  json.partial! 'v1/variants/base', variant: variant
end

json.partial! 'v1/partials/paginate', records: @variants
