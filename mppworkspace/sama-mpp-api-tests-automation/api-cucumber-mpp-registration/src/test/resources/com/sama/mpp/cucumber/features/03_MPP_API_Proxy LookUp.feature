#Author: IBM Automation Team
@03_LookUpProxy
Feature: 03_MPP_API_Look UP Proxy 
@03_01_LOOKUPS_AccInfo
Scenario Outline: 03_01_MPP_API_To obtain the account information associated with a given Proxy
#########################  Encryption ##################################################
Given a REST API request "<requestFile>" and url "<encyptionEndpoint>" along with below headers under "%ENV%" environment
#----------------------------------------------------------------------------------------
#  | Headers         |                          Value                                   |
#----------------------------------------------------------------------------------------
   | accept          |                          <accept>                                |
   | content-type    |                        <content type>                            |
   | x-ibm-client-id |                       <x_ibm_client_id>                          |
When "POST" action is performed
Then the status code is "<statusCode>"
And "Json" response includes the following values as
#----------------------------------------------------------------------------------------
#  | Node            |                          Value                                   |
#----------------------------------------------------------------------------------------
   | encryptdata     |                       <Encrypted_Text>                           |
#########################  Generate OAUTH token  ########################################
 Given a encrypted output  "<cipherdata>" and url "<tokenEndpoint>" along with below headers under "%ENV%" environment
#----------------------------------------------------------------------------------------
#  | Headers             |                          Value                                   |
#----------------------------------------------------------------------------------------
   | accept              |                          <accept>                                |
   | content-type        |                        <content type>                            |
   | x-ibm-client-id     |                       <x_ibm_client_id>                          |
   | x-ibm-client-secret |                       <x_ibm_client_secret>                      |
When "POST" action is performed to genarate "encypted" access token
Then the status code is "<statusCode>"
And "Json" response includes the following values as
#----------------------------------------------------------------------------------------
#   |   Node            |                          Value                                   |
#----------------------------------------------------------------------------------------
   | cipheredData      |                       <Encrypted_Text>                           |
#########################  Decryption to get bearer Token  ########################################
  Given a encrypted output  "<cipherdata1>" and url "<decyptionEndpoint>" along with below headers under "%ENV%" environment
#----------------------------------------------------------------------------------------
 # | Headers             |                          Value                                   |
#----------------------------------------------------------------------------------------
   | accept              |                          <accept>                                |
   | content-type        |                        <content type>                            |
   | x-ibm-client-id     |                       <x_ibm_client_id>                          |
When "POST" action is performed to genarate "decypted" access token
Then the status code is "<statusCode>"
And "Json" response includes the following values as
#----------------------------------------------------------------------------------------
 # | Node            |                          Value                                   |
# ----------------------------------------------------------------------------------------
   | token_type      |                       <token_type>                               |
   | access_token    |                       <access_token>                             |
   | expires_in      |                       <expires_in>                               |
   | consented_on    |                       <consented_on>                             |
   | scope           |                       <scope>                                    |
############################################## Look Up Search   ########################
Given a REST API request "<lookupsRequestFile>" and url "<lookupsEndpoint>" along with below headers under "%ENV%" environment
#----------------------------------------------------------------------------------------
 # | Headers             |                          Value                                   |
#----------------------------------------------------------------------------------------
   | accept              |                          <accept>                                |
   | authorization       |                        <autorization>                           |
   | content-type        |                        <content type>                            |
   | participant-code    |                       <participant-code>                         |
   | x-ibm-client-id     |                       <x_ibm_client_id>                          |
When "POST" action is performed to retrieve "PROXY LOOKUPS"
Then the status code is "<statusCode>"
And "Json" response includes the following values as
#----------------------------------------------------------------------------------------
 # | Node                               |                          Value                   |
# ----------------------------------------------------------------------------------------
   | registrations[0].registrationId    |                       <Encrypted_Text>           |
   | registrations[0].participantCode   |                       <participant-code>         |
   | registrations[0].proxy.type        |                       <Proxy_Type>               |
   | registrations[0].proxy.value       |                       <Proxy_Value>              |
 ###########################################################################################
	Given Open browser "<Browser_Name>" 
	When Login to "<Portal_Name>" Portal under "%ENV%" environment with username as "<Username>" and password as "<Password>" 
	Then Navigate to below mentioned menu in order to reach "Enquiry By Registration Id" page 
	#---------------------------------------------------------------
	# | Menu                 		 				 |
	#---------------------------------------------------------------
	  | Registration Management    		 	 |
	  | Enquiry By Proxy                 |
  And Select "Proxy Type" as "<Proxy_Type>" under "Enquiry By Proxy" page
  Then Enter "Proxy Value" as "<Proxy_Value>" then click on "Search" button
  And Close the browser
  Examples:
