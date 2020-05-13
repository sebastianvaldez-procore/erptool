require_relative '../command'

class SyncEventService
  include HTTParty
  BASE_URL = 'https://api.procore.com'
  attr_reader :company_id, :procore_item_id, :token
  def initialize(company_id:, procore_item_id:, token:)
    @company_id = company_id
    @procore_item_id = procore_item_id
    @token = token
  end

  def set_successful
    errors = []
    sync_event_id = retrieve_sync_event_id

    if sync_event_id
      update_errors = update_sync_event_to_synced(sync_event_id)
      errors << update_errors unless update_errors.nil?
    else
      errors << "Could not find sync event for procore id #{procore_item_id}"
    end

    { errors: errors }
  end

  def set_status(status:)
    errors = []
    sync_event_id = retrieve_sync_event_id

    if sync_event_id
      update_errors = update_sync_event_status(sync_event_id, status)
      errors << update_errors unless update_errors.nil?
    else
      errors << "Could not find sync event for procore item id #{procore_item_id}"
    end

    { errors: errors }
  end

  private

  def update_sync_event_status(sync_event_id, status)
    response = HTTParty.patch(update_sync_events_url(sync_event_id), body: update_sync_event_body(status), headers: headers)
    if response.code == 200
      nil
    else
      "Failed to update the sync event: #{response.code}"
    end
  rescue => e
    "Error trying to update sync event: #{e.message}"
  end

  def update_sync_event_to_synced(sync_event_id)   
    response = HTTParty.patch(update_sync_events_url(sync_event_id), body: update_sync_event_body, headers: headers)
    if response.code == 200
      nil
    else
      "Failed to update the erp sync event: #{response.code}"
    end
  rescue => e
    "Error trying to update sync event: #{e.message}"
  end

  def retrieve_sync_event_id
    response = HTTParty.get(list_sync_events_url, query: sync_events_query, headers: headers)
    if response.code == 200
      JSON.parse(response.body).last["id"]
    else
      nil
    end
  rescue => e
    nil
  end

  def headers
    {
      "Authorization" => "Bearer #{token}"
    }
  end

  def sync_events_query
    {
      "company_id" => company_id,
      "filters[procore_item_id]" => procore_item_id
    }
  end

  def list_sync_events_url
    "#{BASE_URL}/rest/v0.0/erp_sync_events"
  end

  def update_sync_events_url(sync_event_id)
    "#{BASE_URL}/rest/v0.0/erp_sync_events/#{sync_event_id}"
  end

  def update_sync_event_body(status='ok')
    {
      "company_id": company_id,
      "sync_event": { 'status': status }
    }   
  end

  def set_successful_sync_event_body
    {
      "sync_event": {
        "success": true,
        "status": 'ok'
      }
    }
  end
end