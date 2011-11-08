@changes_database
Feature: Login
	In order to all features of the applicattion
	As a user
	I want to login to the application


Scenario: Create new account
	Given I have navigated to the account registration page
	Then I should be able to enter my user name
	And I should be able to enter my email address
	And I should be able to enter my password
	And I should be able to confirm my passowrd
	And i should be able to click the register button