|   requestFile      |    lookupsRequestFile    | encyptionEndpoint     |       tokenEndpoint         |  decyptionEndpoint      |               lookupsEndpoint             |statusCode|     accept       |   content type     |   x_ibm_client_id                  |                   x_ibm_client_secret                 |   Encrypted_Text   |token_type|access_token|expires_in|consented_on|scope|autorization | signature  | participant-code | Browser_Name  | Portal_Name |  Username      | Password    | Registration_Id |  display_Name  |Proxy_Type |             Proxy_Value                 |firstName |
| requestEncryption  | 03_01_lookupsRequestFile |/sp/dev/dummy/encrypt  | /sp/dev/v1/token/generation |  /sp/dev/dummy/decrypt  | /sp/sit/v1/customer-proxy-lookups/lookups |  200     |application/json |   application/json |02a18293-3e8b-4b90-9456-4cb291734386|  W6pR1aA0gX4aM2gC4aT5yU6xI8pV7nL3aM1pU8aL7oQ3cN7uC4   |    %NOTEMPTY%      | Bearer   | %NOTEMPTY% | 3600     | %NOTEMPTY% | ips | %RUNTIME%   | %RUNTIME%  |  SANCBK           | Chrome		     |    MPP      | operator.admin | burger_01   |  %RUNTIME%	    |  SANCBK Test59 |  EMAIL    | sancbkdummy121211test116@rssting.com    | firstname123 |
#| request.json  | /sp/dev/dummy/encrypt  | https://10.158.239.131/sp/dev/v1/token/generation |   https://10.158.244.98/sp/dev/dummy/decrypt |    200    | application/json |   application/json |9d62bf35-e1a5-4871-9ba9-bc288f82f33a|  rH3kO2eE2fW2kW5tC5nJ4tW1bU3eC1nD7xA0jX8fY6rJ0kQ1rE   |    %NOTEMPTY%      | Bearer   | %NOTEMPTY% | 3600   | %NOTEMPTY% | ips | 
    ####################################### THE END ####################
@03_02_LOOKUPS_RetiredParticipant
Scenario Outline: 03_02_MPP_API_To obtain the account information when participant is registered but in retired state currently.
#########################  Encryption ##################################################
Given a REST API request "<requestFile>" and url "<encyptionEndpoint>" along with below headers under "%ENV%" environment
#----------------------------------------------------------------------------------------
#  | Headers         |                          Value                                   |
#----------------------------------------------------------------------------------------
   | accept          |                          <accept>                                |
   | content-type    |                        <content type>                            |
   | x-ibm-client-id |                       <x_ibm_client_id>                          |
When "POST" action is performed
Then the status code is "<statusCode>"
And "Json" response includes the following values as
#----------------------------------------------------------------------------------------
#  | Node            |                          Value                                   |
#----------------------------------------------------------------------------------------
   | encryptdata     |                       <Encrypted_Text>                           |
#########################  Generate OAUTH token  ########################################
 Given a encrypted output  "<cipherdata>" and url "<tokenEndpoint>" along with below headers under "%ENV%" environment
#----------------------------------------------------------------------------------------
#  | Headers             |                          Value                                   |
#----------------------------------------------------------------------------------------
   | accept              |                          <accept>                                |
   | content-type        |                        <content type>                            |
   | x-ibm-client-id     |                       <x_ibm_client_id>                          |
   | x-ibm-client-secret |                       <x_ibm_client_secret>                      |
When "POST" action is performed to genarate "encypted" access token
Then the status code is "<statusCode>"
And "Json" response includes the following values as
#----------------------------------------------------------------------------------------
#   |   Node            |                          Value                                   |
#----------------------------------------------------------------------------------------
   | cipheredData      |                       <Encrypted_Text>                           |
