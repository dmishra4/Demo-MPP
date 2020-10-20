Feature: 001_MPP_API_Create registration with single proxy for individual account
@01_01_Create_IndividualRegistration
Scenario Outline: 001_MPP_API_Create registration with single proxy for individual account
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
 ############################################## Proxy Amendment  ########################
  Examples:
|   requestFile      | signatureRequestFile |  encyptionEndpoint     |       tokenEndpoint         |  decyptionEndpoint      |    signatureEndpoint   |              registrationEndpoint                     |statusCode| statusCode1 |statusCode2 |     accept       |   content type     |   x_ibm_client_id                  |                   x_ibm_client_secret                 |   Encrypted_Text   |token_type|access_token|expires_in|consented_on|scope|autorization | signature  | participant-code | Browser_Name  | Portal_Name |  Username      | Password    | Registration_Id  |
| requestEncryption  |   generateSignature  | /sp/dev/dummy/encrypt  | /sp/dev/v1/token/generation |  /sp/dev/dummy/decrypt  | /sp/dev/dummy/generate | /sp/sit/v1/customer-proxy-registrations/registrations |  200     |  201        |    204     |application/json |   application/json |02a18293-3e8b-4b90-9456-4cb291734386|  W6pR1aA0gX4aM2gC4aT5yU6xI8pV7nL3aM1pU8aL7oQ3cN7uC4   |    %NOTEMPTY%      | Bearer   | %NOTEMPTY% | 3600     | %NOTEMPTY% | ips | %RUNTIME%   | %RUNTIME%  |  SABMUS           | Chrome		    |    MPP      | operator.admin | burger_01   |  %RUNTIME%	      |   
#| request.json  | /sp/dev/dummy/encrypt  | https://10.158.239.131/sp/dev/v1/token/generation |   https://10.158.244.98/sp/dev/dummy/decrypt |    200    | application/json |   application/json |9d62bf35-e1a5-4871-9ba9-bc288f82f33a|  rH3kO2eE2fW2kW5tC5nJ4tW1bU3eC1nD7xA0jX8fY6rJ0kQ1rE   |    %NOTEMPTY%      | Bearer   | %NOTEMPTY% | 3600   | %NOTEMPTY% | ips |
############################################################################################
@01_02_Create_BusinessRegistration
Scenario Outline: 001_MPP_API_Create registration with single proxy for business
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
|   requestFile      |    signatureRequestFile    |  encyptionEndpoint     |       tokenEndpoint         |  decyptionEndpoint      |    signatureEndpoint   |              registrationEndpoint                     |statusCode| statusCode1 |statusCode2 |     accept       |   content type     |   x_ibm_client_id                  |                   x_ibm_client_secret                 |   Encrypted_Text   |token_type|access_token|expires_in|consented_on|scope|autorization | signature  | participant-code | Browser_Name  | Portal_Name |  Username      | Password    | Registration_Id  |
| requestEncryption  |   01_02_generateSignature  | /sp/dev/dummy/encrypt  | /sp/dev/v1/token/generation |  /sp/dev/dummy/decrypt  | /sp/dev/dummy/generate | /sp/sit/v1/customer-proxy-registrations/registrations |  200     |  201        |    204     |application/json |   application/json |02a18293-3e8b-4b90-9456-4cb291734386|  W6pR1aA0gX4aM2gC4aT5yU6xI8pV7nL3aM1pU8aL7oQ3cN7uC4   |    %NOTEMPTY%      | Bearer   | %NOTEMPTY% | 3600     | %NOTEMPTY% | ips | %RUNTIME%   | %RUNTIME%  |  SANCBK           | Chrome		    |    MPP      | operator.admin | burger_01   |  %RUNTIME%	      |   
#| request.json  | /sp/dev/dummy/encrypt  | https://10.158.239.131/sp/dev/v1/token/generation |   https://10.158.244.98/sp/dev/dummy/decrypt |    200    | application/json |   application/json |9d62bf35-e1a5-4871-9ba9-bc288f82f33a|  rH3kO2eE2fW2kW5tC5nJ4tW1bU3eC1nD7xA0jX8fY6rJ0kQ1rE   |    %NOTEMPTY%      | Bearer   | %NOTEMPTY% | 3600   | %NOTEMPTY% | ips |
@01_03_Create_TechErrorRegistration
Scenario Outline: 01_03_MPP_API_Technical error cases of Registration API for creation of Registration
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
   | httpCode      |                       <httpCode>                              |
   | httpMessage   |                       <httpMessage>                           |
###########################################################################################
  Examples:
