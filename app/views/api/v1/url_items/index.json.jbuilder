# app/views/api/v1/url_items/index.json.jbuilder
json.array! @url_items, partial: "api/v1/url_items/url_item", as: :url_item