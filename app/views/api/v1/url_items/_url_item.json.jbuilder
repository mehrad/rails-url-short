# app/views/api/v1/url_items/_url_item.json.jbuilder
json.extract! url_item, :url, :user_id, :sanitized_url, :short_url, :click_count, :created_at, :updated_at