#########################  Decryption to get bearer Token  ########################################
  Given a encrypted output  "<cipherdata1>" and url "<decyptionEndpoint>" along with below headers under "%ENV%" environment
#----------------------------------------------------------------------------------------
 # | Headers             |                          Value                                   |
#----------------------------------------------------------------------------------------
   | accept              |                          <accept>                                |
   | content-type        |                        <content type>                            |
   | x-ibm-client-id     |                       <x_ibm_client_id>                          |
When "POST" action is performed to genarate "decypted" access token
Then the status code is "<statusCode>"
And "Json" response includes the following values as
#----------------------------------------------------------------------------------------
 # | Node            |                          Value                                   |
# ----------------------------------------------------------------------------------------
   | token_type      |                       <token_type>                               |
   | access_token    |                       <access_token>                             |
   | expires_in      |                       <expires_in>                               |
   | consented_on    |                       <consented_on>                             |
   | scope           |                       <scope>                                    |
############################################## Look Up Search   ########################
Given a REST API request "<lookupsRequestFile>" and url "<lookupsEndpoint>" along with below headers under "%ENV%" environment
#----------------------------------------------------------------------------------------
 # | Headers             |                          Value                                   |
#----------------------------------------------------------------------------------------
   | accept              |                          <accept>                                |
   | authorization       |                        <autorization>                           |
   | content-type        |                        <content type>                            |
   | participant-code    |                       <participant-code>                         |
   | x-ibm-client-id     |                       <x_ibm_client_id>                          |
When "POST" action is performed to retrieve "PROXY LOOKUPS"
Then the status code is "<statusCode1>"
And "Json" response includes the following values as
#----------------------------------------------------------------------------------------
 # | Node            |                          Value                                   |
# ----------------------------------------------------------------------------------------
   | ReasonCode    |                       <ReasonCode>                           |
   | Description   |                       <Description>                          | 
 ###########################################################################################
  Examples:
|   requestFile      |    lookupsRequestFile    | encyptionEndpoint     |       tokenEndpoint         |  decyptionEndpoint      |               lookupsEndpoint             |statusCode|statusCode1 |     accept       |   content type     |   x_ibm_client_id                  |                   x_ibm_client_secret                 |   Encrypted_Text   |token_type|access_token|expires_in|consented_on|scope|autorization | signature  | participant-code | Browser_Name  | Portal_Name |  Username      | Password    | Registration_Id |  display_Name  |Proxy_Type |         Proxy_Value    |   ReasonCode    |     Description             |
| requestEncryption  | 03_02_lookupsRequestFile |/sp/dev/dummy/encrypt  | /sp/dev/v1/token/generation |  /sp/dev/dummy/decrypt  | /sp/sit/v1/customer-proxy-lookups/lookups |  200     |    403     |application/json |   application/json |02a18293-3e8b-4b90-9456-4cb291734386|  W6pR1aA0gX4aM2gC4aT5yU6xI8pV7nL3aM1pU8aL7oQ3cN7uC4   |    %NOTEMPTY%      | Bearer   | %NOTEMPTY% | 3600     | %NOTEMPTY% | ips | %RUNTIME%   | %RUNTIME%  |  SASABB           | Chrome		     |    MPP      | operator.admin | burger_01   |  %RUNTIME%	    |  SANCBK Test59 | EMAIL    |  sabjaz12@testing.com  |     703         |   Participant is retired     |
#| request.json  | /sp/dev/dummy/encrypt  | https://10.158.239.131/sp/dev/v1/token/generation |   https://10.158.244.98/sp/dev/dummy/decrypt |    200    | application/json |   application/json |9d62bf35-e1a5-4871-9ba9-bc288f82f33a|  rH3kO2eE2fW2kW5tC5nJ4tW1bU3eC1nD7xA0jX8fY6rJ0kQ1rE   |    %NOTEMPTY%      | Bearer   | %NOTEMPTY% | 3600   | %NOTEMPTY% | ips | 
    ####################################### THE END ####################
@03_03_LOOKUPS_InvalidProxy
Scenario Outline: 03_03_MPP_API_To obtain the account information when participant is registered but in retired state currently.
#########################  Encryption ##################################################
Given a REST API request "<requestFile>" and url "<encyptionEndpoint>" along with below headers under "%ENV%" environment
#----------------------------------------------------------------------------------------
#  | Headers         |                          Value                                   |
#----------------------------------------------------------------------------------------
   | accept          |                          <accept>                                |
   | content-type    |                        <content type>                            |
   | x-ibm-client-id |                       <x_ibm_client_id>                          |
