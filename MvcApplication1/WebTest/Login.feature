Feature: Login
	In order to all features of the applicattion
	As a user
	I want to login to the application

@mytag
Scenario: Create new account
	Given I have navigated to the account registration page
	And I have entered as user name: User
	And I have entered as email address: mail@user.com
	And I have entered as password: pw4User
	When I press register
	Then I should see on the home page the message: Welcome User!
