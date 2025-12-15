Feature: High-Throughput Elastic Network API, wip - Transmission Scheduling Operations
  # Input to be provided by the implementation to the tester
  #
  # Implementation indications:
  # * List of unsupported bandwidth units (if any) among: Gbps, Mbps
  # * List of unsupported file size units (if any) among: B, KB, MB, GB, TB, PB
  # * List of unsupported bandwidth guarantee levels (if any) among: hard_guarantee, soft_guarantee
  # * List of unsupported load sharing strategies (if any) among: equal_load, priority_based, traffic_aware
  #
  # Testing assets:
  # * A valid API key or OAuth 2.0 credentials with required scopes (high_throughput_elastic_network:read, high_throughput_elastic_network:write)
  # * Test data with various file sizes (from small to large volumes)
  # * Network environment supporting dynamic bandwidth allocation
  # * apiRoot: API root of the server URL (default: http://localhost:9091)
  #
  # References to OAS spec schemas refer to schemas specified in high_throughput_elastic_networks.yaml
  Background: Common High-Throughput Elastic Network setup
    Given an environment at "apiRoot"
    And the resource "/high-throughput-elastic-network/vwip" as network base-url
    And the header "Authorization" is set to a valid access token (API key or OAuth 2.0 token)
    And the header "Content-Type" is "application/json"

  # Success scenarios
  @hten_01_schedule_transmission_pending
  Scenario: Submit transmission request - scheduling successful (transmission pending)
    Given a valid TransmissionRequest body (FAST Telescope example compliant)
    When the request "submitTransmissionSchedule" is sent to "/high-throughput-elastic-network/transmission/schedule"
    Then the response code is 200
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "#/components/schemas/TransmissionScheduledResponse"
    And the response property "$.execution_result" is "success"
    And the response property "$.time_segmented_transmission_rate" is an array matching input time segments
    And the response property "$.estimated_transmission_duration.total_duration" is a positive number

  @hten_02_schedule_transmission_completed_sync
  Scenario: Submit transmission request - synchronous completion
    Given a valid TransmissionRequest body with small file size (supports synchronous transmission)
    When the request "submitTransmissionSchedule" is sent to "/high-throughput-elastic-network/transmission/schedule"
    Then the response code is 201
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "#/components/schemas/TransmissionCompletedResponse"
    And the response property "$.execution_result" is "success"
    And the response property "$.post_transmission_statistics" is present
    And the response property "$.post_transmission_statistics.data_transmitted_volume" matches input file size

  @hten_03_transmission_with_upload_bandwidth
  Scenario: Submit transmission request with upload-only bandwidth requirement
    Given a valid TransmissionRequest body with bandwidth_requirement_type set to "upload_bandwidth"
    When the request "submitTransmissionSchedule" is sent to "/high-throughput-elastic-network/transmission/schedule"
    Then the response code is 200
    And the response body complies with the OAS schema at "#/components/schemas/TransmissionScheduledResponse"
    And the response property "$.time_segmented_transmission_rate.unit" matches input bandwidth unit

  @hten_04_transmission_with_soft_guarantee
  Scenario: Submit transmission request with soft bandwidth guarantee
    Given a valid TransmissionRequest body with bandwidth_guarantee_level set to "soft_guarantee"
    When the request "submitTransmissionSchedule" is sent to "/high-throughput-elastic-network/transmission/schedule"
    Then the response code is 200
    And the response body complies with the OAS schema at "#/components/schemas/TransmissionScheduledResponse"
    And the response property "$.execution_result" is "success"

  @hten_05_transmission_with_equal_load_strategy
  Scenario: Submit transmission request with equal load sharing strategy
    Given a valid TransmissionRequest body with load_sharing_strategy set to "equal_load"
    When the request "submitTransmissionSchedule" is sent to "/high-throughput-elastic-network/transmission/schedule"
    Then the response code is 200
    And the response body complies with the OAS schema at "#/components/schemas/TransmissionScheduledResponse"

  # Error scenarios - 400 Bad Request
  @hten_C01.01_invalid_time_segment_format
  Scenario: Submit request with invalid time segment format
    Given a TransmissionRequest body where bandwidth_requirement.time_segment does not match "HH:MM-HH:MM" pattern
    When the request "submitTransmissionSchedule" is sent to "/high-throughput-elastic-network/transmission/schedule"
    Then the response status code is 400
    And the response body complies with the OAS schema at "#/components/schemas/ErrorResponse"
    And the response property "$.execution_result" is "failure"
    And the response property "$.error_code" is "INVALID_PARAMETER"
    And the response property "$.error_message" contains a user-friendly text about time segment format

  @hten_C01.02_min_latency_exceeds_max
  Scenario: Submit request with min_latency greater than max_latency
    Given a TransmissionRequest body where latency_requirement.min_latency > latency_requirement.max_latency
    When the request "submitTransmissionSchedule" is sent to "/high-throughput-elastic-network/transmission/schedule"
    Then the response status code is 400
    And the response body complies with the OAS schema at "#/components/schemas/ErrorResponse"
    And the response property "$.error_code" is "INVALID_PARAMETER"
    And the response property "$.error_message" contains "min_latency must be less than or equal to max_latency"

  @hten_C01.03_invalid_bandwidth_unit
  Scenario: Submit request with unsupported bandwidth unit
    Given a TransmissionRequest body where bandwidth_requirement.unit is set to "Kbps" (unsupported)
    When the request "submitTransmissionSchedule" is sent to "/high-throughput-elastic-network/transmission/schedule"
    Then the response status code is 400
    And the response body complies with the OAS schema at "#/components/schemas/ErrorResponse"
    And the response property "$.error_code" is "INVALID_PARAMETER"
    And the response property "$.error_message" contains "unsupported bandwidth unit"

  @hten_C01.04_invalid_file_size_unit
  Scenario: Submit request with unsupported file size unit
    Given a TransmissionRequest body where file_requirements.unit is set to "EB" (unsupported)
    When the request "submitTransmissionSchedule" is sent to "/high-throughput-elastic-network/transmission/schedule"
    Then the response status code is 400
    And the response body complies with the OAS schema at "#/components/schemas/ErrorResponse"
    And the response property "$.error_code" is "INVALID_PARAMETER"
    And the response property "$.error_message" contains "unsupported file size unit"

  @hten_C01.05_missing_required_field
  Scenario: Submit request with missing required bandwidth_requirement
    Given a TransmissionRequest body without the "bandwidth_requirement" field
    When the request "submitTransmissionSchedule" is sent to "/high-throughput-elastic-network/transmission/schedule"
    Then the response status code is 400
    And the response body complies with the OAS schema at "#/components/schemas/ErrorResponse"
    And the response property "$.error_code" is "INVALID_PARAMETER"
    And the response property "$.error_message" contains "missing required field: bandwidth_requirement"

  @hten_C01.06_bandwidth_value_below_min
  Scenario: Submit request with bandwidth value below minimum
    Given a TransmissionRequest body where bandwidth_requirement.bandwidth_value is 0.0005 (below 0.001)
    When the request "submitTransmissionSchedule" is sent to "/high-throughput-elastic-network/transmission/schedule"
    Then the response status code is 400
    And the response body complies with the OAS schema at "#/components/schemas/ErrorResponse"
    And the response property "$.error_code" is "INVALID_PARAMETER"
    And the response property "$.error_message" contains "bandwidth value must be at least 0.001"

  # Error scenarios - 401 Unauthorized
  @hten_401.01_missing_authorization_header
  Scenario: Submit request without Authorization header
    Given a valid TransmissionRequest body
    And the request does not include the "Authorization" header
    When the request "submitTransmissionSchedule" is sent to "/high-throughput-elastic-network/transmission/schedule"
    Then the response status code is 401
    And the response body complies with the OAS schema at "#/components/schemas/ErrorResponse"
    And the response property "$.execution_result" is "failure"
    And the response property "$.error_code" is "UNAUTHORIZED"
    And the response property "$.error_message" contains "invalid or missing authentication"

  @hten_401.02_invalid_api_key
  Scenario: Submit request with invalid API key
    Given a valid TransmissionRequest body
    And the header "Authorization" is set to an invalid API key
    When the request "submitTransmissionSchedule" is sent to "/high-throughput-elastic-network/transmission/schedule"
    Then the response status code is 401
    And the response body complies with the OAS schema at "#/components/schemas/ErrorResponse"
    And the response property "$.error_code" is "UNAUTHORIZED"

  @hten_401.03_expired_oauth_token
  Scenario: Submit request with expired OAuth 2.0 token
    Given a valid TransmissionRequest body
    And the header "Authorization" is set to an expired OAuth 2.0 token
    When the request "submitTransmissionSchedule" is sent to "/high-throughput-elastic-network/transmission/schedule"
    Then the response status code is 401
    And the response body complies with the OAS schema at "#/components/schemas/ErrorResponse"
    And the response property "$.error_code" is "UNAUTHORIZED"

  # Error scenarios - 403 Forbidden
  @hten_403.01_insufficient_scopes
  Scenario: Submit request with insufficient OAuth 2.0 scopes
    Given a valid TransmissionRequest body
    And the header "Authorization" is set to an OAuth 2.0 token with only "high_throughput_elastic_network:read" scope
    When the request "submitTransmissionSchedule" is sent to "/high-throughput-elastic-network/transmission/schedule"
    Then the response status code is 403
    And the response body complies with the OAS schema at "#/components/schemas/ErrorResponse"
    And the response property "$.error_code" is "FORBIDDEN"
    And the response property "$.error_message" contains "insufficient permissions"

  # Error scenarios - 500 Internal Server Error
  @hten_500.01_insufficient_network_resources
  Scenario: Submit request with insufficient network resources
    Given a valid TransmissionRequest body with extremely high bandwidth requirement (exceeds network capacity)
    When the request "submitTransmissionSchedule" is sent to "/high-throughput-elastic-network/transmission/schedule"
    Then the response status code is 500
    And the response body complies with the OAS schema at "#/components/schemas/ErrorResponse"
    And the response property "$.error_code" is "INSUFFICIENT_RESOURCES"
    And the response property "$.error_message" contains "insufficient network resources"

  # Scenario Outline for multiple invalid parameter types
  @hten_C02_invalid_parameter_outline
  Scenario Outline: Submit request with invalid parameter type
    Given a TransmissionRequest body where "<parameter_path>" is set to "<invalid_value>" (type mismatch)
    When the request "submitTransmissionSchedule" is sent to "/high-throughput-elastic-network/transmission/schedule"
    Then the response status code is 400
    And the response body complies with the OAS schema at "#/components/schemas/ErrorResponse"
    And the response property "$.error_code" is "INVALID_PARAMETER"
    And the response property "$.error_message" contains "invalid type for parameter"
    Examples:
      | parameter_path                              | invalid_value |
      | $.bandwidth_requirement[0].bandwidth_value  | "ten"         |
      | $.latency_requirement.min_latency           | "twenty"      |
      | $.file_requirements.file_size               | true          |
      | $.guarantee_requirements.bandwidth_guarantee_level | 123   |

  # Scenario for invalid bandwidth requirement type
  @hten_C03_invalid_bandwidth_type
  Scenario: Submit request with invalid bandwidth requirement type
    Given a TransmissionRequest body where bandwidth_requirement_type is set to "bidirectional" (unsupported)
    When the request "submitTransmissionSchedule" is sent to "/high-throughput-elastic-network/transmission/schedule"
    Then the response status code is 400
    And the response body complies with the OAS schema at "#/components/schemas/ErrorResponse"
    And the response property "$.error_code" is "INVALID_PARAMETER"
    And the response property "$.error_message" contains "unsupported bandwidth requirement type"

  # Scenario for invalid load sharing strategy
  @hten_C04_invalid_load_strategy
  Scenario: Submit request with invalid load sharing strategy
    Given a TransmissionRequest body where load_sharing_strategy is set to "round_robin" (unsupported)
    When the request "submitTransmissionSchedule" is sent to "/high-throughput-elastic-network/transmission/schedule"
    Then the response status code is 400
    And the response body complies with the OAS schema at "#/components/schemas/ErrorResponse"
    And the response property "$.error_code" is "INVALID_PARAMETER"
    And the response property "$.error_message" contains "unsupported load sharing strategy"