When "POST" action is performed
Then the status code is "<statusCode>"
And "Json" response includes the following values as
#----------------------------------------------------------------------------------------
#  | Node            |                          Value                                   |
#----------------------------------------------------------------------------------------
   | encryptdata     |                       <Encrypted_Text>                           |
#########################  Generate OAUTH token  ########################################
 Given a encrypted output  "<cipherdata>" and url "<tokenEndpoint>" along with below headers under "%ENV%" environment
#----------------------------------------------------------------------------------------
#  | Headers             |                          Value                                   |
#----------------------------------------------------------------------------------------
   | accept              |                          <accept>                                |
   | content-type        |                        <content type>                            |
   | x-ibm-client-id     |                       <x_ibm_client_id>                          |
   | x-ibm-client-secret |                       <x_ibm_client_secret>                      |
When "POST" action is performed to genarate "encypted" access token
Then the status code is "<statusCode>"
And "Json" response includes the following values as
#----------------------------------------------------------------------------------------
#   |   Node            |                          Value                                   |
#----------------------------------------------------------------------------------------
   | cipheredData      |                       <Encrypted_Text>                           |
#########################  Decryption to get bearer Token  ########################################
  Given a encrypted output  "<cipherdata1>" and url "<decyptionEndpoint>" along with below headers under "%ENV%" environment
#----------------------------------------------------------------------------------------
 # | Headers             |                          Value                                   |
#----------------------------------------------------------------------------------------
   | accept              |                          <accept>                                |
   | content-type        |                        <content type>                            |
   | x-ibm-client-id     |                       <x_ibm_client_id>                          |
When "POST" action is performed to genarate "decypted" access token
Then the status code is "<statusCode>"
And "Json" response includes the following values as
#----------------------------------------------------------------------------------------
 # | Node            |                          Value                                   |
# ----------------------------------------------------------------------------------------
   | token_type      |                       <token_type>                               |
   | access_token    |                       <access_token>                             |
   | expires_in      |                       <expires_in>                               |
   | consented_on    |                       <consented_on>                             |
   | scope           |                       <scope>                                    |
############################################## Look Up Search   ########################
Given a REST API request "<lookupsRequestFile>" and url "<lookupsEndpoint>" along with below headers under "%ENV%" environment
#----------------------------------------------------------------------------------------
 # | Headers             |                          Value                                   |
#----------------------------------------------------------------------------------------
   | accept              |                          <accept>                                |
   | authorization       |                        <autorization>                           |
   | content-type        |                        <content type>                            |
   | participant-code    |                       <participant-code>                         |
   | x-ibm-client-id     |                       <x_ibm_client_id>                          |
When "POST" action is performed to retrieve "PROXY LOOKUPS"
Then the status code is "<statusCode1>"
And "Json" response includes the following values as
#----------------------------------------------------------------------------------------
 # | Node            |                          Value                                   |
# ----------------------------------------------------------------------------------------
   | ReasonCode    |                       <ReasonCode>                           |
   | Description   |                       <Description>                          | 
 ###########################################################################################
 ###########################################################################################

  Examples:
