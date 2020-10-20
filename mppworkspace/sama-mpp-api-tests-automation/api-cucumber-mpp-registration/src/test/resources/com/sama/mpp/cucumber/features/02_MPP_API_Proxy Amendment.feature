#Author: IBM Automation Team
@02_AmendRegistration
Feature: 02_MPP_API_Proxy Amendment
@02_01_Amendment_PersonName
Scenario Outline: 02_01_MPP_API_Amend Person name details for an already registered individual participant
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
 ################################################ Create Signature #####################################
#Given a encrypted output  "<cipherdata1>" and url "<decyptionEndpoint>" along with below headers under "%ENV%" environment
Given a REST API request "<signatureRequestFile>" and url "<signatureEndpoint>" along with below headers under "%ENV%" environment
#----------------------------------------------------------------------------------------
 # | Headers             |                          Value                                   |
#----------------------------------------------------------------------------------------
   | accept              |                          <accept>                                |
   | content-type        |                        <content type>                            |
   | x-ibm-client-id     |                       <x_ibm_client_id>                          |
When "POST" action is performed to genarate signature for "Proxy Registration"
Then the status code is "<statusCode>"
And "Json" response includes the following values as
#----------------------------------------------------------------------------------------
 # | Node            |                          Value                                   |
# ----------------------------------------------------------------------------------------
   | signature       |                       <Encrypted_Text>                           |
############################################## Generate Proxy Registration ########################
Given a REST API request "<signatureRequestFile>" and url "<registrationEndpoint>" along with below headers under "%ENV%" environment
#----------------------------------------------------------------------------------------
 # | Headers             |                          Value                                   |
#----------------------------------------------------------------------------------------
   | accept              |                          <accept>                                |
   | authorization       |                        <autorization>                           |
   | content-type        |                        <content type>                            |
   | signature           |                         <signature>                              |
   | participant-code    |                       <participant-code>                         |
   | x-ibm-client-id     |                       <x_ibm_client_id>                          |
When "POST" action is performed to genarate "Proxy Registration"
Then the status code is "<statusCode1>"
And "Json" response includes the following values as
#----------------------------------------------------------------------------------------
 # | Node              |                          Value                                   |
# ----------------------------------------------------------------------------------------
   | registrationId    |                       <Encrypted_Text>                           |
###########################################################################################
Given a REST API request "<signatureRequestFile>" and url "<signatureEndpoint>" along with below headers under "%ENV%" environment
#----------------------------------------------------------------------------------------
 # | Headers             |                          Value                                   |
#----------------------------------------------------------------------------------------
   | accept              |                          <accept>                                |
   | content-type        |                        <content type>                            |
   | x-ibm-client-id     |                       <x_ibm_client_id>                          |
And Perform the below Proxy Amendment for registration "<registrationID>" and generate a new REST API request "<signatureRequestFileAmendment>"
#----------------------------------------------------------------------------------------
 # |    Keys             |                          Value                                   |
#----------------------------------------------------------------------------------------
    | displayName                    |                        <display_Name>                |
    | accountHolder.person.firstName |                        <firstName>                   |
When "POST" action is performed to genarate signature for "Proxy Amendment"
Then the status code is "<statusCode>"
And "Json" response includes the following values as
#----------------------------------------------------------------------------------------
 # | Node            |                          Value                                   |
# ----------------------------------------------------------------------------------------
   | signature       |                       <Encrypted_Text>                           |
 ############################################## Proxy Amendment  ########################
Given a REST API request "<requestFileNew>" and url "<registrationEndpoint>" along with below headers under "%ENV%" environment
#----------------------------------------------------------------------------------------
 # | Headers             |                          Value                                   |
#----------------------------------------------------------------------------------------
   | accept              |                          <accept>                                |
   | authorization       |                        <autorization>                            |
   | content-type        |                        <content type>                            |
   | signature           |                         <signature>                              |
   | participant-code    |                       <participant-code>                         |
   | x-ibm-client-id     |                       <x_ibm_client_id>                          |
When "PUT" action is performed for Proxy Amendment having registration ID "<Registration_Id>"
Then the status code is "<statusCode2>"
#And "Json" response includes the following values as
#----------------------------------------------------------------------------------------
 # | Node            |                          Value                                   |
# ----------------------------------------------------------------------------------------
#   | registration    |                       <Encrypted_Text>                           | 
 ###########################################################################################
	Given Open browser "<Browser_Name>" 
	When Login to "<Portal_Name>" Portal under "%ENV%" environment with username as "<Username>" and password as "<Password>" 
	Then Navigate to below mentioned menu in order to reach "Enquiry By Registration Id" page 
	#---------------------------------------------------------------
	# | Menu                 		 				 |
	#---------------------------------------------------------------
	  | Registration Management    		 	 |
	  | Enquiry By Registration Id       |
  And Enter "Registration Id" as "<Registration_Id>" then click on "Search" button
  And Close the browser
  Examples:
|   requestFile      |    signatureRequestFile  |   signatureRequestFileAmendment  | encyptionEndpoint     |       tokenEndpoint         |  decyptionEndpoint      |    signatureEndpoint   |              registrationEndpoint                     |statusCode| statusCode1 |statusCode2 |     accept       |   content type     |   x_ibm_client_id                  |                   x_ibm_client_secret                 |   Encrypted_Text   |token_type|access_token|expires_in|consented_on|scope|autorization | signature  | participant-code | Browser_Name  | Portal_Name |  Username      | Password    | Registration_Id |  display_Name  |             proxy_value                  |firstName |
| requestEncryption  | 02_01_generateSignature  |  02_01_generateSignatureAmendment|/sp/dev/dummy/encrypt  | /sp/dev/v1/token/generation |  /sp/dev/dummy/decrypt  | /sp/dev/dummy/generate | /sp/sit/v1/customer-proxy-registrations/registrations |  200     |  201        |    204     |application/json |   application/json |02a18293-3e8b-4b90-9456-4cb291734386|  W6pR1aA0gX4aM2gC4aT5yU6xI8pV7nL3aM1pU8aL7oQ3cN7uC4   |    %NOTEMPTY%      | Bearer   | %NOTEMPTY% | 3600     | %NOTEMPTY% | ips | %RUNTIME%   | %RUNTIME%  |  SANCBK           | Chrome		     |    MPP      | operator.admin | burger_01   |  %RUNTIME%	    |  SANCBK Test59 |   SANCBKdummy121211test104@rssting.com    | firstname123 |
#| request.json  | /sp/dev/dummy/encrypt  | https://10.158.239.131/sp/dev/v1/token/generation |   https://10.158.244.98/sp/dev/dummy/decrypt |    200    | application/json |   application/json |9d62bf35-e1a5-4871-9ba9-bc288f82f33a|  rH3kO2eE2fW2kW5tC5nJ4tW1bU3eC1nD7xA0jX8fY6rJ0kQ1rE   |    %NOTEMPTY%      | Bearer   | %NOTEMPTY% | 3600   | %NOTEMPTY% | ips | 
    ####################################### THE END ####################
 @02_02_Amendment_AccNumber
Scenario Outline: 02_02_MPP_API_Amend name details for an already registered individual participant
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
 ################################################ Create Signature #####################################
#Given a encrypted output  "<cipherdata1>" and url "<decyptionEndpoint>" along with below headers under "%ENV%" environment
Given a REST API request "<signatureRequestFile>" and url "<signatureEndpoint>" along with below headers under "%ENV%" environment
#----------------------------------------------------------------------------------------
 # | Headers             |                          Value                                   |
#----------------------------------------------------------------------------------------
   | accept              |                          <accept>                                |
   | content-type        |                        <content type>                            |
   | x-ibm-client-id     |                       <x_ibm_client_id>                          |
When "POST" action is performed to genarate signature for "Proxy Registration"
Then the status code is "<statusCode>"
And "Json" response includes the following values as
#----------------------------------------------------------------------------------------
 # | Node            |                          Value                                   |
# ----------------------------------------------------------------------------------------
   | signature       |                       <Encrypted_Text>                           |
############################################## Generate Proxy Registration ########################
Given a REST API request "<signatureRequestFile>" and url "<registrationEndpoint>" along with below headers under "%ENV%" environment
#----------------------------------------------------------------------------------------
 # | Headers             |                          Value                                   |
#----------------------------------------------------------------------------------------
   | accept              |                          <accept>                                |
   | authorization       |                        <autorization>                           |
   | content-type        |                        <content type>                            |
   | signature           |                         <signature>                              |
   | participant-code    |                       <participant-code>                         |
   | x-ibm-client-id     |                       <x_ibm_client_id>                          |
When "POST" action is performed to genarate "Proxy Registration"
Then the status code is "<statusCode1>"
And "Json" response includes the following values as
#----------------------------------------------------------------------------------------
 # | Node              |                          Value                                   |
# ----------------------------------------------------------------------------------------
   | registrationId    |                       <Encrypted_Text>                           |
###########################################################################################
Given a REST API request "<signatureRequestFile>" and url "<signatureEndpoint>" along with below headers under "%ENV%" environment
#----------------------------------------------------------------------------------------
 # | Headers             |                          Value                                   |
#----------------------------------------------------------------------------------------
   | accept              |                          <accept>                                |
   | content-type        |                        <content type>                            |
   | x-ibm-client-id     |                       <x_ibm_client_id>                          |
And Perform the below Proxy Amendment for registration "<registrationID>" and generate a new REST API request "<signatureRequestFileAmendment>"
#----------------------------------------------------------------------------------------
 # |    Keys             |                          Value                                   |
#----------------------------------------------------------------------------------------
   | account.value                  |                         <account_value>              |
    | displayName                    |                        <display_Name>                |
 #   | proxy.value                    |                        <proxy_value>                 |
 #   | accountHolder.person.firstName |                        <firstName>                   |
When "POST" action is performed to genarate signature for "Proxy Amendment"
Then the status code is "<statusCode>"
And "Json" response includes the following values as
#----------------------------------------------------------------------------------------
 # | Node            |                          Value                                   |
# ----------------------------------------------------------------------------------------
   | signature       |                       <Encrypted_Text>                           |
 ############################################## Proxy Amendment  ########################
Given a REST API request "<requestFileNew>" and url "<registrationEndpoint>" along with below headers under "%ENV%" environment
#----------------------------------------------------------------------------------------
 # | Headers             |                          Value                                   |
#----------------------------------------------------------------------------------------
   | accept              |                          <accept>                                |
   | authorization       |                        <autorization>                            |
   | content-type        |                        <content type>                            |
   | signature           |                         <signature>                              |
   | participant-code    |                       <participant-code>                         |
   | x-ibm-client-id     |                       <x_ibm_client_id>                          |
When "PUT" action is performed for Proxy Amendment having registration ID "<Registration_Id>"
Then the status code is "<statusCode2>"
#And "Json" response includes the following values as
#----------------------------------------------------------------------------------------
 # | Node            |                          Value                                   |
