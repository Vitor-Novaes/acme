json.clients @clients do |client|
  json.partial! 'v1/clients/base', client: client
end

json.partial! 'v1/partials/paginate', records: @clients