|   requestFile      |    lookupsRequestFile    | encyptionEndpoint     |       tokenEndpoint         |  decyptionEndpoint      |               lookupsEndpoint             |statusCode|statusCode1 |     accept       |   content type     |   x_ibm_client_id                  |                   x_ibm_client_secret                 |   Encrypted_Text   |token_type|access_token|expires_in|consented_on|scope|autorization | signature  | participant-code | Browser_Name  | Portal_Name |  Username      | Password    | Registration_Id |  display_Name    |Proxy_Type       |  Proxy_Value    | ReasonCode |     Description            |
| requestEncryption  | 03_03_lookupsRequestFile |/sp/dev/dummy/encrypt  | /sp/dev/v1/token/generation |  /sp/dev/dummy/decrypt  | /sp/sit/v1/customer-proxy-lookups/lookups |  200     |    400     |application/json |   application/json |02a18293-3e8b-4b90-9456-4cb291734386|  W6pR1aA0gX4aM2gC4aT5yU6xI8pV7nL3aM1pU8aL7oQ3cN7uC4   |    %NOTEMPTY%      | Bearer   | %NOTEMPTY% | 3600     | %NOTEMPTY% | ips | %RUNTIME%   | %RUNTIME%  |  SANCBK           | Chrome		     |    MPP      | operator.admin | burger_01   |  %RUNTIME%	    |  SANCBK Test59  |  MSISDN_Inval   | 045123456789   |     802    |   Proxy type is not valid  |
#| request.json  | /sp/dev/dummy/encrypt  | https://10.158.239.131/sp/dev/v1/token/generation |   https://10.158.244.98/sp/dev/dummy/decrypt |    200    | application/json |   application/json |9d62bf35-e1a5-4871-9ba9-bc288f82f33a|  rH3kO2eE2fW2kW5tC5nJ4tW1bU3eC1nD7xA0jX8fY6rJ0kQ1rE   |    %NOTEMPTY%      | Bearer   | %NOTEMPTY% | 3600   | %NOTEMPTY% | ips | 
    ####################################### THE END ####################
@03_04_LOOKUPS_RetiredParticipant
Scenario Outline: 03_04_MPP_API_To obtain the account information associated with a given proxy when owning participant is in retired state currently.
#########################  Encryption ##################################################
Given a REST API request "<requestFile>" and url "<encyptionEndpoint>" along with below headers under "%ENV%" environment
#----------------------------------------------------------------------------------------
#  | Headers         |                          Value                                   |
#----------------------------------------------------------------------------------------
   | accept          |                          <accept>                                |
   | content-type    |                        <content type>                            |
   | x-ibm-client-id |                       <x_ibm_client_id>                          |
When "POST" action is performed
Then the status code is "<statusCode>"
And "Json" response includes the following values as
#----------------------------------------------------------------------------------------
#  | Node            |                          Value                                   |
#----------------------------------------------------------------------------------------
   | encryptdata     |                       <Encrypted_Text>                           |
#########################  Generate OAUTH token  ########################################
 Given a encrypted output  "<cipherdata>" and url "<tokenEndpoint>" along with below headers under "%ENV%" environment
#----------------------------------------------------------------------------------------
#  | Headers             |                          Value                                   |
#----------------------------------------------------------------------------------------
   | accept              |                          <accept>                                |
   | content-type        |                        <content type>                            |
   | x-ibm-client-id     |                       <x_ibm_client_id>                          |
   | x-ibm-client-secret |                       <x_ibm_client_secret>                      |
When "POST" action is performed to genarate "encypted" access token
Then the status code is "<statusCode>"
And "Json" response includes the following values as
#----------------------------------------------------------------------------------------
#   |   Node            |                          Value                                   |
#----------------------------------------------------------------------------------------
   | cipheredData      |                       <Encrypted_Text>                           |
#########################  Decryption to get bearer Token  ########################################
  Given a encrypted output  "<cipherdata1>" and url "<decyptionEndpoint>" along with below headers under "%ENV%" environment
#----------------------------------------------------------------------------------------
 # | Headers             |                          Value                                   |
#----------------------------------------------------------------------------------------
   | accept              |                          <accept>                                |
   | content-type        |                        <content type>                            |
   | x-ibm-client-id     |                       <x_ibm_client_id>                          |
When "POST" action is performed to genarate "decypted" access token
Then the status code is "<statusCode>"
And "Json" response includes the following values as
#----------------------------------------------------------------------------------------
 # | Node            |                          Value                                   |
# ----------------------------------------------------------------------------------------
   | token_type      |                       <token_type>                               |
   | access_token    |                       <access_token>                             |
   | expires_in      |                       <expires_in>                               |
   | consented_on    |                       <consented_on>                             |
   | scope           |                       <scope>                                    |
############################################## Look Up Search   ########################
Given a REST API request "<lookupsRequestFile>" and url "<lookupsEndpoint>" along with below headers under "%ENV%" environment
#----------------------------------------------------------------------------------------
 # | Headers             |                          Value                                   |
#----------------------------------------------------------------------------------------
   | accept              |                          <accept>                                |
   | authorization       |                        <autorization>                           |
   | content-type        |                        <content type>                            |
   | participant-code    |                       <participant-code>                         |
   | x-ibm-client-id     |                       <x_ibm_client_id>                          |