# ----------------------------------------------------------------------------------------
#   | registration    |                       <Encrypted_Text>                           | 
 ###########################################################################################
	Given Open browser "<Browser_Name>" 
	When Login to "<Portal_Name>" Portal under "%ENV%" environment with username as "<Username>" and password as "<Password>" 
	Then Navigate to below mentioned menu in order to reach "Enquiry By Registration Id" page 
	#---------------------------------------------------------------
	# | Menu                 		 				 |
	#---------------------------------------------------------------
	  | Registration Management    		 	 |
	  | Enquiry By Registration Id       |
  And Enter "Registration Id" as "<Registration_Id>" then click on "Search" button
  And Close the browser
  Examples:
|   requestFile      |    signatureRequestFile  |   signatureRequestFileAmendment  | encyptionEndpoint     |       tokenEndpoint         |  decyptionEndpoint      |    signatureEndpoint   |              registrationEndpoint                     |statusCode| statusCode1 |statusCode2 |     accept       |   content type     |   x_ibm_client_id                  |                   x_ibm_client_secret                 |   Encrypted_Text   |token_type|access_token|expires_in|consented_on|scope|autorization | signature  | participant-code | Browser_Name  | Portal_Name |  Username      | Password    | Registration_Id |  display_Name  |  account_value |        
| requestEncryption  | 02_01_generateSignature  |  02_02_generateSignatureAmendment|/sp/dev/dummy/encrypt  | /sp/dev/v1/token/generation |  /sp/dev/dummy/decrypt  | /sp/dev/dummy/generate | /sp/sit/v1/customer-proxy-registrations/registrations |  200     |  201        |    204     |application/json |   application/json |02a18293-3e8b-4b90-9456-4cb291734386|  W6pR1aA0gX4aM2gC4aT5yU6xI8pV7nL3aM1pU8aL7oQ3cN7uC4   |    %NOTEMPTY%      | Bearer   | %NOTEMPTY% | 3600     | %NOTEMPTY% | ips | %RUNTIME%   | %RUNTIME%  |  SANCBK           | Chrome		     |    MPP      | operator.admin | burger_01   |  %RUNTIME%	    |  SANCBK Test59 | SANCBK123456699|
#| request.json  | /sp/dev/dummy/encrypt  | https://10.158.239.131/sp/dev/v1/token/generation |   https://10.158.244.98/sp/dev/dummy/decrypt |    200    | application/json |   application/json |9d62bf35-e1a5-4871-9ba9-bc288f82f33a|  rH3kO2eE2fW2kW5tC5nJ4tW1bU3eC1nD7xA0jX8fY6rJ0kQ1rE   |    %NOTEMPTY%      | Bearer   | %NOTEMPTY% | 3600   | %NOTEMPTY% | ips | 
    ####################################### THE END ####################
 @02_03_Amendment_NonExistRegID
Scenario Outline: 02_03_MPP_API_Amendment for registration ID when registration ID does not exist in MPP.
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
 ################################################ Create Signature #####################################
###########################################################################################
Given a REST API request "<signatureRequestFile>" and url "<signatureEndpoint>" along with below headers under "%ENV%" environment
#----------------------------------------------------------------------------------------
 # | Headers             |                          Value                                   |
#----------------------------------------------------------------------------------------
   | accept              |                          <accept>                                |
   | content-type        |                        <content type>                            |
   | x-ibm-client-id     |                       <x_ibm_client_id>                          |
And Perform the below Proxy Amendment for registration "<registrationID>" and generate a new REST API request "<signatureRequestFileAmendment>"
#----------------------------------------------------------------------------------------
 # |    Keys             |                          Value                                   |
#----------------------------------------------------------------------------------------
   | registrationId                  |                         <registrationId>              |
When "POST" action is performed to genarate signature for "Proxy Amendment"
Then the status code is "<statusCode>"
And "Json" response includes the following values as
#----------------------------------------------------------------------------------------
 # | Node            |                          Value                                   |
# ----------------------------------------------------------------------------------------
   | signature       |                       <Encrypted_Text>                           |
 ############################################## Proxy Amendment  ########################
Given a REST API request "<requestFileNew>" and url "<registrationEndpoint>" along with below headers under "%ENV%" environment
#----------------------------------------------------------------------------------------
 # | Headers             |                          Value                                   |
#----------------------------------------------------------------------------------------
   | accept              |                          <accept>                                |
   | authorization       |                        <autorization>                            |
   | content-type        |                        <content type>                            |
   | signature           |                         <signature>                              |
   | participant-code    |                       <participant-code>                         |
   | x-ibm-client-id     |                       <x_ibm_client_id>                          |
When "PUT" action is performed for Proxy Amendment having registration ID "<registrationId>"
Then the status code is "<statusCode2>"
And "Json" response includes the following values as
#----------------------------------------------------------------------------------------
 # | Node            |                          Value                                   |
# ----------------------------------------------------------------------------------------
   | ReasonCode    |                       <ReasonCode>                           |
   | Description   |                       <Description>                           | 
 ###########################################################################################

  Examples:
|   requestFile      |    signatureRequestFile  |   signatureRequestFileAmendment  | encyptionEndpoint     |       tokenEndpoint         |  decyptionEndpoint      |    signatureEndpoint   |              registrationEndpoint                     |statusCode| statusCode1 |statusCode2 |     accept       |   content type     |   x_ibm_client_id                  |                   x_ibm_client_secret                 |   Encrypted_Text   |token_type|access_token|expires_in|consented_on|scope|autorization | signature  | participant-code  |                 registrationId          | ReasonCode |          Description              | Browser_Name  | Portal_Name |  Username      | Password    |    
| requestEncryption  | 02_01_generateSignature  |  02_03_generateSignatureAmendment|/sp/dev/dummy/encrypt  | /sp/dev/v1/token/generation |  /sp/dev/dummy/decrypt  | /sp/dev/dummy/generate | /sp/sit/v1/customer-proxy-registrations/registrations |  200     |  201        |    404     |application/json |   application/json |02a18293-3e8b-4b90-9456-4cb291734386|  W6pR1aA0gX4aM2gC4aT5yU6xI8pV7nL3aM1pU8aL7oQ3cN7uC4   |    %NOTEMPTY%      | Bearer   | %NOTEMPTY% | 3600     | %NOTEMPTY% | ips | %RUNTIME%   | %RUNTIME%  |  SANCBK            |    b5f538cc-be90-4596-8363-5fe965ce6565 |  912       |    Registration ID does not exist | Chrome | MPP        | operator.admin | burger_01   |
#| request.json  | /sp/dev/dummy/encrypt  | https://10.158.239.131/sp/dev/v1/token/generation |   https://10.158.244.98/sp/dev/dummy/decrypt |    200    | application/json |   application/json |9d62bf35-e1a5-4871-9ba9-bc288f82f33a|  rH3kO2eE2fW2kW5tC5nJ4tW1bU3eC1nD7xA0jX8fY6rJ0kQ1rE   |    %NOTEMPTY%      | Bearer   | %NOTEMPTY% | 3600   | %NOTEMPTY% | ips | 
    ####################################### THE END ####################
 @02_04_Amendment_DeactivatedRegID
Scenario Outline: 02_04_MPP_API_Amendment for registration ID when registration ID is in inactive status in MPP.
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
 ################################################ Create Signature #####################################
###########################################################################################
Given a REST API request "<signatureRequestFile>" and url "<signatureEndpoint>" along with below headers under "%ENV%" environment
#----------------------------------------------------------------------------------------
 # | Headers             |                          Value                                   |
#----------------------------------------------------------------------------------------
   | accept              |                          <accept>                                |
   | content-type        |                        <content type>                            |
   | x-ibm-client-id     |                       <x_ibm_client_id>                          |
And Perform the below Proxy Amendment for registration "<registrationID>" and generate a new REST API request "<signatureRequestFileAmendment>"
#----------------------------------------------------------------------------------------
 # |    Keys             |                          Value                                   |
#----------------------------------------------------------------------------------------
   | registrationId                  |                         <registrationId>              |
When "POST" action is performed to genarate signature for "Proxy Amendment"
Then the status code is "<statusCode>"
And "Json" response includes the following values as
#----------------------------------------------------------------------------------------
 # | Node            |                          Value                                   |
# ----------------------------------------------------------------------------------------
   | signature       |                       <Encrypted_Text>                           |
 ############################################## Proxy Amendment  ########################
Given a REST API request "<requestFileNew>" and url "<registrationEndpoint>" along with below headers under "%ENV%" environment
#----------------------------------------------------------------------------------------
 # | Headers             |                          Value                                   |
#----------------------------------------------------------------------------------------
   | accept              |                          <accept>                                |
   | authorization       |                        <autorization>                            |
   | content-type        |                        <content type>                            |
   | signature           |                         <signature>                              |
   | participant-code    |                       <participant-code>                         |
   | x-ibm-client-id     |                       <x_ibm_client_id>                          |
When "PUT" action is performed for Proxy Amendment having registration ID "<registrationId>"
Then the status code is "<statusCode2>"
And "Json" response includes the following values as
#----------------------------------------------------------------------------------------
 # | Node            |                          Value                                   |
# ----------------------------------------------------------------------------------------
   | ReasonCode    |                       <ReasonCode>                           |
   | Description   |                       <Description>                           | 
 ###########################################################################################

  Examples:
|   requestFile      |    signatureRequestFile  |   signatureRequestFileAmendment  | encyptionEndpoint     |       tokenEndpoint         |  decyptionEndpoint      |    signatureEndpoint   |              registrationEndpoint                     |statusCode| statusCode1 |statusCode2 |     accept       |   content type     |   x_ibm_client_id                  |                   x_ibm_client_secret                 |   Encrypted_Text   |token_type|access_token|expires_in|consented_on|scope|autorization | signature  | participant-code  |                 registrationId          | ReasonCode |          Description              | 
| requestEncryption  | 02_01_generateSignature  |  02_04_generateSignatureAmendment|/sp/dev/dummy/encrypt  | /sp/dev/v1/token/generation |  /sp/dev/dummy/decrypt  | /sp/dev/dummy/generate | /sp/sit/v1/customer-proxy-registrations/registrations |  200     |  201        |    403     |application/json |   application/json |02a18293-3e8b-4b90-9456-4cb291734386|  W6pR1aA0gX4aM2gC4aT5yU6xI8pV7nL3aM1pU8aL7oQ3cN7uC4   |    %NOTEMPTY%      | Bearer   | %NOTEMPTY% | 3600     | %NOTEMPTY% | ips | %RUNTIME%   | %RUNTIME%  |  SANCBK            |    b5f538cc-be90-4596-8363-5fe965ce8377 |  917       |    Registration ID is deactivated | 
#| request.json  | /sp/dev/dummy/encrypt  | https://10.158.239.131/sp/dev/v1/token/generation |   https://10.158.244.98/sp/dev/dummy/decrypt |    200    | application/json |   application/json |9d62bf35-e1a5-4871-9ba9-bc288f82f33a|  rH3kO2eE2fW2kW5tC5nJ4tW1bU3eC1nD7xA0jX8fY6rJ0kQ1rE   |    %NOTEMPTY%      | Bearer   | %NOTEMPTY% | 3600   | %NOTEMPTY% | ips | 
    ####################################### THE END ####################

 @02_05_Amendment_NoUpdateFields
Scenario Outline: 02_05_MPP_API_Amendment for registration ID when there are no field available in the request to amendment.
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
 ################################################ Create Signature #####################################
