Feature: Checking then API endpoint that can add comments to a gist.

  Background:
    * url 'https://api.github.com'
    * header Accept = 'application/vnd.github.v3+json'
    * def gist_id = '482e713609b587bce895f14884d470ca'
    * def now = function(){ return java.lang.System.currentTimeMillis() }
    * def token = 'Basic aW1yYW4xMzY6Z2hwX3IxdG1iVjNKTEN3QlV6OVBjd09Ic0xpMzZkMHhqZjNkN0M5Uw=='

#HappyFlow
  Scenario: GCH-01: As an authenticated GitHub user, I am able to make a comment in my gist and verify that comment as well
    * header Authorization = token
    * def comment = 'Comment is current time in epoch ' + now()
    * def body = {"body":'#(comment)'}

    #https://api.github.com/gists/482e713609b587bce895f14884d470ca/comments
    Given path 'gists', gist_id, 'comments'
    And request body
    When method post
    #Checking the proper status code is given or not
    Then status 201

    #Checking if the returned comment is correct or not on post response
    * assert response.body == comment
    * def commentUrl = response.url

    #Making a GET call to retrieve the comment that was just made by post
    Given url commentUrl
    When method get
    Then status 200

    #Checking if the returned
    * assert response.body == comment


#ErrorFlow
  Scenario: GCE-01: As an un-authenticated user, I am NOT able to make a comment in gist
    * def comment = 'Comment is current time in epoch ' + now()
    * def body = {"body":'#(comment)'}

    #https://api.github.com/gists/482e713609b587bce895f14884d470ca/comments
    Given path 'gists', gist_id, 'comments'
    And request body
    When method post
    #Checking the proper status code is given or not
    Then status 401

    #Checking the response message contains proper error or not
    * assert response.message == 'Requires authentication'


  Scenario: GCE-02: As an authenticated GitHub user, I am NOT able to make a comment in gist without proper comment
    * header Authorization = token
    * def body = 'Not a proper comment'

    #https://api.github.com/gists/482e713609b587bce895f14884d470ca/comments
    Given path 'gists', gist_id, 'comments'
    And request body
    When method post
    #Checking the proper status code is given or not
    Then status 400

    #Checking the response message contains proper error or not
    * assert response.message == 'Problems parsing JSON'


  Scenario: GCE-03: As an user with wrong authentication, I am NOT able to make a comment in gist
    * header Authorization = 'Basic aW1yYW4xMzY6Z2hwX3IxdG1iVjNKTEN3QlV6OVBjd09Ic0xpMzZkMHhqWRONGTOKEN=='
    * def comment = 'Comment is current time in epoch ' + now()
    * def body = {"body":'#(comment)'}

    #https://api.github.com/gists/482e713609b587bce895f14884d470ca/comments
    Given path 'gists', gist_id, 'comments'
    And request body
    When method post
    #Checking the proper status code is given or not
    Then status 401

    #Checking the response message contains proper error or not
    * assert response.message == 'Requires authentication'

  Scenario: GCE-04: As an authenticated GitHub user, I am NOT able to make a comment in my gist when path is incorrect
    * header Authorization = token
    * def comment = 'Comment is current time in epoch ' + now()
    * def body = {"body":'#(comment)'}

    #https://api.github.com/gists/482e713609b587bce895f14884d470ca
    Given path 'gists', gist_id
    And request body
    When method post
    #Checking the proper status code is given or not
    Then status 422

    #Checking the response message contains proper error or not
    * match response.message contains 'Invalid request'


  Scenario: GCE-05: As an user, I am NOT able to make a comment in my gist when gist_id is incorrect
    * header Authorization = token
    * def comment = 'Comment is current time in epoch ' + now()
    * def body = {"body":'#(comment)'}

    #https://api.github.com/gists/482e713609b587bce895f14884d470ca/comments
    Given path 'gists', '482e713609b587bce895f148incorrect', 'comments'
    And request body
    When method post
    #Checking the proper status code is given or not
    Then status 404

    #Checking the response message contains proper error or not
    * match response.message contains 'Not Found'