When "POST" action is performed to retrieve "PROXY LOOKUPS"
Then the status code is "<statusCode1>"
And "Json" response includes the following values as
#----------------------------------------------------------------------------------------
 # | Node            |                          Value                                   |
# ----------------------------------------------------------------------------------------
   | ReasonCode    |                       <ReasonCode>                           |
   | Description   |                       <Description>                          | 
 ###########################################################################################
 ###########################################################################################
	Given Open browser "<Browser_Name>" 
	When Login to "<Portal_Name>" Portal under "%ENV%" environment with username as "<Username>" and password as "<Password>" 
	Then Navigate to below mentioned menu in order to reach "Enquiry By Registration Id" page 
	#---------------------------------------------------------------
	# | Menu                 		 				 |
	#---------------------------------------------------------------
	  | Registration Management    		 	 |
	  | Enquiry By Proxy                 |
  And Select "Proxy Type" as "<Proxy_Type>" under "Enquiry By Proxy" page
  Then Enter "Proxy Value" as "<Proxy_Value>" then click on "Search" button
  And Close the browser
  Examples:
|   requestFile      |    lookupsRequestFile    | encyptionEndpoint     |       tokenEndpoint         |  decyptionEndpoint      |               lookupsEndpoint             |statusCode|statusCode1 |     accept       |   content type     |   x_ibm_client_id                  |                   x_ibm_client_secret                 |   Encrypted_Text   |token_type|access_token|expires_in|consented_on|scope|autorization | signature  | participant-code | Browser_Name  | Portal_Name |  Username      | Password    | Registration_Id |  display_Name  |Proxy_Type |  Proxy_Value    |ReasonCode    |                              Description                   |
| requestEncryption  | 03_04_lookupsRequestFile |/sp/dev/dummy/encrypt  | /sp/dev/v1/token/generation |  /sp/dev/dummy/decrypt  | /sp/sit/v1/customer-proxy-lookups/lookups |  200     |    404     |application/json |   application/json |02a18293-3e8b-4b90-9456-4cb291734386|  W6pR1aA0gX4aM2gC4aT5yU6xI8pV7nL3aM1pU8aL7oQ3cN7uC4   |    %NOTEMPTY%      | Bearer   | %NOTEMPTY% | 3600     | %NOTEMPTY% | ips | %RUNTIME%   | %RUNTIME%  |  SANCBK           | Chrome		     |    MPP      | operator.admin | burger_01   |  %RUNTIME%	    |  SANCBK Test59 |  MSISDN   | 045123456789    |     707      |   Participant of registration being looked-up is retired   |
#| request.json  | /sp/dev/dummy/encrypt  | https://10.158.239.131/sp/dev/v1/token/generation |   https://10.158.244.98/sp/dev/dummy/decrypt |    200    | application/json |   application/json |9d62bf35-e1a5-4871-9ba9-bc288f82f33a|  rH3kO2eE2fW2kW5tC5nJ4tW1bU3eC1nD7xA0jX8fY6rJ0kQ1rE   |    %NOTEMPTY%      | Bearer   | %NOTEMPTY% | 3600   | %NOTEMPTY% | ips | 
    ####################################### THE END ####################
@03_05_LOOKUPS_NotRegisteredToken
Scenario Outline: 03_05_MPP_API_To obtain the account information associated with a given proxy which is not registered.
#########################  Encryption ##################################################
Given a REST API request "<requestFile>" and url "<encyptionEndpoint>" along with below headers under "%ENV%" environment
#----------------------------------------------------------------------------------------
#  | Headers         |                          Value                                   |
#----------------------------------------------------------------------------------------
   | accept          |                          <accept>                                |
   | content-type    |                        <content type>                            |
   | x-ibm-client-id |                       <x_ibm_client_id>                          |
When "POST" action is performed
Then the status code is "<statusCode>"
And "Json" response includes the following values as
#----------------------------------------------------------------------------------------
#  | Node            |                          Value                                   |
#----------------------------------------------------------------------------------------
   | encryptdata     |                       <Encrypted_Text>                           |
#########################  Generate OAUTH token  ########################################
 Given a encrypted output  "<cipherdata>" and url "<tokenEndpoint>" along with below headers under "%ENV%" environment