###########################################################################################
Given a REST API request "<signatureRequestFile>" and url "<signatureEndpoint>" along with below headers under "%ENV%" environment
#----------------------------------------------------------------------------------------
 # | Headers             |                          Value                                   |
#----------------------------------------------------------------------------------------
   | accept              |                          <accept>                                |
   | content-type        |                        <content type>                            |
   | x-ibm-client-id     |                       <x_ibm_client_id>                          |
And Perform the below Proxy Amendment for registration "<registrationID>" and generate a new REST API request "<signatureRequestFileAmendment>"
#----------------------------------------------------------------------------------------
 # |    Keys             |                          Value                                   |
#----------------------------------------------------------------------------------------
   | registrationId                  |                         <registrationId>              |
When "POST" action is performed to genarate signature for "Proxy Amendment"
Then the status code is "<statusCode>"
And "Json" response includes the following values as
#----------------------------------------------------------------------------------------
 # | Node            |                          Value                                   |
# ----------------------------------------------------------------------------------------
   | signature       |                       <Encrypted_Text>                           |
 ############################################## Proxy Amendment  ########################
Given a REST API request "<requestFileNew>" and url "<registrationEndpoint>" along with below headers under "%ENV%" environment
#----------------------------------------------------------------------------------------
 # | Headers             |                          Value                                   |
#----------------------------------------------------------------------------------------
   | accept              |                          <accept>                                |
   | authorization       |                        <autorization>                            |
   | content-type        |                        <content type>                            |
   | signature           |                         <signature>                              |
   | participant-code    |                       <participant-code>                         |
   | x-ibm-client-id     |                       <x_ibm_client_id>                          |
When "PUT" action is performed for Proxy Amendment having registration ID "<registrationId>"
Then the status code is "<statusCode2>"
And "Json" response includes the following values as
#----------------------------------------------------------------------------------------
 # | Node            |                          Value                             |
# ----------------------------------------------------------------------------------------
   | ReasonCode    |                       <ReasonCode>                           |
   | Description   |                       <Description>                          | 
 ###########################################################################################

  Examples:
|   requestFile      |    signatureRequestFile  |   signatureRequestFileAmendment  | encyptionEndpoint     |       tokenEndpoint         |  decyptionEndpoint      |    signatureEndpoint   |              registrationEndpoint                     |statusCode| statusCode1 |statusCode2 |     accept       |   content type     |   x_ibm_client_id                  |                   x_ibm_client_secret                 |   Encrypted_Text   |token_type|access_token|expires_in|consented_on|scope|autorization | signature  | participant-code  |                 registrationId          | ReasonCode |                  Description                    | 
| requestEncryption  | 02_05_generateSignature  |  02_05_generateSignatureAmendment|/sp/dev/dummy/encrypt  | /sp/dev/v1/token/generation |  /sp/dev/dummy/decrypt  | /sp/dev/dummy/generate | /sp/sit/v1/customer-proxy-registrations/registrations |  200     |  201        |    400     |application/json |   application/json |02a18293-3e8b-4b90-9456-4cb291734386|  W6pR1aA0gX4aM2gC4aT5yU6xI8pV7nL3aM1pU8aL7oQ3cN7uC4   |    %NOTEMPTY%      | Bearer   | %NOTEMPTY% | 3600     | %NOTEMPTY% | ips | %RUNTIME%   | %RUNTIME%  |  SANCBK            |    3227d008-c390-4232-80f7-d71aeb0a1f77 |  914       |    At least one field is not present in request | 
#| request.json  | /sp/dev/dummy/encrypt  | https://10.158.239.131/sp/dev/v1/token/generation |   https://10.158.244.98/sp/dev/dummy/decrypt |    200    | application/json |   application/json |9d62bf35-e1a5-4871-9ba9-bc288f82f33a|  rH3kO2eE2fW2kW5tC5nJ4tW1bU3eC1nD7xA0jX8fY6rJ0kQ1rE   |    %NOTEMPTY%      | Bearer   | %NOTEMPTY% | 3600   | %NOTEMPTY% | ips | 
    ####################################### THE END ####################

 @02_06_Amendment_NonAmendableProxyType
Scenario Outline: 02_06_MPP_API_Amendent of Registration when a non amendable Proxy type is provided in the request.
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
 ################################################ Create Signature #####################################
#Given a encrypted output  "<cipherdata1>" and url "<decyptionEndpoint>" along with below headers under "%ENV%" environment
Given a REST API request "<signatureRequestFile>" and url "<signatureEndpoint>" along with below headers under "%ENV%" environment
#----------------------------------------------------------------------------------------
 # | Headers             |                          Value                                   |
#----------------------------------------------------------------------------------------
   | accept              |                          <accept>                                |
   | content-type        |                        <content type>                            |
   | x-ibm-client-id     |                       <x_ibm_client_id>                          |
When "POST" action is performed to genarate signature for "Proxy Registration"
Then the status code is "<statusCode>"
And "Json" response includes the following values as
#----------------------------------------------------------------------------------------
 # | Node            |                          Value                                   |
# ----------------------------------------------------------------------------------------
   | signature       |                       <Encrypted_Text>                           |
############################################## Generate Proxy Registration ########################
Given a REST API request "<signatureRequestFile>" and url "<registrationEndpoint>" along with below headers under "%ENV%" environment
#----------------------------------------------------------------------------------------
 # | Headers             |                          Value                                   |
#----------------------------------------------------------------------------------------
   | accept              |                          <accept>                                |
   | authorization       |                        <autorization>                           |
   | content-type        |                        <content type>                            |
   | signature           |                         <signature>                              |
   | participant-code    |                       <participant-code>                         |
   | x-ibm-client-id     |                       <x_ibm_client_id>                          |