|   requestFile      |    signatureRequestFile    |  encyptionEndpoint     |       tokenEndpoint         |  decyptionEndpoint      |    signatureEndpoint   |              registrationEndpoint                     |statusCode| statusCode1 |statusCode2 |     accept       |   content type     |   x_ibm_client_id                  |                   x_ibm_client_secret                 |   Encrypted_Text   |token_type|access_token|expires_in|consented_on|scope|autorization | signature  | participant-code  |httpCode | httpMessage|
| requestEncryption  |   01_03_generateSignature  | /sp/dev/dummy/encrypt  | /sp/dev/v1/token/generation |  /sp/dev/dummy/decrypt  | /sp/dev/dummy/generate | /sp/sit/v1/customer-proxy-registrations/registrations |  200     |  422        |    204     |application/json |   application/json |02a18293-3e8b-4b90-9456-4cb291734386|  W6pR1aA0gX4aM2gC4aT5yU6xI8pV7nL3aM1pU8aL7oQ3cN7uC4   |    %NOTEMPTY%      | Bearer   | %NOTEMPTY% | 3600     | %NOTEMPTY% | ips | %RUNTIME%   | %RUNTIME%  |  SANCBK           |   422   | Invalid  |
#| request.json  | /sp/dev/dummy/encrypt  | https://10.158.239.131/sp/dev/v1/token/generation |   https://10.158.244.98/sp/dev/dummy/decrypt |    200    | application/json |   application/json |9d62bf35-e1a5-4871-9ba9-bc288f82f33a|  rH3kO2eE2fW2kW5tC5nJ4tW1bU3eC1nD7xA0jX8fY6rJ0kQ1rE   |    %NOTEMPTY%      | Bearer   | %NOTEMPTY% | 3600   | %NOTEMPTY% | ips |
######################################################################################
######################################################################################
@01_04_Create_BusinessErrorRegistration
Scenario Outline: 01_04_MPP_API_Technical error cases of Registration API for creation of Registration
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
   | ReasonCode    |                       <ReasonCode>                           |
   | Description   |                       <Description>                          |
###########################################################################################
  Examples:
|   requestFile      |    signatureRequestFile    |  encyptionEndpoint     |       tokenEndpoint         |  decyptionEndpoint      |    signatureEndpoint   |              registrationEndpoint                     |statusCode| statusCode1 |statusCode2 |     accept       |   content type     |   x_ibm_client_id                  |                   x_ibm_client_secret                 |   Encrypted_Text   |token_type|access_token|expires_in|consented_on|scope|autorization | signature  | participant-code | Browser_Name  | Portal_Name |  Username      | Password    | Registration_Id  | ReasonCode | Description |
| requestEncryption  |   01_04_generateSignature  | /sp/dev/dummy/encrypt  | /sp/dev/v1/token/generation |  /sp/dev/dummy/decrypt  | /sp/dev/dummy/generate | /sp/sit/v1/customer-proxy-registrations/registrations |  200     |  400        |    204     |application/json |   application/json |02a18293-3e8b-4b90-9456-4cb291734386|  W6pR1aA0gX4aM2gC4aT5yU6xI8pV7nL3aM1pU8aL7oQ3cN7uC4   |    %NOTEMPTY%      | Bearer   | %NOTEMPTY% | 3600     | %NOTEMPTY% | ips | %RUNTIME%   | %RUNTIME%  |  SANCBK           | Chrome		    |    MPP      | operator.admin | burger_01   |  %RUNTIME%	      |   908      |    The registration cannot have an account holder of person and business      |
#| request.json  | /sp/dev/dummy/encrypt  | https://10.158.239.131/sp/dev/v1/token/generation |   https://10.158.244.98/sp/dev/dummy/decrypt |    200    | application/json |   application/json |9d62bf35-e1a5-4871-9ba9-bc288f82f33a|  rH3kO2eE2fW2kW5tC5nJ4tW1bU3eC1nD7xA0jX8fY6rJ0kQ1rE   |    %NOTEMPTY%      | Bearer   | %NOTEMPTY% | 3600   | %NOTEMPTY% | ips |
############################################################################################
@01_05_CreateReg_WrongAccType
Scenario Outline: 01_05_MPP_API_Business error ( Wrong Account Type) cases of Registration API for creation of Registration
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
   | ReasonCode    |                       <ReasonCode>                           |
   | Description   |                       <Description>                           |
###########################################################################################
  Examples:
|   requestFile      |    signatureRequestFile    |  encyptionEndpoint     |       tokenEndpoint         |  decyptionEndpoint      |    signatureEndpoint   |              registrationEndpoint                     |statusCode| statusCode1 |statusCode2 |     accept       |   content type     |   x_ibm_client_id                  |                   x_ibm_client_secret                 |   Encrypted_Text   |token_type|access_token|expires_in|consented_on|scope|autorization | signature  | participant-code | ReasonCode |          Description         |
| requestEncryption  |   01_05_generateSignature  | /sp/dev/dummy/encrypt  | /sp/dev/v1/token/generation |  /sp/dev/dummy/decrypt  | /sp/dev/dummy/generate | /sp/sit/v1/customer-proxy-registrations/registrations |  200     |  400        |    204     |application/json |   application/json |02a18293-3e8b-4b90-9456-4cb291734386|  W6pR1aA0gX4aM2gC4aT5yU6xI8pV7nL3aM1pU8aL7oQ3cN7uC4   |    %NOTEMPTY%      | Bearer   | %NOTEMPTY% | 3600     | %NOTEMPTY% | ips | %RUNTIME%   | %RUNTIME%  |  SANCBK           |   902      |    Account Type is not valid |
############################################################################################
@01_06_CreateReg_SameAccName
Scenario Outline: 01_06_MPP_API_Business error ( Same Account Name ) cases of Registration API for creation of Registration
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
   | ReasonCode    |                       <ReasonCode>                           |
   | Description   |                       <Description>                           |