#----------------------------------------------------------------------------------------
#  | Headers             |                          Value                                   |
#----------------------------------------------------------------------------------------
   | accept              |                          <accept>                                |
   | content-type        |                        <content type>                            |
   | x-ibm-client-id     |                       <x_ibm_client_id>                          |
   | x-ibm-client-secret |                       <x_ibm_client_secret>                      |
When "POST" action is performed to genarate "encypted" access token
Then the status code is "<statusCode>"
And "Json" response includes the following values as
#----------------------------------------------------------------------------------------
#   |   Node            |                          Value                                   |
#----------------------------------------------------------------------------------------
   | cipheredData      |                       <Encrypted_Text>                           |
#########################  Decryption to get bearer Token  ########################################
  Given a encrypted output  "<cipherdata1>" and url "<decyptionEndpoint>" along with below headers under "%ENV%" environment
#----------------------------------------------------------------------------------------
 # | Headers             |                          Value                                   |
#----------------------------------------------------------------------------------------
   | accept              |                          <accept>                                |
   | content-type        |                        <content type>                            |
   | x-ibm-client-id     |                       <x_ibm_client_id>                          |
When "POST" action is performed to genarate "decypted" access token
Then the status code is "<statusCode>"
And "Json" response includes the following values as
#----------------------------------------------------------------------------------------
 # | Node            |                          Value                                   |
# ----------------------------------------------------------------------------------------
   | token_type      |                       <token_type>                               |
   | access_token    |                       <access_token>                             |
   | expires_in      |                       <expires_in>                               |
   | consented_on    |                       <consented_on>                             |
   | scope           |                       <scope>                                    |
############################################## Look Up Search   ########################
Given a REST API request "<lookupsRequestFile>" and url "<lookupsEndpoint>" along with below headers under "%ENV%" environment
#----------------------------------------------------------------------------------------
 # | Headers             |                          Value                                   |
#----------------------------------------------------------------------------------------
   | accept              |                          <accept>                                |
   | authorization       |                        <autorization>                           |
   | content-type        |                        <content type>                            |
   | participant-code    |                       <participant-code>                         |
   | x-ibm-client-id     |                       <x_ibm_client_id>                          |
When "POST" action is performed to retrieve "PROXY LOOKUPS"
Then the status code is "<statusCode1>"
And "Json" response includes the following values as
#----------------------------------------------------------------------------------------
 # | Node            |                          Value                                   |
# ----------------------------------------------------------------------------------------
   | ReasonCode    |                       <ReasonCode>                           |
   | Description   |                       <Description>                          | 
 ###########################################################################################
  Examples:
|   requestFile      |    lookupsRequestFile    | encyptionEndpoint     |       tokenEndpoint         |  decyptionEndpoint      |               lookupsEndpoint             |statusCode|statusCode1 |     accept       |   content type     |   x_ibm_client_id                  |                   x_ibm_client_secret                 |   Encrypted_Text   |token_type|access_token|expires_in|consented_on|scope|autorization | signature  | participant-code | Browser_Name  | Portal_Name |  Username      | Password    | Registration_Id |  display_Name  |Proxy_Type |  Proxy_Value    |ReasonCode    |   Description               |
| requestEncryption  | 03_05_lookupsRequestFile |/sp/dev/dummy/encrypt  | /sp/dev/v1/token/generation |  /sp/dev/dummy/decrypt  | /sp/sit/v1/customer-proxy-lookups/lookups |  200     |    404     |application/json |   application/json |02a18293-3e8b-4b90-9456-4cb291734386|  W6pR1aA0gX4aM2gC4aT5yU6xI8pV7nL3aM1pU8aL7oQ3cN7uC4   |    %NOTEMPTY%      | Bearer   | %NOTEMPTY% | 3600     | %NOTEMPTY% | ips | %RUNTIME%   | %RUNTIME%  |  SANCBK           | Chrome		     |    MPP      | operator.admin | burger_01   |  %RUNTIME%	   |  SANCBK Test59 |  BILLERID   | 123456789      |     801     |   Proxy is not registered   |
 
    ####################################### THE END ####################     

#"registrationId": "f6447d23-7650-4cb9-994f-622a2f323d82"   //active