When "POST" action is performed to genarate "Proxy Registration"
Then the status code is "<statusCode1>"
And "Json" response includes the following values as
#----------------------------------------------------------------------------------------
 # | Node              |                          Value                                   |
# ----------------------------------------------------------------------------------------
   | registrationId    |                       <Encrypted_Text>                           |
###########################################################################################
Given a REST API request "<signatureRequestFile>" and url "<signatureEndpoint>" along with below headers under "%ENV%" environment
#----------------------------------------------------------------------------------------
 # | Headers             |                          Value                                   |
#----------------------------------------------------------------------------------------
   | accept              |                          <accept>                                |
   | content-type        |                        <content type>                            |
   | x-ibm-client-id     |                       <x_ibm_client_id>                          |
And Perform the below Proxy Amendment for registration "<registration_ID>" and generate a new REST API request "<signatureRequestFileAmendment>"
#----------------------------------------------------------------------------------------
 # |    Keys                 |                          Value                                   |
#---------------------------------------------------------------------------------------  
   |  proxy.type             |                         <proxy_type>                  |
   |  proxy.value            |                         <proxy_value>                 |

When "POST" action is performed to genarate signature for "Proxy Amendment"
Then the status code is "<statusCode>"
And "Json" response includes the following values as
#----------------------------------------------------------------------------------------
 # | Node            |                          Value                                   |
# ----------------------------------------------------------------------------------------
   | signature       |                       <Encrypted_Text>                           |
 ############################################## Proxy Amendment  ########################
Given a REST API request "<requestFileNew>" and url "<registrationEndpoint>" along with below headers under "%ENV%" environment
#----------------------------------------------------------------------------------------
 # | Headers             |                          Value                                   |
#----------------------------------------------------------------------------------------
   | accept              |                          <accept>                                |
   | authorization       |                        <autorization>                            |
   | content-type        |                        <content type>                            |
   | signature           |                         <signature>                              |
   | participant-code    |                       <participant-code>                         |
   | x-ibm-client-id     |                       <x_ibm_client_id>                          |
When "PUT" action is performed for Proxy Amendment having registration ID "<registration_ID>"
Then the status code is "<statusCode2>"
And "Json" response includes the following values as
#----------------------------------------------------------------------------------------
 # | Node            |                          Value                                   |
# ----------------------------------------------------------------------------------------
   | ReasonCode    |                       <ReasonCode>                           |
   | Description   |                       <Description>                          | 
 ###########################################################################################

  Examples:
|   requestFile      |    signatureRequestFile  |   signatureRequestFileAmendment  | encyptionEndpoint     |       tokenEndpoint         |  decyptionEndpoint      |    signatureEndpoint   |              registrationEndpoint                     |statusCode| statusCode1 |statusCode2 |     accept       |   content type     |   x_ibm_client_id                  |                   x_ibm_client_secret                 |   Encrypted_Text   |token_type|access_token|expires_in|consented_on|scope|autorization | signature  | participant-code | Browser_Name  | Portal_Name |  Username      | Password    | registration_ID |  proxy_type |proxy_value   | ReasonCode| Description|         
| requestEncryption  | 02_01_generateSignature  |  02_06_generateSignatureAmendment|/sp/dev/dummy/encrypt  | /sp/dev/v1/token/generation |  /sp/dev/dummy/decrypt  | /sp/dev/dummy/generate | /sp/sit/v1/customer-proxy-registrations/registrations |  200     |  201        |    400     |application/json |   application/json |02a18293-3e8b-4b90-9456-4cb291734386|  W6pR1aA0gX4aM2gC4aT5yU6xI8pV7nL3aM1pU8aL7oQ3cN7uC4   |    %NOTEMPTY%      | Bearer   | %NOTEMPTY% | 3600     | %NOTEMPTY% | ips | %RUNTIME%   | %RUNTIME%  |  SANCBK           | Chrome		     |    MPP      | operator.admin | burger_01   |  %RUNTIME%	   |  NATID      | 1234567890123|  804      | The Proxy Type cannot be amended |
#| request.json  | /sp/dev/dummy/encrypt  | https://10.158.239.131/sp/dev/v1/token/generation |   https://10.158.244.98/sp/dev/dummy/decrypt |    200    | application/json |   application/json |9d62bf35-e1a5-4871-9ba9-bc288f82f33a|  rH3kO2eE2fW2kW5tC5nJ4tW1bU3eC1nD7xA0jX8fY6rJ0kQ1rE   |    %NOTEMPTY%      | Bearer   | %NOTEMPTY% | 3600   | %NOTEMPTY% | ips | 
    ####################################### THE END ####################
 @02_07_Amendment_DifferentAccType
Scenario Outline: 02_07_MPP_API_Amendent of Registration when an account type does not match with the Registration ID provided in the request.
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
 ################################################ Create Signature #####################################
#Given a encrypted output  "<cipherdata1>" and url "<decyptionEndpoint>" along with below headers under "%ENV%" environment
Given a REST API request "<signatureRequestFile>" and url "<signatureEndpoint>" along with below headers under "%ENV%" environment
#----------------------------------------------------------------------------------------
 # | Headers             |                          Value                                   |
#----------------------------------------------------------------------------------------
   | accept              |                          <accept>                                |
   | content-type        |                        <content type>                            |
   | x-ibm-client-id     |                       <x_ibm_client_id>                          |
When "POST" action is performed to genarate signature for "Proxy Registration"
Then the status code is "<statusCode>"
And "Json" response includes the following values as
#----------------------------------------------------------------------------------------
 # | Node            |                          Value                                   |
# ----------------------------------------------------------------------------------------
   | signature       |                       <Encrypted_Text>                           |