###########################################################################################
  Examples:
|   requestFile      |    signatureRequestFile    |  encyptionEndpoint     |       tokenEndpoint         |  decyptionEndpoint      |    signatureEndpoint   |              registrationEndpoint                     |statusCode| statusCode1 |statusCode2 |     accept       |   content type     |   x_ibm_client_id                  |                   x_ibm_client_secret                 |   Encrypted_Text   |token_type|access_token|expires_in|consented_on|scope|autorization | signature  | participant-code | ReasonCode |          Description         |
| requestEncryption  |   01_06_generateSignature  | /sp/dev/dummy/encrypt  | /sp/dev/v1/token/generation |  /sp/dev/dummy/decrypt  | /sp/dev/dummy/generate | /sp/sit/v1/customer-proxy-registrations/registrations |  200     |  400        |    204     |application/json |   application/json |02a18293-3e8b-4b90-9456-4cb291734386|  W6pR1aA0gX4aM2gC4aT5yU6xI8pV7nL3aM1pU8aL7oQ3cN7uC4   |    %NOTEMPTY%      | Bearer   | %NOTEMPTY% | 3600     | %NOTEMPTY% | ips | %RUNTIME%   | %RUNTIME%  |  SANCBK           |   902      |    Account Type is not valid |
############################################################################################
@01_07_CreateReg_99Proxies
Scenario Outline: 01_07_MPP_API_Business error ( 99 Proxies Associated ) cases of Registration API for creation of Registration
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
   | ReasonCode    |                       <ReasonCode>                           |
   | Description   |                       <Description>                           |
###########################################################################################
  Examples:
|   requestFile      |    signatureRequestFile    |  encyptionEndpoint     |       tokenEndpoint         |  decyptionEndpoint      |    signatureEndpoint   |              registrationEndpoint                     |statusCode| statusCode1 |statusCode2 |     accept       |   content type     |   x_ibm_client_id                  |                   x_ibm_client_secret                 |   Encrypted_Text   |token_type|access_token|expires_in|consented_on|scope|autorization | signature  | participant-code | ReasonCode |          Description         |
| requestEncryption  |   01_07_generateSignature  | /sp/dev/dummy/encrypt  | /sp/dev/v1/token/generation |  /sp/dev/dummy/decrypt  | /sp/dev/dummy/generate | /sp/sit/v1/customer-proxy-registrations/registrations |  200     |  400        |    204     |application/json |   application/json |02a18293-3e8b-4b90-9456-4cb291734386|  W6pR1aA0gX4aM2gC4aT5yU6xI8pV7nL3aM1pU8aL7oQ3cN7uC4   |    %NOTEMPTY%      | Bearer   | %NOTEMPTY% | 3600     | %NOTEMPTY% | ips | %RUNTIME%   | %RUNTIME%  |  SANCBK           |   902      |    Account Type is not valid |
############################################################################################
@01_08_CreateReg_WrongProxyType
Scenario Outline: 01_06_MPP_API_Business error ( Wrong Proxy Type ) cases of Registration API for creation of Registration
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
   | ReasonCode    |                       <ReasonCode>                           |
   | Description   |                       <Description>                           |
###########################################################################################
  Examples:
|   requestFile      |    signatureRequestFile    |  encyptionEndpoint     |       tokenEndpoint         |  decyptionEndpoint      |    signatureEndpoint   |              registrationEndpoint                     |statusCode| statusCode1 |statusCode2 |     accept       |   content type     |   x_ibm_client_id                  |                   x_ibm_client_secret                 |   Encrypted_Text   |token_type|access_token|expires_in|consented_on|scope|autorization | signature  | participant-code | ReasonCode |          Description         |
| requestEncryption  |   01_08_generateSignature  | /sp/dev/dummy/encrypt  | /sp/dev/v1/token/generation |  /sp/dev/dummy/decrypt  | /sp/dev/dummy/generate | /sp/sit/v1/customer-proxy-registrations/registrations |  200     |  400        |    204     |application/json |   application/json |02a18293-3e8b-4b90-9456-4cb291734386|  W6pR1aA0gX4aM2gC4aT5yU6xI8pV7nL3aM1pU8aL7oQ3cN7uC4   |    %NOTEMPTY%      | Bearer   | %NOTEMPTY% | 3600     | %NOTEMPTY% | ips | %RUNTIME%   | %RUNTIME%  |  SANCBK           |   802      |    Proxy Type is not valid |