############################################## Generate Proxy Registration ########################
Given a REST API request "<signatureRequestFile>" and url "<registrationEndpoint>" along with below headers under "%ENV%" environment
#----------------------------------------------------------------------------------------
 # | Headers             |                          Value                                   |
#----------------------------------------------------------------------------------------
   | accept              |                          <accept>                                |
   | authorization       |                        <autorization>                           |
   | content-type        |                        <content type>                            |
   | signature           |                         <signature>                              |
   | participant-code    |                       <participant-code>                         |
   | x-ibm-client-id     |                       <x_ibm_client_id>                          |
When "POST" action is performed to genarate "Proxy Registration"
Then the status code is "<statusCode1>"
And "Json" response includes the following values as
#----------------------------------------------------------------------------------------
 # | Node              |                          Value                                   |
# ----------------------------------------------------------------------------------------
   | registrationId    |                       <Encrypted_Text>                           |
###########################################################################################
Given a REST API request "<signatureRequestFile>" and url "<signatureEndpoint>" along with below headers under "%ENV%" environment
#----------------------------------------------------------------------------------------
 # | Headers             |                          Value                                   |
#----------------------------------------------------------------------------------------
   | accept              |                          <accept>                                |
   | content-type        |                        <content type>                            |
   | x-ibm-client-id     |                       <x_ibm_client_id>                          |
And Perform the below Proxy Amendment for registration "<registration_ID>" and generate a new REST API request "<signatureRequestFileAmendment>"
#----------------------------------------------------------------------------------------
 # |    Keys                 |                          Value                                   |
#---------------------------------------------------------------------------------------  
   |  account.type           |                         <account_type>                  |
#   |  account.value            |                       <account_value>                  |
When "POST" action is performed to genarate signature for "Proxy Amendment"
Then the status code is "<statusCode>"
And "Json" response includes the following values as
#----------------------------------------------------------------------------------------
 # | Node            |                          Value                                   |
# ----------------------------------------------------------------------------------------
   | signature       |                       <Encrypted_Text>                           |
 ############################################## Proxy Amendment  ########################
Given a REST API request "<requestFileNew>" and url "<registrationEndpoint>" along with below headers under "%ENV%" environment
#----------------------------------------------------------------------------------------
 # | Headers             |                          Value                                   |
#----------------------------------------------------------------------------------------
   | accept              |                          <accept>                                |
   | authorization       |                        <autorization>                            |
   | content-type        |                        <content type>                            |
   | signature           |                         <signature>                              |
   | participant-code    |                       <participant-code>                         |
   | x-ibm-client-id     |                       <x_ibm_client_id>                          |
When "PUT" action is performed for Proxy Amendment having registration ID "<registration_ID>"
Then the status code is "<statusCode2>"
And "Json" response includes the following values as
#----------------------------------------------------------------------------------------
 # | Node            |                          Value                                   |
# ----------------------------------------------------------------------------------------
   | ReasonCode    |                       <ReasonCode>                           |
   | Description   |                       <Description>                          | 
 ###########################################################################################

  Examples:
|   requestFile      |    signatureRequestFile  |   signatureRequestFileAmendment  | encyptionEndpoint     |       tokenEndpoint         |  decyptionEndpoint      |    signatureEndpoint   |              registrationEndpoint                     |statusCode| statusCode1 |statusCode2 |     accept       |   content type     |   x_ibm_client_id                  |                   x_ibm_client_secret                 |   Encrypted_Text   |token_type|access_token|expires_in|consented_on|scope|autorization | signature  | participant-code |  registration_ID |  account_type|               account_value            | ReasonCode| Description|         
| requestEncryption  | 02_01_generateSignature  |  02_07_generateSignatureAmendment|/sp/dev/dummy/encrypt  | /sp/dev/v1/token/generation |  /sp/dev/dummy/decrypt  | /sp/dev/dummy/generate | /sp/sit/v1/customer-proxy-registrations/registrations |  200     |  201        |    400     |application/json |   application/json |02a18293-3e8b-4b90-9456-4cb291734386|  W6pR1aA0gX4aM2gC4aT5yU6xI8pV7nL3aM1pU8aL7oQ3cN7uC4   |    %NOTEMPTY%      | Bearer   | %NOTEMPTY% | 3600     | %NOTEMPTY% | ips | %RUNTIME%   | %RUNTIME%  |  SANCBK           |  %RUNTIME%	     |     TOKEN    | SANCBK12345678901 | 910       | The Account Type cannot be amended |
#| request.json  | /sp/dev/dummy/encrypt  | https://10.158.239.131/sp/dev/v1/token/generation |   https://10.158.244.98/sp/dev/dummy/decrypt |    200    | application/json |   application/json |9d62bf35-e1a5-4871-9ba9-bc288f82f33a|  rH3kO2eE2fW2kW5tC5nJ4tW1bU3eC1nD7xA0jX8fY6rJ0kQ1rE   |    %NOTEMPTY%      | Bearer   | %NOTEMPTY% | 3600   | %NOTEMPTY% | ips | 
    ####################################### THE END ####################
@02_08_Amendment_99Proxies
Scenario Outline: 02_08_MPP_API_Amendent of Registration when an account has more than 99 proxies associated with it.
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
 ################################################ Create Signature #####################################
#Given a encrypted output  "<cipherdata1>" and url "<decyptionEndpoint>" along with below headers under "%ENV%" environment
Given a REST API request "<signatureRequestFile>" and url "<signatureEndpoint>" along with below headers under "%ENV%" environment
#----------------------------------------------------------------------------------------
 # | Headers             |                          Value                                   |
#----------------------------------------------------------------------------------------
   | accept              |                          <accept>                                |
   | content-type        |                        <content type>                            |
   | x-ibm-client-id     |                       <x_ibm_client_id>                          |
When "POST" action is performed to genarate signature for "Proxy Registration"
Then the status code is "<statusCode>"
And "Json" response includes the following values as
#----------------------------------------------------------------------------------------
 # | Node            |                          Value                                   |
# ----------------------------------------------------------------------------------------
   | signature       |                       <Encrypted_Text>                           |
############################################## Generate Proxy Registration ########################
Given a REST API request "<signatureRequestFile>" and url "<registrationEndpoint>" along with below headers under "%ENV%" environment
#----------------------------------------------------------------------------------------
 # | Headers             |                          Value                                   |
#----------------------------------------------------------------------------------------
   | accept              |                          <accept>                                |
   | authorization       |                        <autorization>                           |
   | content-type        |                        <content type>                            |
   | signature           |                         <signature>                              |
   | participant-code    |                       <participant-code>                         |
   | x-ibm-client-id     |                       <x_ibm_client_id>                          |
When "POST" action is performed to genarate "Proxy Registration"
Then the status code is "<statusCode1>"
And "Json" response includes the following values as
#----------------------------------------------------------------------------------------
 # | Node              |                          Value                                   |
# ----------------------------------------------------------------------------------------
   | registrationId    |                       <Encrypted_Text>                           |
###########################################################################################
Given a REST API request "<signatureRequestFile>" and url "<signatureEndpoint>" along with below headers under "%ENV%" environment
#----------------------------------------------------------------------------------------
 # | Headers             |                          Value                                   |
#----------------------------------------------------------------------------------------
   | accept              |                          <accept>                                |
   | content-type        |                        <content type>                            |
   | x-ibm-client-id     |                       <x_ibm_client_id>                          |
And Perform the below Proxy Amendment for registration "<registration_ID>" and generate a new REST API request "<signatureRequestFileAmendment>"
#----------------------------------------------------------------------------------------
 # |    Keys                 |                          Value                                   |
#---------------------------------------------------------------------------------------  
   |  account.type           |                         <account_type>                  |
   |  account.value            |                       <account_value>                  |
When "POST" action is performed to genarate signature for "Proxy Amendment"
Then the status code is "<statusCode>"
And "Json" response includes the following values as
#----------------------------------------------------------------------------------------
 # | Node            |                          Value                                   |
# ----------------------------------------------------------------------------------------
   | signature       |                       <Encrypted_Text>                           |
 ############################################## Proxy Amendment  ########################
Given a REST API request "<requestFileNew>" and url "<registrationEndpoint>" along with below headers under "%ENV%" environment
#----------------------------------------------------------------------------------------
 # | Headers             |                          Value                                   |
#----------------------------------------------------------------------------------------
   | accept              |                          <accept>                                |
   | authorization       |                        <autorization>                            |
   | content-type        |                        <content type>                            |
   | signature           |                         <signature>                              |
   | participant-code    |                       <participant-code>                         |
   | x-ibm-client-id     |                       <x_ibm_client_id>                          |
When "PUT" action is performed for Proxy Amendment having registration ID "<registration_ID>"
Then the status code is "<statusCode2>"
And "Json" response includes the following values as
#----------------------------------------------------------------------------------------
 # | Node            |                          Value                                   |
# ----------------------------------------------------------------------------------------
   | ReasonCode    |                       <ReasonCode>                           |
   | Description   |                       <Description>                          | 
 ###########################################################################################

  Examples:
|   requestFile      |    signatureRequestFile  |   signatureRequestFileAmendment  | encyptionEndpoint     |       tokenEndpoint         |  decyptionEndpoint      |    signatureEndpoint   |              registrationEndpoint                     |statusCode| statusCode1 |statusCode2 |     accept       |   content type     |   x_ibm_client_id                  |                   x_ibm_client_secret                 |   Encrypted_Text   |token_type|access_token|expires_in|consented_on|scope|autorization | signature  | participant-code |  registration_ID |  account_type|  account_value    | ReasonCode|                           Description                                   |         
| requestEncryption  | 02_01_generateSignature  |  02_08_generateSignatureAmendment|/sp/dev/dummy/encrypt  | /sp/dev/v1/token/generation |  /sp/dev/dummy/decrypt  | /sp/dev/dummy/generate | /sp/sit/v1/customer-proxy-registrations/registrations |  200     |  201        |    400     |application/json |   application/json |02a18293-3e8b-4b90-9456-4cb291734386|  W6pR1aA0gX4aM2gC4aT5yU6xI8pV7nL3aM1pU8aL7oQ3cN7uC4   |    %NOTEMPTY%      | Bearer   | %NOTEMPTY% | 3600     | %NOTEMPTY% | ips | %RUNTIME%   | %RUNTIME%  |  SANCBK           |  %RUNTIME%	     |     BANKAC   | SANCBK12345678901 | 944       | Maximum permitted number of proxies already linked to specified account |
#| request.json  | /sp/dev/dummy/encrypt  | https://10.158.239.131/sp/dev/v1/token/generation |   https://10.158.244.98/sp/dev/dummy/decrypt |    200    | application/json |   application/json |9d62bf35-e1a5-4871-9ba9-bc288f82f33a|  rH3kO2eE2fW2kW5tC5nJ4tW1bU3eC1nD7xA0jX8fY6rJ0kQ1rE   |    %NOTEMPTY%      | Bearer   | %NOTEMPTY% | 3600   | %NOTEMPTY% | ips | 
    ####################################### THE END ####################
 #"registrationId": "b5f538cc-be90-4596-8363-5fe965ce8377"  // In active
 #"registrationId": "3227d008-c390-4232-80f7-d71aeb0a1f77"  //  active
 
 
 
 
 
 
 
 
 

